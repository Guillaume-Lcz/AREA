import jwt from 'jsonwebtoken';
import { oauth2Client } from '../configs/googleConfig.js'

import { jwtToken } from '../configs/jwtConfig.js';
import { ModelUser } from '../schemas/user.js'

const googleCallback = async (req, res) => {
    try {
        const { user } = jwt.verify(req.cookies.token, jwtToken.tokenSecret);
        const { code } = req.query;
        const existingUser = await ModelUser.findOne({ email: user.email });
        if (!existingUser) {
            return res.status(404).json({ message: 'User not found' });
        }
        const { tokens } = await oauth2Client.getToken(code);
        oauth2Client.setCredentials(tokens);
        const andpoint = 'google'
        const spotifyServiceData = existingUser.servicesData.get(andpoint);
        if (spotifyServiceData) {
            spotifyServiceData.isConnected = true;
            spotifyServiceData.accessToken = tokens.access_token;
            spotifyServiceData.refreshToken = tokens.refresh_token;
            spotifyServiceData.data = {
                ...tokens
            }
        } else {
            const newGoogleData = {
                isConnected: true,
                accessToken: tokens.access_token,
                refreshToken: tokens.refresh_token,
                data: {
                    ...tokens
                }
            };
            existingUser.servicesData.set(andpoint, newGoogleData);
        }
        await existingUser.save();
        res.status(201).json({ message: "Successful connection" });
    } catch (err) {
        console.error('Error: ', err);
        res.status(500).json({ message: err.message || 'Server error' });
    }
};

export { googleCallback }