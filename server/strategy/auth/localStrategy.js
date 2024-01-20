// LocalStrategy.js
import express from 'express';
import { body } from 'express-validator';
import { validateReq } from '../../middleware/validateRequests.js';
import { authController } from '../../controllers/authController.js';

const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: Local Auth
 *   description: Endpoints for local (email and password) authentication
 */

/**
 * @swagger
 * /auth/local/sign-in:
 *   post:
 *     tags:
 *     - Local Auth
 *     summary: Sign In
 *     description: Authenticates a user using their email and password.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *               password:
 *                 type: string
 *     responses:
 *       '200':
 *         description: User successfully signed in.
 *       '400':
 *         description: Bad request. Email or password is invalid.
 *       '500':
 *         description: Server error during the sign-in process.
 */
router.post(
  '/sign-in',
  [
    body('email').isEmail().withMessage('Please enter a correct email'),
    body('password')
      .trim()
      .isLength({ min: 5 })
      .withMessage('Please enter a password of at least 5 characters'),
  ],
  validateReq,
  authController.signin
);

/**
 * @swagger
 * /auth/local/sign-up:
 *   post:
 *     tags:
 *     - Local Auth
 *     summary: Sign Up
 *     description: Registers a new user using their name, email, and password.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               email:
 *                 type: string
 *               password:
 *                 type: string
 *     responses:
 *       200:
 *         description: User successfully signed up.
 *       400:
 *         description: Bad request. Name, email, or password is invalid.
 *       500:
 *         description: Server error during the sign-up process.
 */
router.post(
  '/sign-up',
  [
    body('name')
      .isLength({ min: 3 })
      .withMessage('Please enter a name of at least 3 characters'),
    body('email').isEmail().withMessage('Please enter a correct email'),
    body('password')
      .trim()
      .isLength({ min: 5 })
      .withMessage('Please enter a password of at least 5 characters'),
  ],
  validateReq,
  authController.signup
);

export { router as LocalStrategy };
