FROM node:21.4.0

WORKDIR /usr/app/serveur
COPY package.json .
RUN npm install
COPY . .
EXPOSE 8080
CMD ["npm", "start"]