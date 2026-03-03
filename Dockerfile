# 使用 Debian 基础镜像，自带 git，彻底解决 ENOENT 问题
FROM node:22-bookworm

WORKDIR /app

# 复制依赖文件
COPY package.json pnpm-lock.yaml ./

# 安装 pnpm 并安装依赖
RUN npm install -g pnpm --no-fund --no-audit && \
    pnpm install --prod --no-cache && \
    npm uninstall -g pnpm

# 复制项目文件
COPY . .

EXPOSE 18789

CMD ["npm", "start"]
