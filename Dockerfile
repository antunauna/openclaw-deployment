# 选用稳定的Debian镜像，自带git且内存管理更友好，彻底解决spawn git ENOENT错误
FROM node:22-bookworm-slim

# 安装必要系统依赖（仅保留核心工具，降低内存占用）
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 复制核心依赖文件（优先复制锁文件，利用Docker缓存层优化构建）
COPY package.json pnpm-lock.yaml ./

# 安装pnpm并配置项目依赖（不卸载全局pnpm，避免启动时找不到命令；--no-cache减少内存占用）
RUN npm install -g pnpm@latest --no-fund --no-audit && \
    pnpm install --prod --no-cache

# 复制项目所有文件
COPY . .

# 暴露服务端口（与启动命令端口保持一致）
EXPOSE 18789

# 最终启动命令（直接写死端口，彻底解决Invalid port问题；包含--allow-unconfigured避免配置缺失崩溃）
CMD ["pnpm", "exec", "openclaw", "gateway", "--port", "18789", "--verbose", "--allow-unconfigured"]
