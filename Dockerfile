FROM node:22-alpine3.19

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
