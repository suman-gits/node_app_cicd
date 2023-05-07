FROM node:12.2.0-alpine

ARG artifact= target/nodeapp-cicd.jar
WORKDIR app

COPY ${artifact} app

RUN npm install express

EXPOSE 3000

CMD ["node","app.js"]
