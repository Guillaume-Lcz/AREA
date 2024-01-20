/**
 * @swagger
 * tags:
 *   name: Project
 *   description: Endpoints for managing user projects and actions/reactions
 */

import express from 'express';
import jwt from 'jsonwebtoken';

import { jwtToken } from '../configs/jwtConfig.js';
import { ModelArea } from '../schemas/actionReaction.js';
import { auth } from '../middleware/jwtStratergy.js';
import {
  checkBody,
  handleErrorsAction,
  handleErrorsReactions,
} from '../utils/handleErrors.js';

const router = express.Router();

/**
 * @swagger
 * /project:
 *   post:
 *     summary: Create a new area (project) with specified action and reaction
 *     tags: [Project]
 *     security:
 *       - BearerAuth: []
 *     requestBody:
 *       description: Object containing action and reaction details
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               action:
 *                 type: object
 *                 properties:
 *                   description:
 *                     type: string
 *                   service:
 *                     type: string
 *                   name:
 *                     type: string
 *                   data:
 *                     type: object
 *               reaction:
 *                 type: array
 *                 items:
 *                   type: object
 *                   properties:
 *                     service:
 *                       type: string
 *                     description:
 *                       type: string
 *                     name:
 *                       type: string
 *                     data:
 *                       type: object
 *     responses:
 *       '201':
 *         description: Successfully created area (project)
 *       '400':
 *         description: Bad Request - Invalid input or failed to create area
 */

router.post('/', auth, async (req, res) => {
  const token = req.cookies.token;
  const { user } = jwt.verify(token, jwtToken.tokenSecret);
  const errorCheckBody = checkBody(req);
  if (errorCheckBody !== 'OK') {
    return res.status(400).send({ message: errorCheckBody });
  }
  if (
    !handleErrorsReactions(req, res) ||
    !(await handleErrorsAction(req, res, user))
  ) {
    return;
  }
  try {
    await ModelArea.create({
      userId: user._id,
      action: req.body.action,
      reaction: req.body.reaction,
    });
  } catch (err) {
    console.log(err);
    return res.status(400).send({ message: 'Failed to create area' });
  }
  return res.sendStatus(201);
});

/**
 * @swagger
 * /project/{id}:
 *   put:
 *     summary: Update the specified area (project) with new action and reaction
 *     tags: [Project]
 *     security:
 *       - BearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID of the area (project) to update
 *         schema:
 *           type: string
 *     requestBody:
 *       description: Object containing updated action and reaction details
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               action:
 *                 type: object
 *                 properties:
 *                   description:
 *                     type: string
 *                   service:
 *                     type: string
 *                   name:
 *                     type: string
 *                   data:
 *                     type: object
 *               reaction:
 *                 type: array
 *                 items:
 *                   type: object
 *                   properties:
 *                     service:
 *                       type: string
 *                     description:
 *                       type: string
 *                     name:
 *                       type: string
 *                     data:
 *                       type: object
 *     responses:
 *       '200':
 *         description: Successfully updated area (project)
 *       '400':
 *         description: Bad Request - Invalid input or failed to update area
 */

router.put('/:id', auth, async (req, res) => {
  try {
    await ModelArea.findByIdAndUpdate(req.params.id, {
      action: req.body.action,
      reaction: req.body.reaction,
    });
  } catch (err) {
    console.log(err);
    return res.status(400).send({ message: 'Could not update Area' });
  }
  return res.sendStatus(200);
});

/**
 * @swagger
 * /project/{id}:
 *   delete:
 *     summary: Delete the specified area (project)
 *     tags: [Project]
 *     security:
 *       - BearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: ID of the area (project) to delete
 *         schema:
 *           type: string
 *     responses:
 *       '204':
 *         description: Successfully deleted area (project)
 *       '400':
 *         description: Bad Request - Invalid input or failed to delete area
 */

router.delete('/:id', auth, async (req, res) => {
  try {
    await ModelArea.findByIdAndDelete(req.params.id);
  } catch (err) {
    console.log(err);
    return res.status(400).send({ message: 'Could not delete Area' });
  }
  return res.sendStatus(204);
});

/**
 * @swagger
 * /project:
 *   get:
 *     summary: Get all areas (projects) for the authenticated user
 *     tags: [Project]
 *     security:
 *       - BearerAuth: []
 *     responses:
 *       '200':
 *         description: Successful response with an array of areas (projects)
 *         content:
 *           application/json:
 *             example:
 *               - userId: "user_id"
 *                 action:
 *                   description: "test"
 *                   service: "timer"
 *                   name: "every_day"
 *                   data:
 *                     hour: 3
 *                     minute: 59
 *                 reaction:
 *                   - service: "discord"
 *                     description: "test"
 *                     name: "post_message"
 *                     data:
 *                       id: "1096556203649282108"
 *                       body: "exemple"
 *               - userId: "user_id"
 *                 action:
 *                   description: "another_test"
 *                   service: "another_timer"
 *                   name: "every_minute"
 *                   data:
 *                     hour: 2
 *                     minute: 30
 *                 reaction:
 *                   - service: "slack"
 *                     description: "another_test"
 *                     name: "send_message"
 *                     data:
 *                       channelId: "12345"
 *                       message: "Hello, World!"
 */

router.get('/', auth, async (req, res) => {
  const token = req.cookies.token;
  const { user } = jwt.verify(token, jwtToken.tokenSecret);

  try {
    const area = await ModelArea.find({ userId: user._id });
    return res.send(area);
  } catch (error) {
    console.log(error);
    return res.status(500).json({ message: 'Internal Server Error' });
  }
});

export { router as projectRouter };
