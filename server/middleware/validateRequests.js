import { validationResult } from 'express-validator';

const validateReq = (req, res, next) => {
  const result = validationResult(req);
  if (!result.isEmpty()) {
    return res.status(400).json({ message: result.errors[0].msg });
  }
  next();
};

export { validateReq };
