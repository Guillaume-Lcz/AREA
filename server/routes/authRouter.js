/**
 * @swagger
 * tags:
 *   name: Authentication
 *   description: Endpoints for user authentication
 */

import express from 'express';
import jwt from 'jsonwebtoken';

import { authGoogleRouter } from '../strategy/auth/googleStrategy.js';
import { jwtToken } from '../configs/jwtConfig.js';
import { auth } from '../middleware/jwtStratergy.js';
import { LocalStrategy } from '../strategy/auth/localStrategy.js';

const router = express.Router();

/**
 * @swagger
 * /auth/google:
 *   summary: Google authentication routes
 *   description: Routes for authenticating users with Google
 *   /auth/google/url:
 *     $ref: '#/components/pathItems/authGoogleUrl'
 *   /auth/google/callback:
 *     $ref: '#/components/pathItems/authGoogleCallback'
 */
router.use('/google', authGoogleRouter);

router.use('/local', LocalStrategy);

/**
 * @swagger
 * /auth/echo:
 *   get:
 *     summary: Get user information
 *     description: Retrieve user information based on the provided authentication token.
 *     tags: [Authentication]
 *     security:
 *       - BearerAuth: []
 *     responses:
 *       200:
 *         description: Successful response with user information
 *         content:
 *           application/json:
 *             example:
 *               _id: "65a3cb4b8e439f2a6fd46325"
 *               name: "dqsqsdqsdqsdqsdqsd"
 *               email: "qsdqsdqghffghfgqsdqsdqsdhfghsqsdqsdqerersdsd@gmail.comrtyrty"
 *               isGoogleAuth: false
 *               isMobile: false
 */
router.get('/echo', auth, async (req, res) => {
  const token = req.cookies.token;
  const { user } = jwt.verify(token, jwtToken.tokenSecret);
  res.status(200).json({ ...user });
});

/**
 * @swagger
 * /auth/logout:
 *   post:
 *     summary: Logout
 *     description: Logout the currently authenticated user.
 *     tags: [Authentication]
 *     security:
 *       - BearerAuth: []
 *     responses:
 *       200:
 *         description: User logged out successfully.
 *         content:
 *           application/json:
 *             example:
 *               message: 'Logged out'
 */
router.post('/logout', auth, (_, res) => {
  res.clearCookie('token').json({ message: 'Logged out' });
});

export { router as authRouter };
