FROM node:22-alpine3.19

# 安装 git，解决依赖安装时 spawn git ENOENT 错误
RUN apk add --no-cache git

WORKDIR /app

# 复制依赖文件
COPY package.json pnpm-lock.yaml ./

# 优化安装步骤，减少内存占用
RUN npm install -g pnpm --no-fund --no-audit && \
    pnpm install --prod --no-cache && \
    npm uninstall -g pnpm

# 复制项目文件
COPY . .

EXPOSE 18789

CMD ["npm", "start"]
