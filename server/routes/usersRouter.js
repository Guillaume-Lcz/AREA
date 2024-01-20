/**
 * @swagger
 * tags:
 *   name: Users
 *   description: Endpoints for user information and management
 */

import express from 'express';
import jwt from 'jsonwebtoken';

import { ModelUser } from '../schemas/user.js';
import { auth } from '../middleware/jwtStratergy.js';

const router = express.Router();

/**
 * @swagger
 * /user:
 *   get:
 *     summary: Get user information
 *     tags: [Users]
 *     security:
 *       - BearerAuth: []
 *     responses:
 *       '200':
 *         description: Successful response with user information
 *         content:
 *           application/json:
 *             example:
 *               _id: "user_id"
 *               name: "user_name"
 *               email: "user_email@example.com"
 *               services: [{ service_name: true }]
 *               isGoogle: true
 *               isMobile: false
 */

router.get('/', auth, async (req, res) => {
  const token = req.cookies.token;
  const { user } = jwt.decode(token);

  try {
    let data = await ModelUser.findOne({ email: user.email });
    let formattedConnectData = [];

    for (const [k] of data.servicesData) {
      formattedConnectData.push({ [k]: true });
    }

    return res.send({
      _id: data._id,
      name: user.name,
      email: user.email,
      services: formattedConnectData,
      isGoogle: user.isGoogleAuth,
      isMobile: user.isMobile,
    });
  } catch (error) {
    return res.status(500).json({ message: 'Internal Server Error' });
  }
});

/**
 * @swagger
 * /user/delete:
 *   delete:
 *     summary: Delete the authenticated user
 *     tags: [Users]
 *     security:
 *       - BearerAuth: []
 *     responses:
 *       '204':
 *         description: Successful deletion of the user
 *       '404':
 *         description: User not found
 *       '400':
 *         description: Could not delete user
 */

router.delete('/delete', auth, async (req, res) => {
  try {
    const token = req.cookies.token;
    const { user } = jwt.decode(token);
    const deleted = await ModelUser.findByIdAndDelete(user._id);

    if (!deleted) {
      return res.status(404).json({ message: 'Could not find user' });
    }
  } catch (err) {
    return res.status(400).json({ message: 'Could not delete user' });
  }
  return res.sendStatus(204);
});

export { router as usersRoutes };
