import { discordReact } from './discord.js'
import { driveReactions, driveTriggers } from './drive.js';
import { googleReaction, googleTriggers } from './google.js';
import { sportifyTriggers } from './spotify.js';
import { timerTriggers } from './timer.js'

class CustomAction {
  constructor(name, description, paramNames, checkFunction) {
    this.name = name;
    this.description = description;
    this.paramNames = paramNames;
    this.checkFunction = checkFunction;
  }
}

class CustomReaction {
  constructor(name, description, paramNames) {
    this.name = name;
    this.description = description;
    this.paramNames = paramNames;
  }
}

class CustomService {
  constructor(actions = [], reactions = [], trigger, react) {
    this.actions = actions;
    this.reactions = reactions;
    this.trigger = trigger;
    this.react = react;
  }
}

const CUSTOM_SERVICES = {
  discord: new CustomService([], [
    new CustomReaction("post_message", "Posts a message in a specific location", ["channel_id", "body"])
  ], () => { }, discordReact),
  timer: new CustomService([
    new CustomAction("every_day", "Triggers every hour", ["hour", "minute"], () => false),
    new CustomAction("every_month", "Triggers every day", ["day", "hour"], () => false),
    new CustomAction("at_specific_date_time", "Trigger a reaction on the day you want", ["year", "month", "day", "hour"], () => false),
  ], [], timerTriggers, () => { }),
  spotify: new CustomService([
    new CustomAction("last_playlist", "Triggers when a is added", [], () => false),
    new CustomAction("last_song", "Triggers when a playlist is added", [], () => false),
    new CustomAction("last_album", "Triggers when a is added", [], () => false),
  ], [], sportifyTriggers, () => { }),
  gmail: new CustomService([
    new CustomAction("last_mail", "Triggers when a new mail is got", [], () => false),
    new CustomAction("last_mail_from_someone", "Triggers when a new mail is got from someone", ["sender"], () => false),
  ], [
    new CustomReaction("send_mail", "Send an email ", ["to", "subject", "body"], () => false),
  ], googleTriggers, googleReaction),
  drive: new CustomService([
    new CustomAction("get_folder_action", "Get action from a folder", ["folder_name"], () => false)
  ], [
    new CustomReaction("new_file", "Create a new file in a folder", ["folder_name", "file_name", "file_content"], () => false)
  ], driveTriggers, driveReactions),
};

export { CUSTOM_SERVICES };
