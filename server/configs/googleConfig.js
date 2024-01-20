import queryString from 'query-string';
import { google } from 'googleapis'

const googleConfig = {
  client_id: process.env.GOOGLE_CLIENT_ID,
  client_secret: process.env.GOOGLE_CLIENT_SECRET,
  authUrl_google: 'https://accounts.google.com/o/oauth2/v2/auth',
  tokenUrl_google: 'https://oauth2.googleapis.com/token',
  redirect_mobile: process.env.REDIRECT_GOOGLE_MOBILE_URL,
  redirect_url: process.env.REDIRECT_GOOGLE_WEB_URL,
  client_url: process.env.CLIENT_URL,
  google_service_mobile: process.env.REDIRECT_GOOGLE_SERVICE_MOBILE,
  google_service: process.env.REDIRECT_GOOGLE_SERVICE
}

const oauth2Client = new google.auth.OAuth2(
    "9267004214-ij67caut9rl8jvbcr7a1fb1hhrosboki.apps.googleusercontent.com",
    "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",
    googleConfig.google_service
);

const authParams = (isMobile) => queryString.stringify({
  client_id: googleConfig.client_id,
  redirect_uri: isMobile ? googleConfig.redirect_mobile : googleConfig.redirect_url,
  response_type: 'code',
  scope: 'openid profile email',
  access_type: 'offline',
  state: 'standard_oauth',
  prompt: 'consent',
});

export { googleConfig, authParams,  oauth2Client}
