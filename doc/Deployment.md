# Project Deployment Guide

This guide will walk you through the process of deploying the project using Docker and Docker Compose.

## Prerequisites

Before you begin, ensure you have the following installed:
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Configuration

1. Clone the project repository to your local machine.

2. Navigate to the root of the project directory.

3. Create a `.env` file in the root of your project directory with the following environment variables:

```env
MONGO_USERNAME=
MONGO_PASSWORD=
MONGO_DATABASE=
GOOGLE_CLIENT_ID=
GOOGLE_CLIENTSECRET=
REDIRECT_GOOGLE_SERVICE=
REDIRECT_GOOGLE_SERVICE_MOBILE=
REDIRECT_GOOGLE_WEB_URL=
REDIRECT_GOOGLE_MOBILE_URL=
DISCORD_CLIENT_ID=
DISCORD_CLIENT_SECRET=
DISCORD_BOT=
REDIRECT_DISCORD_URL=
REDIRECT_DISCORD_MOBILE=
SPOTIFY_CLIENT_ID=
SPOTIFY_SECRET_ID=
REDIRECT_SPOTIFY_URL=
REDIRECT_SPOTIFY_MOBILE_URL=
TOKEN_SECRET=
MOBILE_APP=
CLIENT_URL=
SERVERPORT=
CLIENTPORT=
```

## Running the Application

Once the `.env` file is configured:

1. Open a terminal in the project directory.
2. Ensure no services are running on ports `8080`, `8081`, and `27017`.
3. Execute the command `docker-compose up --build` to build and start the services.

Your services will now be accessible at the following URLs:

- **Server**: `http://localhost:8080`
- **Client Web**: `http://localhost:8081`
- **Client Mobile**: 'http://localhost:8081/client.apk"
-> provides directly the apk
- **MongoDB**: Internally accessible by the server on port `27017`.

## Shutting Down

To stop the application:

- Use `Ctrl+C` in the terminal.
- Run `docker-compose down` will stop and remove all running containers, networks, and the default anonymous volumes attached to the containers.

## Additional Notes

For detailed information on environment setup and variables, refer to the official documentation of each service (MongoDB, Google Auth, Discord, etc.).

For further support or contribution guidelines, please refer to our contributing document or contact the repository maintainers.