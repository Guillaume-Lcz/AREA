const spotifyConfig = {
  client_id: process.env.SPOTIFY_CLIENT_ID,
  client_secret: process.env.SPOTIFY_SECRET_ID,
  redirect_url: process.env.REDIRECT_SPOTIFY_URL,
  client_app: process.env.CLIENT_URL,
  redirect_mobile: process.env.REDIRECT_SPOTIFY_MOBILE,
};

export { spotifyConfig };
