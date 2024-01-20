const discordConfig = {
  client_id: process.env.DISCORD_CLIENT_ID,
  client_secret: process.env.DISCORD_CLIENT_SECRET,
  discord_bot: process.env.DISCORD_BOT,
  redirect_url: process.env.REDIRECT_DISCORD_URL,
  client_app: process.env.CLIENT_URL,
  redirect_mobile: process.env.REDIRECT_DISCORD_MOBILE,
};

export { discordConfig };
