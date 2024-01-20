/**
 * @swagger
 * tags:
 *   name: Services
 *   description: Endpoints for connecting and managing third-party services
 */

import express from 'express';

import { auth } from '../middleware/jwtStratergy.js';
import { discordCallback } from '../services/discordService.js';
import { spotifyCallback } from '../services/spotifyService.js';
import { servicesData } from '../services/servicesData.js';
import { googleCallback } from '../services/googleCallback.js'

const router = express.Router();

/**
 * @swagger
 * /services:
 *   get:
 *     summary: Get information about connected services
 *     tags: [Services]
 *     security:
 *       - BearerAuth: []
 *     responses:
 *       '200':
 *         description: Successful response with information about connected services
 *         content:
 *           application/json:
 *             example:
 *               discord:
 *                 redirect: "https://discord.com/api/oauth2/authorize?client_id=1073016730911248504&permissions=292057987072&response_type=code&redirect_uri=http%3A%2F%2Flocalhost%3A5000%2Fservices%2Fdiscord%2Fcallback&scope=identify+bot"
 *               spotify:
 *                 redirect: "https://accounts.spotify.com/authorize?client_id=24521d4cf7574abf873895f7def9ba0d&response_type=code&redirect_uri=http%3A%2F%2Flocalhost%3A5000%2Fservices%2Fspotify%2Fcallback&scope=user-library-read+user-read-recently-played+user-top-read+playlist-read-private+playlist-read-collaborative"
 */

router.get('/', auth, servicesData);

/**
 * @swagger
 * /services/discord/callback:
 *   get:
 *     summary: Callback endpoint for Discord authentication
 *     tags: [Services]
 *     security:
 *       - BearerAuth: []
 *     responses:
 *       '200':
 *         description: Successful response after Discord authentication
 */

router.get('/discord/callback', auth, discordCallback);

/**
 * @swagger
 * /services/spotify/callback:
 *   get:
 *     summary: Callback endpoint for Spotify authentication
 *     tags: [Services]
 *     security:
 *       - BearerAuth: []
 *     responses:
 *       '200':
 *         description: Successful response after Spotify authentication
 */

router.get('/spotify/callback', auth, spotifyCallback);

/**
 * @swagger
 * /services/google/callback:
 *   get:
 *     summary: Handle Google Auth callback
 *     tags: [Google Auth Callback]
 *     security:
 *       - BearerAuth: []
 *     parameters:
 *       - name: code
 *         in: query
 *         description: Authorization code received from Google
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       201:
 *         description: Successful connection with a message
 *       401:
 *         description: Unauthorized if authentication token is missing or invalid
 *       404:
 *         description: User not found with error message
 *       500:
 *         description: Internal server error with error message
 */
router.get('/google/callback', auth, googleCallback);

export { router as connectServices };
