FROM node:24-alpine

WORKDIR /app

# Install dependencies first for better Docker layer caching
COPY package*.json ./

RUN npm ci

# Copy source code
COPY . .

EXPOSE 8000

CMD ["npm", "run", "dev"]