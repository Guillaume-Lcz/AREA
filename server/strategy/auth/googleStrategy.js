import express from 'express';
import axios from 'axios';
import jwt from 'jsonwebtoken';

import { ModelUser } from '../../schemas/user.js';
import { googleConfig, authParams } from '../../configs/googleConfig.js';
import { mobileConfig } from '../../configs/mobileConfig.js';
import { jwtToken } from '../../configs/jwtConfig.js';
import { getTokenParams } from '../../utils/utils.js';

const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: Google Auth
 *   description: Endpoints for Google authentication
 */

/**
 * @swagger
 * /auth/google/url:
 *   get:
 *     tags:
 *       - Google Auth
 *     summary: Get Google Auth URL
 *     description: Returns the URL to initiate the Google authentication process.
 *     parameters:
 *       - name: mobile
 *         in: query
 *         description: Indicates if the request is coming from a mobile device.
 *         schema:
 *           type: boolean
 *     responses:
 *       200:
 *         description: Google Auth URL
 *         content:
 *           application/json:
 *             example:
 *               url: "https://example.com/auth/google/callback?mobile=true"
 */
router.get('/url', (req, res) => {
  const isMobile = !!req.query.mobile;
  res.json({
    url: `${googleConfig.authUrl_google}?${authParams(isMobile)}`,
  });
});

/**
 * @swagger
 * /auth/google/callback:
 *   get:
 *     tags:
 *       - Google Auth
 *     summary: Google Auth Callback
 *     description: Handles the callback from Google authentication and redirects accordingly.
 *     parameters:
 *       - name: code
 *         in: query
 *         description: The authorization code received from Google.
 *         required: true
 *         schema:
 *           type: string
 *       - name: mobile
 *         in: query
 *         description: Indicates if the request is coming from a mobile device.
 *         schema:
 *           type: boolean
 *     responses:
 *       200:
 *         description: Redirects to the appropriate URL with an authentication token.
 *       400:
 *         description: Bad request. Authorization code must be provided.
 *       500:
 *         description: Server error during the authentication process.
 */
router.get('/callback', async (req, res) => {
  const { code } = req.query;
  const isMobile = !!req.query.mobile;

  if (!code)
    return res
      .status(400)
      .json({ message: 'Authorization code must be provided' });
  try {
    const tokenParam = getTokenParams(googleConfig, code, isMobile);
    const {
      data: { id_token },
    } = await axios.post(`${googleConfig.tokenUrl_google}?${tokenParam}`);
    if (!id_token) return res.status(400).json({ message: 'Auth error' });
    const { email, name, sub: googleId } = jwt.decode(id_token);
    var modelUser = await ModelUser.findOne({ email: email });
    if (!modelUser) {
      modelUser = new ModelUser({ name, email, googleId, isGoogleAuth: true });
      await modelUser.save();
    }
    const user = {
      _id: modelUser._id,
      name,
      email,
      isGoogleAuth: true,
      isMobile,
    };
    const token = jwt.sign({ user }, jwtToken.tokenSecret, {
      expiresIn: jwtToken.tokenExpiration,
    });
    if (isMobile) {
      res.redirect(mobileConfig.mobile_app_url + 'auth?token=' + token);
    } else {
      res.cookie('token', token, {
        maxAge: jwtToken.tokenExpiration,
        httpOnly: true,
      });
      res.redirect(googleConfig.client_url);
    }
  } catch (err) {
    res.status(500).json({ message: err.message || 'Server error' });
  }
});

export { router as authGoogleRouter };
