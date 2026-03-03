FROM node:22-alpine
WORKDIR /app
RUN npm install -g pnpm
COPY package.json pnpm-lock.yaml ./ 
RUN pnpm install --prod
COPY . .
EXPOSE 18789
CMD ["pnpm", "exec", "openclaw", "gateway", "--port", "$PORT", "--verbose"]
