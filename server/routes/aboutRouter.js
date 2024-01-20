/**
 * @swagger
 * tags:
 *   name: About
 *   description: Information about the API and custom services.
 */

import express from 'express';
import { CUSTOM_SERVICES } from '../area/serviceActionReaction.js';

const router = express.Router();

class ActionReactionService {
  constructor(name, description) {
    this.name = name;
    this.description = description;
  }
}

class Service {
  constructor(name, actions, reactions) {
    this.name = name;
    this.actions = actions;
    this.reactions = reactions;
  }
}
function getAbout() {
  let services = [];

  for (const service in CUSTOM_SERVICES) {
    let actions = CUSTOM_SERVICES[service].actions.map(
      (action) => new ActionReactionService(action.name, action.description)
    );
    let reactions = CUSTOM_SERVICES[service].reactions.map(
      (reaction) =>
        new ActionReactionService(reaction.name, reaction.description)
    );
    services.push(new Service(service, actions, reactions));
  }
  return services;
}
/**
 * @swagger
 * /about.json:
 *   get:
 *     summary: Get information about the API and services
 *     tags: [About]
 *     responses:
 *       '200':
 *         description: Successful response with client and server information
 *         content:
 *           application/json:
 *             example:
 *               client:
 *                 host: "127.0.0.1"
 *               server:
 *                 current_time: 1639496700
 *                 services:
 *                   - name: "YourServiceName"
 *                     actions:
 *                       - name: "ActionName"
 *                         description: "Description of the action"
 *                     reactions:
 *                       - name: "ReactionName"
 *                         description: "Description of the reaction"
 */
router.get('/', (req, res) => {
  return res.json({
    client: { host: req.clientIp },
    server: {
      current_time: Math.floor(new Date().getTime() / 1000),
      services: getAbout(),
    },
  });
});

export { router as aboutRouter };
