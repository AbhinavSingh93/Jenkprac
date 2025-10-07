# Stage 1: Build Stage (using a robust image for building)
FROM node:20-alpine AS build
WORKDIR /app
# Copy package.json and package-lock.json and install dependencies
COPY package*.json ./
RUN npm install
# Copy all source files
COPY . .
# Stage 2: Production Stage (using a smaller image for running)
FROM node:20-alpine AS final
WORKDIR /app
# Copy the node_modules and built app from the build stage
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app .
EXPOSE 3000
CMD ["npm", "start"]