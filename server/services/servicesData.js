import jwt from 'jsonwebtoken';
import { googleConfig, oauth2Client } from '../configs/googleConfig.js'
import { jwtToken } from '../configs/jwtConfig.js';
import { discordConfig } from '../configs/discordConfig.js';
import { spotifyConfig } from '../configs/spotifyConfig.js';

function replaceRedirectUri(originalUrl, newRedirectUri) {
  const url = new URL(originalUrl);
  url.searchParams.set('redirect_uri', newRedirectUri);
  return encodeURIComponent(url.toString());
}

const services = (isMobile) => {
  return ({
    discord: {
      redirect: `https://discord.com/api/oauth2/authorize?client_id=${discordConfig.client_id}&permissions=292057987072&response_type=code&redirect_uri=${encodeURIComponent(isMobile ? discordConfig.redirect_mobile : discordConfig.redirect_url)}&scope=identify+bot`
    },
    spotify: {
      redirect: `https://accounts.spotify.com/authorize?client_id=${spotifyConfig.client_id}&response_type=code&redirect_uri=${encodeURIComponent(isMobile ? spotifyConfig.redirect_mobile : spotifyConfig.redirect_url)}&scope=user-library-read+user-read-recently-played+user-top-read+playlist-read-private+playlist-read-collaborative`
    },
    google: {
      redirect: oauth2Client.generateAuthUrl({
        access_type: isMobile ? 'online' : 'offline',
        scope: ["https://www.googleapis.com/auth/gmail.readonly",
        "https://www.googleapis.com/auth/gmail.send",
        "https://www.googleapis.com/auth/drive.readonly",
        "https://www.googleapis.com/auth/drive.file",
        ],
        redirect_uri: isMobile ? googleConfig.google_service_mobile : googleConfig.google_service,
      })
    }
  })
}

const servicesData = async (req, res) => {
  const { user } = jwt.verify(req.cookies.token, jwtToken.tokenSecret);
  res.json(services(user.isMobile));
};

export { servicesData };
