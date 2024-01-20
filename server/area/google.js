import { google } from 'googleapis';
import { oauth2Client } from '../configs/googleConfig.js';
import { ModelUser } from '../schemas/user.js';
import { ModelArea } from '../schemas/actionReaction.js';
import _ from 'lodash';

function extractMailInformation(message) {
  const headers = message.payload.headers;
  const subjectHeader = headers.find((header) => header.name === 'Subject');
  const fromHeader = headers.find((header) => header.name === 'From');
  const dateHeader = headers.find((header) => header.name === 'Date');

  const subject = subjectHeader ? subjectHeader.value : 'No Subject';
  const sender = fromHeader ? fromHeader.value : 'Unknown Sender';
  const date = dateHeader ? new Date(dateHeader.value) : 'Unknown Date';

  let body = '';

  if (message.payload.parts) {
    const bodyPart = message.payload.parts.find(
      (part) => part.mimeType === 'text/plain'
    );
    if (bodyPart && bodyPart.body) {
      body = Buffer.from(bodyPart.body.data, 'base64').toString();
    }
  }
  return { subject, body, sender, date };
}

async function refrechToken(user) {
    try {
        const token = user.servicesData.get("google").accessToken;
        if (oauth2Client.isTokenExpiring()) {
            const { token: newAccessToken } = await oauth2Client.refreshAccessToken();
            user.servicesData.get("google").accessToken = newAccessToken;
            await user.save();
            oauth2Client.setCredentials({ access_token: newAccessToken });
        } else {
            oauth2Client.setCredentials({ access_token: token });
        }
        return google.gmail({ version: 'v1', auth: oauth2Client });
    } catch (error) {
        console.error('Error refreshing token:', error);
        throw new Error('Error refreshing token');
    }
}

async function getMails(area, react, user, fromSomeOne) {
  try {
    const gmail = await refrechToken(user);
    const messagesResponse = await gmail.users.messages.list({
      userId: 'me',
      maxResults: 1,
    });
    const messageIds = messagesResponse.data.messages.map(
      (message) => message.id
    );
    const messages = await Promise.all(
      messageIds.map(async (messageId) => {
        if (messageId) {
          const messageResponse = await gmail.users.messages.get({
              userId: 'me',
              id: messageId,
          });
          const { subject, body, sender, date } = extractMailInformation(messageResponse.data);
          return { subject, body, sender, date };
      }
      })
    );
    if (fromSomeOne) {
      if (
        area.action.dataLocalServer?.googleTriggers?.lastfiveMail &&
        !_.isEqual(
          area.action.dataLocalServer.googleTriggers.lastfiveMail,
          messages[0]
        ) &&
        messages[0].sender.includes(area.action.data.sender)
      ) {
        react(area);
      }
    } else {
      if (
        area.action.dataLocalServer?.googleTriggers?.lastfiveMail &&
        !_.isEqual(
          area.action.dataLocalServer.googleTriggers.lastfiveMail,
          messages[0]
        )
      ) {
        react(area);
      }
    }
    if (area.action.dataLocalServer?.googleTriggers?.lastfiveMail) {
      delete area.action.dataLocalServer.googleTriggers.lastfiveMail;
    }
    const toSend = {
      googleTriggers: {
        ...(area.action.dataLocalServer?.googleTriggers || {}),
        lastfiveMail: messages[0],
      },
    };
    area.action.dataLocalServer.googleTriggers = toSend.googleTriggers;
    await ModelArea.findByIdAndUpdate(area._id, area);
  } catch (error) {
    console.error('Error during fetching messages:', error);
  }
}


async function googleTrigger(area, react)
{
    const user = await ModelUser.findOne({ _id: area.userId });

  try {
    if (area.action.name === 'last_mail') {
      await getMails(area, react, user, false);
    }
    if (area.action.name === 'last_mail_from_someone') {
      await getMails(area, react, user, true);
    }
  } catch (error) {
    console.error('Error in Spotify triggers:', error);
  }
}

function googleTriggers(area, react) {
    googleTrigger(area, react);
}

async function sendMail(user, area, i) {
  try {
    const gmail = await refrechToken(user);
    const to = area.reaction[i].data.to;
    const subject = area.reaction[i].data.subject;
    const messageBody = area.reaction[i].data.body;

    const raw = makeBody(
      to,
      oauth2Client.credentials.email,
      subject,
      messageBody
    );
    const encodedMessage = Buffer.from(raw)
      .toString('base64')
      .replace(/\+/g, '-')
      .replace(/\//g, '_');

    const result = await gmail.users.messages.send({
      userId: 'me',
      requestBody: {
        raw: encodedMessage,
      },
    });
  } catch (error) {
    console.error('Error during sending email:', error);
  }
}

function makeBody(to, from, subject, message) {
  let str = [
    'Content-Type: text/plain; charset="UTF-8"\n',
    'MIME-Version: 1.0\n',
    'Content-Transfer-Encoding: 7bit\n',
    'to: ',
    to,
    '\n',
    'from: ',
    from,
    '\n',
    'subject: ',
    subject,
    '\n\n',
    message,
  ].join('');
  return str;
}

async function googleReactionMapped(area, i) {
  const user = await ModelUser.findOne({ _id: area.userId });
  try {
    if (area.reaction[i].name == 'send_mail') {
      sendMail(user, area, i);
    }
  } catch (error) {
    console.error('Error in Spotify triggers:', error);
  }
}

function googleReaction(area) {
    for (var i = 0; area.reaction.length > i; i++) {
        googleReactionMapped(area, i)
    }
}

export { googleTriggers, googleReaction };
