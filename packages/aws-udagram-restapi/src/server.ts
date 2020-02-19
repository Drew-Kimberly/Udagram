import express from 'express';
import cors, { CorsOptions } from 'cors';
import { sequelize } from './sequelize';
import { IndexRouter } from './controllers/v0/index.router';
import bodyParser from 'body-parser';
import { V0MODELS } from './controllers/v0/model.index';

(async () => {
  await sequelize.addModels(V0MODELS);
  await sequelize.sync();

  const app = express();
  const port = process.env.PORT || 8080; // default port to listen

  app.use(bodyParser.json());

  // Setup CORS middleware.
  const originWhitelist = [
    'http://localhost:4200',
    'http://localhost:8100',
    'http://d3puk6p5a7fcax.cloudfront.net'
  ];
  const corsOptions: CorsOptions = {
    allowedHeaders: [
      'Origin',
      'X-Requested-With',
      'Content-Type',
      'Accept',
      'Authorization'
    ],
    origin: (
      origin: string,
      callback: (err: Error | null, allow?: boolean) => void
    ) =>
      originWhitelist.includes(origin)
        ? callback(null, true)
        : callback(null, false)
  };
  app.use(cors(corsOptions));
  app.options('*', cors());

  app.use('/api/v0/', IndexRouter);

  // Root URI call
  app.get('/', async (req, res) => {
    res.send('/api/v0/');
  });

  // Start the Server
  app.listen(port, () => {
    console.log(`server running http://localhost:${port}`);
    console.log(`press CTRL+C to stop server`);
  });
})();
