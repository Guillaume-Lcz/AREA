import { google } from 'googleapis';
import { oauth2Client } from '../configs/googleConfig.js';
import { ModelUser } from '../schemas/user.js';
import { ModelArea } from '../schemas/actionReaction.js';
import _ from 'lodash';

async function refrechToken(user) {
    const token = user.servicesData.get("google").accessToken;
    try {
        if (oauth2Client.isTokenExpiring()) {
            const { token: newAccessToken } = await oauth2Client.refreshAccessToken();
            user.servicesData.get("google").accessToken = newAccessToken;
            await user.save();
            oauth2Client.setCredentials({ access_token: newAccessToken });
        } else {
            oauth2Client.setCredentials({ access_token: token });
        }
        return google.drive({ version: 'v3', auth: oauth2Client });
    } catch (error) {
        console.error('Error refreshing token:', error);
        throw new Error('Error refreshing token');
    }
}

const createFolderAndFile = async (user, folderName, fileName, fileContent) => {
    try {
        const drive = await refrechToken(user);
        const folderResponse = await drive.files.list({
            q: `name='${folderName}' and mimeType='application/vnd.google-apps.folder'`,
            fields: 'files(id, name)',
        });

        let folderId;

        if (folderResponse.data.files.length === 0) {
            const folderMetadata = {
                name: folderName,
                mimeType: 'application/vnd.google-apps.folder',
            };

            const folderCreationResponse = await drive.files.create({
                resource: folderMetadata,
                fields: 'id',
            });

            folderId = folderCreationResponse.data.id;
        } else {
            folderId = folderResponse.data.files[0].id;
        }

        const fileMetadata = {
            name: fileName,
            parents: [folderId],
        };

        const fileCreationResponse = await drive.files.create({
            resource: fileMetadata,
            media: {
                mimeType: 'text/plain',
                body: fileContent,
            },
            fields: 'id, name',
        });

        const fileId = fileCreationResponse.data.id;
        const fileNameCreated = fileCreationResponse.data.name;

        return { folderId, fileId, fileName: fileNameCreated };
    } catch (error) {
        console.error('Error during creating folder and file:', error);
        throw new Error('Error during creating folder and file');
    }
};

async function driveReactionMapped(area, i) {
    const user = await ModelUser.findOne({ _id: area.userId });
    try {
        if (area.reaction[i].name === "new_file") {
            await createFolderAndFile(user, area.reaction[i].data.folder_name, area.reaction[i].data.file_name, area.reaction[i].data.file_content);
        }
    } catch (error) {
        console.error('Error in Drive triggers:', error);
    }
}
async function getFolderAction(area, user, react)
{
    const infoFodler = await getLastNewFileAction(user, area.action.data.folder_name);
    if (
      area.action.dataLocalServer?.driverTrigger?.infoFolder &&
      !_.isEqual(
        area.action.dataLocalServer.driverTrigger.infoFolder,
        infoFodler
      )
    ) {
      react(area);
    }
    if (area.action.dataLocalServer?.driverTrigger?.infoFolder) {
      delete area.action.dataLocalServer.driverTrigger.infoFolder;
    }
    const toSend = {
      driverTrigger: {
        ...(area.action.dataLocalServer?.driverTrigger || {}),
        infoFolder: infoFodler,
      },
    };
    area.action.dataLocalServer.driverTrigger = toSend.driverTrigger;
    await ModelArea.findByIdAndUpdate(area._id, area);
}

async function getLastNewFileAction(user, folderName) {
    try {
        const drive = await refrechToken(user);
        const folderResponse = await drive.files.list({
            q: `name='${folderName}' and mimeType='application/vnd.google-apps.folder'`,
            fields: 'files(id, name)'
        });

        let folderId;
        if (folderResponse.data.files.length === 0) {
            const folderMetadata = {
                name: folderName,
                mimeType: 'application/vnd.google-apps.folder'
            };
            const folderCreationResponse = await drive.files.create({
                resource: folderMetadata,
                fields: 'id'
            });
            folderId = folderCreationResponse.data.id;
        } else {
            folderId = folderResponse.data.files[0].id;
        }
        const filesResponse = await drive.files.list({
            q: `'${folderId}' in parents`,
            pageSize: 1,
            orderBy: 'modifiedTime desc',
            fields: 'files(id, name, mimeType, modifiedTime)'
        });
        const file = filesResponse.data.files;
        return file;
    } catch (error) {
        console.error('Error during fetching files:', error);
        throw error;
    }
}

async function driveTrigger(area, react)
{
    try {
        const user = await ModelUser.findOne({ _id: area.userId });
        if (area.action.name == "get_folder_action") {
            await getFolderAction(area, user, react);
        }
    } catch (error) {
        console.error('Error in trigger:', error);
    }
}

function driveTriggers(area, react)
{
    driveTrigger(area, react)
}

function driveReactions(area) {
    for (var i = 0; area.reaction.length > i; i++) {
        driveReactionMapped(area, i)
    }
}

export { driveReactions, driveTriggers };
