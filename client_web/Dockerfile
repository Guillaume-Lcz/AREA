FROM node:21.4.0
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8081
ENV PORT 8081
ENV REACT_APP_SERVER_URL http://localhost:8080
CMD ["npm", "start"]