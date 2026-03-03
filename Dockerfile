# 选用稳定的Debian镜像，自带git且内存管理更友好
FROM node:22-bookworm-slim

# 安装必要系统依赖 + 解决SSL证书验证问题
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    # 关键：跳过git的SSL证书验证，解决访问GitHub仓库失败问题
    && git config --global http.sslVerify false

# 设置工作目录
WORKDIR /app

# 复制核心依赖文件
COPY package.json pnpm-lock.yaml ./

# 安装pnpm并配置项目依赖
RUN npm install -g pnpm@latest --no-fund --no-audit && \
    pnpm install --prod --no-cache

# 复制项目所有文件
COPY . .

# 暴露服务端口
EXPOSE 18789

# 关键修复：用bash执行openclaw，同时通过NODE_OPTIONS设置内存上限
ENV NODE_OPTIONS="--max-old-space-size=8192"
CMD ["bash", "-c", "./node_modules/.bin/openclaw gateway --port 18789 --verbose --allow-unconfigured"]
