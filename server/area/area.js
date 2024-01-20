import { ModelArea } from '../schemas/actionReaction.js'
import { CUSTOM_SERVICES } from './serviceActionReaction.js'
async function doReac(area) {
  for (var i = 0; area.reaction.length > i; i++) {
    const service = CUSTOM_SERVICES[area.reaction[i].service];

    if (service) {
      await service.react(area);
    }
  }
}

async function checkTriggers() {
  const areas = await ModelArea.find({});
  const react = (_area) => doReac(_area);
  for (const area of areas) {
    const service = CUSTOM_SERVICES[area.action.service];

    if (service) {
      await service.trigger(area, react);
    }
  }
}

export { checkTriggers };
