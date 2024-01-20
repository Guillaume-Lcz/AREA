/* eslint-disable no-prototype-builtins */
import { CUSTOM_SERVICES } from '../area/serviceActionReaction.js';

function checkBody(req) {
  try {
    if (!req.body.action || !req.body.reaction) {
      throw new Error(
        'The request is invalid. The action and reaction properties are required.'
      );
    }
    const action = req.body.action;
    const reaction = req.body.reaction;
    if (!action.service || typeof action.service !== 'string') {
      throw new Error(
        'The service of the action is required and must be a string.'
      );
    }
    if (!action.name || typeof action.name !== 'string') {
      throw new Error(
        'The name of the action is required and must be a string.'
      );
    }
    if (!Array.isArray(reaction)) {
      throw new Error('The reaction is not a array type.');
    }
    if (reaction.length == 0) {
      throw new Error(
        'The service of the reaction is required and must be a string.'
      );
    }
    for (let i = 0; i < reaction.length; i++) {
      if (!reaction[i].service || typeof reaction[i].service !== 'string') {
        throw new Error(
          'The service of the reaction is required and must be a string.'
        );
      }
      if (!reaction[i].name || typeof reaction[i].name !== 'string') {
        throw new Error(
          'The name of the reaction is required and must be a string.'
        );
      }
      if (!reaction[i].data) {
        throw new Error('The body of the reaction is required.');
      }
    }
  } catch (error) {
    return error.message;
  }
  return 'OK';
}

function handleErrorsReactions(req, res) {
  try {
    if (!Array.isArray(req.body.reaction)) {
      res.status(400).send({ message: 'Reaction: is not an array type' });
      return false;
    }
    for (let i = 0; i < req.body.reaction.length; i++) {
      const reactionService = CUSTOM_SERVICES[req.body.reaction[i].service];

      if (!reactionService) {
        res
          .status(400)
          .send({ message: `Reaction ${i}: service does not exist` });
        return false;
      }
      const reaction = reactionService.reactions.find(
        (r) => r.name === req.body.reaction[i].name
      );
      if (!reaction) {
        res.status(400).send({ message: `Reaction ${i}: name does not exist` });
        return false;
      }
      for (const param of reaction.paramNames) {
        if (!req.body.reaction[i].data.hasOwnProperty(param)) {
          res.status(400).send({
            message: `Reaction ${i}: missing '${param}' data argument.`,
          });
          return false;
        }
      }
    }
  } catch (err) {
    res.status(500).send({ message: `Server error` });
    return false;
  }
  return true;
}

async function handleErrorsAction(req, res, user) {
  try {

    const actionService = CUSTOM_SERVICES[req.body.action.service];
 
    if (!actionService) {
      res.status(400).send({ message: 'Action: service does not exist' });
      return false;
    }
    const action = actionService.actions.find(
      (a) => a.name === req.body.action.name
    );
    if (!action) {
      res.status(400).send({ message: 'Action: name does not exist' });
      return false;
    }
    for (const param of action.paramNames) {
      if (!req.body.action.data.hasOwnProperty(param)) {
        res
          .status(400)
          .send({ message: `Action: missing '${param}' data argument.` });
        return false;
      }
    }
    const errorCheckFct = await action.checkFunction(user, req.body.action, '');
    if (errorCheckFct) {
      res.status(400).send({ message: errorCheckFct });
      return false;
    }
  } catch (err) {
    console.log(err);
    res.status(500).send({ message: `Server error` });
    return false;
  }
  return true;
}

export { checkBody, handleErrorsAction, handleErrorsReactions };
