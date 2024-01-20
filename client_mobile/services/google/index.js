const express = require('express');
const session = require('express-session');
const bodyParser = require('body-parser');
const { google } = require('googleapis');

const oauth2Client = new google.auth.OAuth2(
    "9267004214-ij67caut9rl8jvbcr7a1fb1hhrosboki.apps.googleusercontent.com",
    "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",
    "http://localhost:4000/auth/google/callback"
);

const app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use(session({
    secret: 'prout',
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false } 
}));

app.get('/auth/google', (req, res) => {
    const authUrl = oauth2Client.generateAuthUrl({
        access_type: 'offline',
        scope: [
            "https://www.googleapis.com/auth/gmail.readonly", 
            "https://www.googleapis.com/auth/gmail.send",
            "https://www.googleapis.com/auth/drive.readonly",
            "https://www.googleapis.com/auth/drive.file",
            "https://www.googleapis.com/auth/calendar.events"
        ]
    });
    res.redirect(authUrl);
});

app.get('/auth/google/callback', async (req, res) => {
    const { code } = req.query;

    if (!code) {
        return res.status(400).send('Authorization code missing');
    }

    try {
        const { tokens } = await oauth2Client.getToken(code);
        oauth2Client.setCredentials(tokens);
        req.session.tokens = tokens;
        res.send(tokens);
    } catch (error) {
        console.error('Error during token exchange:', error);
        res.status(500).send('Error during token exchange');
    }
});

function extractMailInformation(message) {
    const headers = message.payload.headers;
    const subjectHeader = headers.find(header => header.name === 'Subject');
    const fromHeader = headers.find(header => header.name === 'From');
    const dateHeader = headers.find(header => header.name === 'Date');

    const subject = subjectHeader ? subjectHeader.value : 'No Subject';
    const sender = fromHeader ? fromHeader.value : 'Unknown Sender';
    const date = dateHeader ? new Date(dateHeader.value) : 'Unknown Date';

    let body = '';

    if (message.payload.parts) {
        const bodyPart = message.payload.parts.find(part => part.mimeType === 'text/plain');
        if (bodyPart && bodyPart.body) {
            body = Buffer.from(bodyPart.body.data, 'base64').toString();
        }
    }

    return { subject, body, sender, date };
}

app.get('/gmail/getLast5mails', async (req, res) => {
    if (req.session.tokens) {
        oauth2Client.setCredentials(req.session.tokens);
    } else {
        return res.status(401).send('Not authenticated');
    }
    try {
        const messagesResponse = await gmail.users.messages.list({
            userId: 'me',
            maxResults: 5
        });
        const messageIds = messagesResponse.data.messages.map(message => message.id);
        const messages = await Promise.all(messageIds.map(async messageId => {
            const messageResponse = await gmail.users.messages.get({
                userId: 'me',
                id: messageId,
            });
            const { subject, body, sender, date } = extractMailInformation(messageResponse.data);
            return { subject, body, sender, date };
        }));
        res.json({ messages });
    } catch (error) {
        console.error('Error during fetching messages:', error);
        res.status(500).send('Error during fetching messages');
    }
});

app.get('/gmail/getLastSentMail', async (req, res) => {
    if (req.session.tokens) {
        oauth2Client.setCredentials(req.session.tokens);
    } else {
        return res.status(401).send('Not authenticated');
    }

    try {
        const messagesResponse = await gmail.users.messages.list({
            userId: 'me',
            maxResults: 1,
            q: 'from:me'
        });

        const messageId = messagesResponse.data.messages[0].id;

        const messageResponse = await gmail.users.messages.get({
            userId: 'me',
            id: messageId,
        });

        const { subject, body, sender, date } = extractMailInformation(messageResponse.data);

        res.json({ subject, body, sender, date });
    } catch (error) {
        console.error('Error during fetching messages:', error);
        res.status(500).send('Error during fetching messages');
    }
});

app.get('/gmail/sendMail', (req, res) => {
    res.send(`
        <form action="/gmail/sendMail" method="post">
            <label for="to">To:</label><br>
            <input type="text" id="to" name="to"><br>
            <label for="subject">Subject:</label><br>
            <input type="text" id="subject" name="subject"><br>
            <label for="message">Message:</label><br>
            <textarea id="message" name="message"></textarea><br>
            <input type="submit" value="Submit">
        </form>
    `);
});

function makeBody(to, from, subject, message) {
    let str = [
        "Content-Type: text/plain; charset=\"UTF-8\"\n",
        "MIME-Version: 1.0\n",
        "Content-Transfer-Encoding: 7bit\n",
        "to: ", to, "\n",
        "from: ", from, "\n",
        "subject: ", subject, "\n\n",
        message
    ].join('');

    return str;
}

