#!/bin/sh

# 设置工作目录
SCRIPT_PATH=$(realpath "$0")
WORKDIR=$(dirname "${SCRIPT_PATH}")
cd "${WORKDIR}"
FILES_PATH=${FILES_PATH:-./}
CMD="$@"

# 固定版本号（不要用 latest）
FIXED_VERSION="v3.29.1"
DOWNLOAD_LINK="https://github.com/AlistGo/alist/releases/download/v3.29.1/alist-freebsd-amd64.tar.gz"

# 临时文件夹
TMP_DIRECTORY="$(mktemp -d)"
ZIP_FILE="${TMP_DIRECTORY}/alist-freebsd-amd64.tar.gz"

# 如果 web.js 不存在则下载
if [ ! -f "./web.js" ]; then
    echo "📥 未发现 web.js，正在下载 AList ${FIXED_VERSION}..."
    if wget -qO "$ZIP_FILE" "$DOWNLOAD_LINK"; then
        echo "✅ 下载完成，正在解压..."
        tar -xzf "$ZIP_FILE" -C "$TMP_DIRECTORY"
        install -m 755 ${TMP_DIRECTORY}/alist ${FILES_PATH}/web.js
        chmod +x ./web.js
    else
        echo "❌ 下载失败，请检查网络连接或链接有效性。"
        rm -rf "$TMP_DIRECTORY"
        exit 1
    fi
fi

# 启动 AList
echo "🚀 正在启动 AList ${FIXED_VERSION}..."
chmod +x ./web.js
exec ./web.js server > /dev/null 2>&1 &
rm -rf "$TMP_DIRECTORY"
