import jwt from 'jsonwebtoken';
import axios from 'axios';

import { discordConfig } from '../configs/discordConfig.js';
import { jwtToken } from '../configs/jwtConfig.js';
import { ModelUser } from '../schemas/user.js';
import { getTokenParams } from '../utils/utils.js';

const discordCallback = async (req, res) => {
  try {
    const { user } = jwt.verify(req.cookies.token, jwtToken.tokenSecret);
    const { code } = req.query;
    const existingUser = await ModelUser.findOne({ email: user.email });
    if (!existingUser) {
      return res.status(404).jqueryStringson({ message: 'User not found' });
    }
    const formData = getTokenParams(discordConfig, code, user.isMobile);
    const output = await axios.post(
      `https://discord.com/api/oauth2/token`,
      formData,
      {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      }
    );
    const andpoint = 'discord';
    const spotifyServiceData = existingUser.servicesData.get(andpoint);
    if (spotifyServiceData) {
      spotifyServiceData.isConnected = true;
      spotifyServiceData.accessToken = output.data.access_token;
      spotifyServiceData.refreshToken = output.data.refresh_token;
      spotifyServiceData.data = {
        ...output.data,
      };
    } else {
      const newSpotifyServiceData = {
        isConnected: true,
        accessToken: output.data.access_token,
        refreshToken: output.data.refresh_token,
        data: {
          ...output.data,
        },
      };
      existingUser.servicesData.set(andpoint, newSpotifyServiceData);
    }
    await existingUser.save();
    res.status(201).json({ message: 'Successful connection' });
  } catch (err) {
    console.error('Error: ', err);
    res.status(500).json({ message: err.message || 'Server error' });
  }
};

export { discordCallback };
