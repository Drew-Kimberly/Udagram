import * as jwt from 'jsonwebtoken';
import { VerifyCallback } from 'jsonwebtoken';
import { UdagramJWTPayload } from './interfaces';

export class UdagramJWT<P extends UdagramJWTPayload> {
  protected secret: string;

  constructor(secret: string) {
    this.secret = secret;
  }

  public generateToken(payload: P): string {
    return jwt.sign(payload, this.secret);
  }

  public verifyToken(token: string, callback?: VerifyCallback): void {
    return jwt.verify(token, this.secret, callback);
  }
}
