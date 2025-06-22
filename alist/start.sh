#!/bin/sh

# 设置路径
SCRIPT_PATH=$(realpath "$0")
WORKDIR=$(dirname "${SCRIPT_PATH}")
cd "${WORKDIR}"
FILES_PATH=${FILES_PATH:-./}
CMD="$@"

# 固定版本
FIXED_VERSION="v3.29.1"
DOWNLOAD_LINK="https://github.com/AlistGo/alist/releases/download/${FIXED_VERSION}/alist-freebsd-amd64.tar.gz"

# 创建临时目录
TMP_DIRECTORY="$(mktemp -d)"
ZIP_FILE="${TMP_DIRECTORY}/alist-freebsd-amd64.tar.gz"

# 下载并安装 AList
echo "📥 下载 AList ${FIXED_VERSION}..."
if wget -qO "$ZIP_FILE" "$DOWNLOAD_LINK"; then
    echo "✅ 解压并安装..."
    tar -xzf "$ZIP_FILE" -C "$TMP_DIRECTORY"
    install -m 755 "${TMP_DIRECTORY}/alist" "${FILES_PATH}/web.js"
    chmod +x "${FILES_PATH}/web.js"
else
    echo "❌ 下载失败，请检查网络连接或链接是否有效。"
    rm -rf "$TMP_DIRECTORY"
    exit 1
fi

# 启动
echo "🚀 正在启动 AList ${FIXED_VERSION}..."
exec ./web.js server > /dev/null 2>&1 &
rm -rf "$TMP_DIRECTORY"
