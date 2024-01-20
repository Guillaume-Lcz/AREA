const jwtToken = {
    tokenSecret: process.env.TOKEN_SECRET,
    tokenExpiration: 30 * 24 * 60 * 60 * 1000,
    client_url: process.env.CLIENT_URL
}

export { jwtToken };
