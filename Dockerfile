# Stage 1: Build the application
FROM node:20-alpine AS build

# Set working directory
WORKDIR /opt/app

# Install dependencies needed for build
# python3, make, g++ are often needed for native modules (like sharp)
RUN apk add --no-cache python3 make g++

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies (including devDependencies for build)
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Strapi admin panel
ENV NODE_ENV=production
RUN npm run build

# Prune dev dependencies to keep the image small
RUN npm prune --production

# Stage 2: Create the production image
FROM node:20-alpine

# Set working directory
WORKDIR /opt/app

# Install runtime dependencies if needed (e.g., for sharp)
RUN apk add --no-cache vips-dev

# Copy built application from the build stage
COPY --from=build /opt/app/node_modules ./node_modules
COPY --from=build /opt/app/dist ./dist
COPY --from=build /opt/app/public ./public
COPY --from=build /opt/app/package.json ./package.json
COPY --from=build /opt/app/favicon.png ./favicon.png

# Copy other necessary files (config, src, etc. might be needed depending on how Strapi runs in prod, usually dist is enough but config is critical)
# In Strapi 5, dist contains the compiled code, but config files are often read at runtime.
# Let's copy config and database folders just in case, though dist usually has everything.
# Actually, Strapi 5 builds into dist, so we should be good with dist.
# However, the server might need access to `config/` if it's not fully bundled (it usually is).
# Let's copy the whole app source just to be safe, excluding what's in .dockerignore
COPY --from=build /opt/app/config ./config
COPY --from=build /opt/app/database ./database
COPY --from=build /opt/app/src ./src

# Set environment variables
ENV NODE_ENV=production
ENV PATH=/opt/app/node_modules/.bin:$PATH

# Expose the Strapi port
EXPOSE 1337

# Start the application
CMD ["npm", "run", "start"]
