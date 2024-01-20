import { ModelUser } from '../schemas/user.js';
import { jwtToken } from '../configs/jwtConfig.js';

import jwt from 'jsonwebtoken';

const authController = {
  signup: async (req, res) => {
    const isMobile = !!req.query.mobile;
    const existingUser = await ModelUser.findOne({ email: req.body.email });
    if (existingUser) return res.status(409).json({ message: "Already existing user" });
    const modelUser = new ModelUser({ name: req.body.name, password: req.body.password, email: req.body.email });
    await modelUser.save()
    const user = { _id: modelUser._id, name: req.body.name, email: req.body.email, isGoogleAuth: false, isMobile };
    const token = jwt.sign({ user }, jwtToken.tokenSecret, { expiresIn: jwtToken.tokenExpiration });
    res.cookie('token', token, {
      maxAge: jwtToken.tokenExpiration,
      httpOnly: true,
    });
    res.status(201).json({
      user,
    });
  },
  signin: async (req, res) => {
    const isMobile = !!req.query.mobile;
    const existingUser = await ModelUser.findOne({ email: req.body.email });
    const isPasswordMatch = await existingUser?.comparePassword(req.body.password);
    if (!existingUser || !isPasswordMatch) return res.status(401).json({ message: "Incorrect email or password" });
    const user = { _id: existingUser._id, name: existingUser.name, email: existingUser.email, isGoogleAuth: false, isMobile };
    const token = jwt.sign({ user }, jwtToken.tokenSecret, { expiresIn: jwtToken.tokenExpiration });
    res.cookie('token', token, {
      maxAge: jwtToken.tokenExpiration,
      httpOnly: true,
    });
    res.status(201).json({
      user,
    });
  },
};

export { authController };
