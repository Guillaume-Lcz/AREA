import { discordConfig } from '../configs/discordConfig.js';
import { Client, GatewayIntentBits } from 'discord.js';
import { getArt, getJokes } from './otherApis.js';

const client = new Client({ intents: [GatewayIntentBits.Guilds] });
client.login(discordConfig.discord_bot);

client.on('messageCreate', (message) => {
    // Handle the received message here
    console.log(`Received message: ${message.content}`);
    // You can add your custom logic here based on the received message
});

async function discordProcess(reaction) {
  if (reaction.name === 'post_message') {
    try {
      const channelId = reaction.data.channel_id;
      const channel = client.channels.cache.get(String(channelId));

      if (channel) {
        await channel.send(reaction.data.body);
      } else {
        console.log('Channel not found.');
      }
    } catch (err) {
      console.error(err);
    }
  }
  if (reaction.name === 'post_joke') {
    try {
      const channel = client.channels.cache.get(reaction.data.channel_id);
      if (channel) {
        const joke = await getJokes();
        await channel.send(joke);
      } else {
        console.log('Channel not found.');
      }
    } catch (err) {
      console.error(err);
    }
  }
  if (reaction.name === 'post_art') {
    try {
      const channel = client.channels.cache.get(reaction.data.channel_id);
      if (channel) {
        const artwork = await getArt();
        await channel.send(artwork);
      } else {
        console.log('Channel not found.');
      }
    } catch (err) {
      console.error(err);
    }
  }
}

function discordReact(area) {
  for (var i = 0; area.reaction.length > i; i++) {
    discordProcess(area.reaction[i]);
  }
}

export { discordReact };
