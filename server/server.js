import 'dotenv/config';
import './db/conn.js';
import express from 'express';
import cors from 'cors';
import cookieParser from 'cookie-parser';
import requestIp from 'request-ip';
import swaggerJSDoc from 'swagger-jsdoc';
import swaggerUi from 'swagger-ui-express';

import { connectServices } from './routes/connectServices.js';
import { usersRoutes } from './routes/usersRouter.js';
import { projectRouter } from './routes/projectRouter.js';
import { authRouter } from './routes/authRouter.js';
import { checkTriggers } from './area/area.js';
import { aboutRouter } from './routes/aboutRouter.js';

const app = express();
app.use(requestIp.mw());

const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Reactobot API',
      version: '1.0.0',
      description: 'API used to interact within the Reactobot.',
    },
    tags: [
      {
        name: 'Local Auth',
        description: 'Endpoints for local (email and password) authentication',
      },
      {
        name: 'Google Auth',
        description: 'Endpoints for Google authentication',
      },
    ],
  },
  paths: {},
  apis: ['./routes/*.js', './strategy/auth/*.js'],
};
const swaggerSpec = swaggerJSDoc(swaggerOptions);

app.use(
  cors({
    origin: [process.env.CLIENT_URL],
    credentials: true,
  })
);
app.set('trust proxy', true);
app.use(express.json());
app.use(cookieParser());
app.use('/about.json', aboutRouter);
app.use('/auth', authRouter);
app.use('/services', connectServices);
app.use('/user', usersRoutes);
app.use('/project', projectRouter);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

setInterval(checkTriggers, 1000);

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => console.log(`🚀 Server listening on port ${PORT}`));