import { NextFunction, Request, RequestHandler, Response } from 'express';
import { UdagramJWT } from '../jwt';
import { UdagramJWTPayload } from '../interfaces';

export const requireAuth = (
  jwt: UdagramJWT<UdagramJWTPayload>
): RequestHandler => (req: Request, res: Response, next: NextFunction) => {
  if (!req.headers || !req.headers.authorization) {
    return res.status(401).send({ message: 'No authorization headers.' });
  }

  const token_bearer = req.headers.authorization.split(' ');
  if (token_bearer.length !== 2) {
    return res.status(401).send({ message: 'Malformed token.' });
  }

  const token = token_bearer[1];

  return jwt.verifyToken(token, err => {
    if (err) {
      return res
        .status(403)
        .send({ auth: false, message: 'Failed to authenticate.' });
    }
    return next();
  });
};
