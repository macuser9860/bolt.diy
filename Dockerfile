# Use Ubuntu as the base image
FROM ubuntu:24.04 as bolt-ai-production

# Set environment variables
ENV NODE_VERSION=20.x
ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_OPTIONS="--max-old-space-size=2048"
ENV HOST=0.0.0.0

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and pnpm
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - \
    && apt-get update \
    && apt-get install -y nodejs \
    && npm install -g npm@latest \
    && npm install -g pnpm

# Set the working directory
WORKDIR /app

# Clone the repository
RUN git clone https://github.com/stackblitz-labs/bolt.diy.git .

# Add environment variables to a .env.local file
RUN echo "OPENAI_API_KEY=dummy\n\
NODE_ENV=production\n\
PORT=5173\n\
VITE_LOG_LEVEL=debug\n\
DEFAULT_NUM_CTX=32768\n\
RUNNING_IN_DOCKER=true" > .env.local

# Install dependencies
RUN pnpm install

# Build the project
RUN pnpm run build

# Expose the port
EXPOSE 5173

# Command to start the application
CMD ["pnpm", "run", "dockerstart"]
