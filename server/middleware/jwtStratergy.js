import jwt from 'jsonwebtoken';
import { jwtToken } from '../configs/jwtConfig.js';

const authMiddleware = (req, res, next) => {
  try {
    const token = req.cookies.token;
    if (!token) return res.status(401).json({ message: 'Unauthorized' });
    jwt.verify(token, jwtToken.tokenSecret);
    return next();
  } catch (err) {
    console.error('Error: ', err);
    res.status(401).json({ message: 'Unauthorized' });
  }
};

export { authMiddleware as auth };
