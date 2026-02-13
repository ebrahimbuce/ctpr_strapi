# Stage 1: Build the application
FROM node:20-alpine AS build

# Install dependencies needed for build
RUN apk add --no-cache python3 make g++ vips-dev

WORKDIR /opt/app

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Strapi admin panel
ENV NODE_ENV=production
RUN npm run build

# Stage 2: Create the production image
FROM node:20-alpine

# Install runtime dependencies (vips-dev is needed for sharp image processing)
RUN apk add --no-cache vips-dev

WORKDIR /opt/app

# Set environment to production
ENV NODE_ENV=production

# Copy dependencies and built assets from build stage
# Note: In a real production setup, you might want to run install --production again here 
# instead of copying node_modules to ensure a cleaner state, but copying works for most cases.
COPY --from=build /opt/app/node_modules ./node_modules
COPY --from=build /opt/app/dist ./dist
COPY --from=build /opt/app/public ./public
COPY --from=build /opt/app/package.json ./package.json
# COPY --from=build /opt/app/favicon.png ./favicon.png 

# Copy configuration and database folders (essential for runtime config)
COPY --from=build /opt/app/config ./config
COPY --from=build /opt/app/database ./database

# Expose the Strapi port
EXPOSE 1337

# Start Strapi
CMD ["npm", "run", "start"]
