FROM node:18.10-alpine AS build

RUN mkdir -p /app

WORKDIR /app

COPY package.json /app

RUN npm install

COPY . /app

RUN npm run build

# Serve Application using Nginx Server
FROM nginx:1.17.10-alpine
EXPOSE 80
COPY --from=build /app/dist/quiniela-ui/ /usr/share/nginx/html