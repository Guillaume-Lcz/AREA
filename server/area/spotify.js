import axios from 'axios';
import { spotifyConfig } from '../configs/spotifyConfig.js';
import { ModelUser } from '../schemas/user.js';
import { ModelArea } from '../schemas/actionReaction.js';
import _ from 'lodash';

const getNewAccessToken = async (user) => {
  try {
    const response = await axios({
      method: 'post',
      url: 'https://accounts.spotify.com/api/token',
      params: {
        grant_type: 'refresh_token',
        refresh_token: user.servicesData.get('spotify').refreshToken,
      },
      headers: {
        Authorization:
          'Basic ' +
          Buffer.from(
            spotifyConfig.client_id + ':' + spotifyConfig.client_secret
          ).toString('base64'),
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    });
    user.servicesData.get('spotify').accessToken = response.data.access_token;
    user.save();
  } catch (error) {

  }
};

const getLastAlbum = async (area, react, user) => {
  try {
    const response = await axios.get('https://api.spotify.com/v1/me/albums', {
      headers: {
        Authorization: 'Bearer ' + user.servicesData.get('spotify').accessToken,
      },
    });
    const albums = response.data.items[0].added_at;
    if (
      area.action.dataLocalServer?.spotifyTrigger?.lastAlbums &&
      !_.isEqual(area.action.dataLocalServer.spotifyTrigger.lastAlbums, albums)
    ) {
      react(area);
    }
    if (area.action.dataLocalServer?.spotifyTrigger?.lastAlbums) {
      delete area.action.dataLocalServer.spotifyTrigger.lastAlbums;
    }
    const toSend = {
      spotifyTrigger: {
        ...(area.action.dataLocalServer?.spotifyTrigger || {}),
        lastAlbums: albums,
      },
    };
    area.action.dataLocalServer.spotifyTrigger = toSend.spotifyTrigger;
    await ModelArea.findByIdAndUpdate(area._id, area);
  } catch (error) {

  }
};

const getLastSong = async (area, react, user) => {
  try {
    const response = await axios.get(
      'https://api.spotify.com/v1/me/player/recently-played',
      {
        headers: {
          Authorization:
            'Bearer ' + user.servicesData.get('spotify').accessToken,
        },
      }
    );
    const songs = response.data.items.map((item) => item.track.name);
    if (
      area.action.dataLocalServer?.spotifyTrigger?.lastSong &&
      !_.isEqual(area.action.dataLocalServer.spotifyTrigger.lastSong, songs)
    ) {
      react(area);
    }
    if (area.action.dataLocalServer?.spotifyTrigger?.lastSong) {
      delete area.action.dataLocalServer.spotifyTrigger.lastSong;
    }
    const toSend = {
      spotifyTrigger: {
        ...(area.action.dataLocalServer?.spotifyTrigger || {}),
        lastSong: songs,
      },
    };
    area.action.dataLocalServer.spotifyTrigger = toSend.spotifyTrigger;
    await ModelArea.findByIdAndUpdate(area._id, area);
  } catch (error) {

  }
};

const getLastPlaylist = async (area, react, user) => {
  try {
    const response = await axios.get(
      'https://api.spotify.com/v1/me/playlists',
      {
        headers: {
          Authorization:
            'Bearer ' + user.servicesData.get('spotify').accessToken,
        },
      }
    );
    const playlists = response.data.items.map((item) => item.id);
    if (
      area.action.dataLocalServer?.spotifyTrigger?.lastPlaylist &&
      !_.isEqual(
        area.action.dataLocalServer.spotifyTrigger.lastPlaylist,
        playlists
      )
    ) {
      react(area);
    }
    if (area.action.dataLocalServer?.spotifyTrigger?.lastPlaylist) {
      delete area.action.dataLocalServer.spotifyTrigger.lastPlaylist;
    }
    const toSend = {
      spotifyTrigger: {
        ...(area.action.dataLocalServer?.spotifyTrigger || {}),
        lastPlaylist: playlists,
      },
    };
    area.action.dataLocalServer.spotifyTrigger = toSend.spotifyTrigger;
    await ModelArea.findByIdAndUpdate(area._id, area);
  } catch (error) {

  }
};

async function CheckExistingConnection(user) {
  try {
    if (!user.servicesData || !user.servicesData.get('spotify')) {
      const ModelAreal = await ModelArea.findOne({ userId: user._id });
      if (ModelAreal) {
        await ModelAreal.deleteOne();
      }
      return false;
    }
    return true;
  } catch (error) {

    return false;
  }
}

async function sportifyTrigger(area, react)
{
  try {
    const user = await ModelUser.findOne({ _id: area.userId });
    if (!(await CheckExistingConnection(user))) {
      return;
    }
    if (area.action.name === 'last_playlist') {
      await getNewAccessToken(user);
      await getLastPlaylist(area, react, user);
    }
    if (area.action.name === 'last_song') {
      await getNewAccessToken(user);
      await getLastSong(area, react, user);
    }
    if (area.action.name === 'last_album') {
      await getNewAccessToken(user);
      await getLastAlbum(area, react, user);
    }
  } catch (error) {
  }
}

function sportifyTriggers(area, react) {
  sportifyTrigger(area, react);
}

export { sportifyTriggers };
