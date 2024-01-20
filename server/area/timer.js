import { ModelArea } from '../schemas/actionReaction.js';

async function everyMonth(area, react) {
  try {
    const { data } = area.action;
    const { dataLocalServer } = area.action;
    const date = new Date();
    const hour = date.getUTCHours();
    const day = date.getUTCDay();

    if (data.hour === Number(hour) && dataLocalServer.lastDay !== Number(day)) {
      area.action.dataLocalServer.lastDay = day;
      await ModelArea.findByIdAndUpdate(area._id, area);
      react(area);
    }
  } catch (error) {
    console.error('Error in everyMonth:', error);
  }
}


async function everyDay(area, react) {
  try {
    const { data } = area.action;
    const { dataLocalServer } = area.action;
    const date = new Date();
    const hour = date.getUTCHours();
    const minutes = date.getUTCMinutes();

    if (
      data.minute === Number(minutes) &&
      dataLocalServer.lastHour !== Number(hour)
    ) {
      area.action.dataLocalServer.lastHour = hour;
      await ModelArea.findByIdAndUpdate(area._id, area);
      react(area);
    }
  } catch (error) {
    console.error('Error in everyDay:', error);
  }
}

async function atSpecificDateTime(area, react) {
    try {
        const { data } = area.action;
        const { dataLocalServer } = area.action;
        const date = new Date();
        const currentYear = date.getUTCFullYear();
        const currentMonth = date.getUTCMonth() + 1;
        const currentDay = date.getUTCDate();
        const currentHour = date.getUTCHours();

        if (
            data.year === currentYear &&
            data.month === currentMonth &&
            data.day === currentDay &&
            data.hour === currentHour &&
            dataLocalServer.lastTriggeredDate !== date.toISOString()
        ) {
            area.action.dataLocalServer.lastTriggeredDate = date.toISOString();
            await ModelArea.findByIdAndUpdate(area._id, area);
            react(area);
        }
    } catch (error) {
        console.error('Error in atSpecificDateTime:', error);
    }
}

async function timerTriggers(area, react) {
    try {
        if (area.action.name === 'every_month') {
            await everyMonth(area, react);
        }
        if (area.action.name === 'every_day') {
            await everyDay(area, react);
        }
        if (area.action.name === 'at_specific_date_time') {
            await atSpecificDateTime(area, react);
        }
  } catch (error) {
    console.error('Error in timerTriggers:', error);
  }
}

export { timerTriggers};
