# Udagram Auth
An authentication lib for the Udagram app.

_This packaged is maintained via the [Udagram Monorepo](https://github.com/Drew-Kimberly/Udagram)_

[![npm version](https://badge.fury.io/js/%40drewkimberly%2Fudagram-auth.svg)](https://badge.fury.io/js/%40drewkimberly%2Fudagram-auth)

## Usage
#### `UdagramJWT`
This module exports the class `UdagramJWT<P extends UdagramJWTPayload>` which is a small abstraction
around JWT. The available API includes:

##### `generateToken(payload: P): string`
Generates a signed JWT token given a payload.

##### `verifyToken(token: string, callback?: VerifyCallback): void`
Verifies the provided JWT token. Verification logic is provided by the `callback`
parameter, which is documented in the JWT library [here](https://www.npmjs.com/package/jsonwebtoken#jwtverifytoken-secretorpublickey-options-callback).

#### `requireAuth`
This module exports an ExpressJS middleware handler:
```typescript
const requireAuth = (
  jwt: UdagramJWT<UdagramJWTPayload>
): RequestHandler => (req: Request, res: Response, next: NextFunction);
```

This middleware will verify that incoming API requests have an `Authorization` header and
that the provided token satisfies the given JWT. For example:

```typescript
import express from 'express';
import {requireAuth, UdagramJWT} from '@drewkimberly/udagram-auth'

const app = express();
app.get('/', requireAuth(new UdagramJWT('my-secret')), async (req, res) => {
  res.send('JWT Token Verified!');
});
```
