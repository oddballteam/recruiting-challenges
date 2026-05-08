FROM node:14
WORKDIR /usr/src/app
RUN "git rev-parse HEAD > version.txt"
ADD package*.json app.js ./
RUN npm install
EXPOSE 3000
CMD ["node", "app.js"]