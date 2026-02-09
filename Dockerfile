# Multi-stage build para producción (Coolify / Strapi 5)
# Ver: https://docs.strapi.io/dev-docs/installation/docker

FROM node:20-alpine AS build

# Dependencias para sharp y compilación nativa
RUN apk update && apk add --no-cache \
  build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev git

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/

COPY package.json package-lock.json ./
RUN npm install -g node-gyp && \
  npm config set fetch-retry-maxtimeout 600000 -g && \
  npm ci

ENV PATH=/opt/node_modules/.bin:$PATH

WORKDIR /opt/app
COPY . .

RUN npm run build

# Imagen final reducida
FROM node:20-alpine

RUN apk add --no-cache vips-dev

ENV NODE_ENV=production

WORKDIR /opt/
COPY --from=build /opt/node_modules ./node_modules
COPY --from=build /opt/package.json ./package.json
COPY --from=build /opt/package-lock.json ./package-lock.json
RUN npm prune --production

WORKDIR /opt/app
COPY --from=build /opt/app ./

ENV PATH=/opt/node_modules/.bin:$PATH

RUN chown -R node:node /opt/app
USER node

EXPOSE 1337

CMD ["npm", "run", "start"]
