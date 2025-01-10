FROM ubuntu:24.04 as bolt-ai-production

ENV NODE_VERSION=20.x
ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_OPTIONS="--max-old-space-size=2048"
ENV HOST=0.0.0.0

RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - \
    && apt-get update \
    && apt-get install -y nodejs \
    && npm install -g npm@latest \
    && npm install -g pnpm

WORKDIR /app

RUN git clone https://github.com/stackblitz-labs/bolt.diy.git .

RUN echo "OPENAI_API_KEY=dummy\n\
NODE_ENV=production\n\
PORT=5173\n\
VITE_LOG_LEVEL=debug\n\
DEFAULT_NUM_CTX=32768\n\
RUNNING_IN_DOCKER=true" > .env.local

RUN pnpm install

RUN pnpm run build

EXPOSE 5173

CMD ["pnpm", "run", "dockerstart"]

