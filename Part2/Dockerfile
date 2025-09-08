# Stage 1: install dependencies
FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install --production

# Stage 2: runtime
FROM node:18-alpine

WORKDIR /app
# Copy dependencies from builder stage
COPY --from=builder /app/node_modules ./node_modules

# Copy app files from build context
COPY . .

EXPOSE 5000
CMD ["node", "server.js"]