app.post('/gmail/sendMail', async (req, res) => {
    if (req.session.tokens) {
        oauth2Client.setCredentials(req.session.tokens);
    } else {
        return res.status(401).send('Not authenticated');
    }

    try {
        const profile = await gmail.users.getProfile({ userId: 'me' });
        const from = profile.data.emailAddress;

        const raw = makeBody(req.body.to, from, req.body.subject, req.body.message);
        const encodedMessage = Buffer.from(raw).toString('base64').replace(/\+/g, '-').replace(/\//g, '_');

        const result = await gmail.users.messages.send({
            userId: 'me',
            requestBody: {
                raw: encodedMessage
            }
        });

        res.send('Email sent!');
    } catch (error) {
        console.error('Error during sending email:', error);
        res.status(500).send('Error during sending email');
    }
});
const createFolderAndFile = async (folderName, fileName, fileContent) => {
    if (req.session.tokens) {
        oauth2Client.setCredentials(req.session.tokens);
    } else {
        return;
    }

    try {
        // Vérifier si le dossier existe déjà
        const folderResponse = await drive.files.list({
            q: `name='${folderName}' and mimeType='application/vnd.google-apps.folder'`,
            fields: 'files(id, name)'
        });

        let folderId;
        
        if (folderResponse.data.files.length === 0) {
            // Le dossier n'existe pas, le créer
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
            // Le dossier existe déjà
            folderId = folderResponse.data.files[0].id;
        }

        // Créer un fichier à l'intérieur du dossier
        const fileMetadata = {
            name: fileName,
            parents: [folderId]
        };

        const fileCreationResponse = await drive.files.create({
            resource: fileMetadata,
            media: {
                mimeType: 'text/plain',
                body: fileContent
            },
            fields: 'id, name'
        });

        const fileId = fileCreationResponse.data.id;
        const fileNameCreated = fileCreationResponse.data.name;

        res.json({ folderId, fileId, fileName: fileNameCreated });
    } catch (error) {
        console.error('Error during creating folder and file:', error);
        res.status(500).send('Error during creating folder and file');
    }
};
///////////////////// DRIVE ////////////////////////////////
const drive = google.drive({ version: 'v3', auth: oauth2Client });
app.get('/drive/createFolderAndFile', async (req, res) => {
    const folderName = "test";
    const fileName = "test.txt";
    const fileContent = "Hello, this is the content of the file!";

    try {
        if (!req.session.tokens) {
            return res.status(401).send('Not authenticated');
        }

        // Vérifier si le dossier existe déjà
        const folderResponse = await drive.files.list({
            q: `name='${folderName}' and mimeType='application/vnd.google-apps.folder'`,
            fields: 'files(id, name)'
        });

        let folderId;
        
        if (folderResponse.data.files.length === 0) {
            // Le dossier n'existe pas, le créer
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
            // Le dossier existe déjà
            folderId = folderResponse.data.files[0].id;
        }

        // Créer un fichier à l'intérieur du dossier
        const fileMetadata = {
            name: fileName,
            parents: [folderId]
        };

        const fileCreationResponse = await drive.files.create({
            resource: fileMetadata,
            media: {
                mimeType: 'text/plain',
                body: fileContent
            },
            fields: 'id, name'
        });

        const fileId = fileCreationResponse.data.id;
        const fileNameCreated = fileCreationResponse.data.name;

        res.json({ folderId, fileId, fileName: fileNameCreated });
    } catch (error) {
        console.error('Error during creating folder and file:', error);
        res.status(500).send('Error during creating folder and file');
    }
});

app.get('/drive/getLastUploadedFile', async (req, res) => {
    if (req.session.tokens) {
        oauth2Client.setCredentials(req.session.tokens);
    } else {
        return res.status(401).send('Not authenticated');
    }
    
    try {
        const filesResponse = await drive.files.list({
            pageSize: 1,
            orderBy: 'modifiedTime desc',
            fields: 'files(id, name, mimeType, modifiedTime)'
        });

        const file = filesResponse.data.files[0];

        res.json({ file });
    } catch (error) {
        console.error('Error during fetching files:', error);
        res.status(500).send('Error during fetching files');
    }
});

///////////////////// CALENDAR ////////////////////////////////
const calendar = google.calendar({version: 'v3', auth: oauth2Client});

app.get('/calendar/getNextEvent', async (req, res) => {
    if (req.session.tokens) {
        oauth2Client.setCredentials(req.session.tokens);
    } else {
        return res.status(401).send('Not authenticated');
    }

    try {
        const eventsResponse = await calendar.events.list({
            calendarId: 'primary',
            timeMin: (new Date()).toISOString(),
            maxResults: 1,
            singleEvents: true,
            orderBy: 'startTime'
        });

        const event = eventsResponse.data.items[0];

        res.json({ event });
    } catch (error) {
        console.error('Error during fetching events:', error);
        res.status(500).send('Error during fetching events');
    }
});

function extractMailInformation(message) {
    const headers = message.payload.headers;
    const subjectHeader = headers.find(header => header.name === 'Subject');
    const fromHeader = headers.find(header => header.name === 'From');
    const dateHeader = headers.find(header => header.name === 'Date');

    const subject = subjectHeader ? subjectHeader.value : 'No Subject';
    const sender = fromHeader ? fromHeader.value : 'Unknown Sender';
    const date = dateHeader ? new Date(dateHeader.value) : 'Unknown Date';

    let body = '';

    if (message.payload.parts) {
        const bodyPart = message.payload.parts.find(part => part.mimeType === 'text/plain');
        if (bodyPart && bodyPart.body) {
            body = Buffer.from(bodyPart.body.data, 'base64').toString();
        }
    }

    return { subject, body, sender, date };
}

app.listen(4000, () => {
    console.log('Server is running on port 4000');
});