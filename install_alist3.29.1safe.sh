# 清屏
clear

# 判断是否在 public_nodejs 目录下
if [ "$(basename "$(pwd)")" == "public_nodejs" ]; then

    # 删除残留文件（忽略不存在的）
    rm -f public/index.html start.sh alist web.js

    # 需要的文件
    files=("app.js" "start.sh" "package.json" "alist-freebsd-amd64.tar.gz")
    urls=(
        "https://raw.githubusercontent.com/jinnan11/serv00-alist/main/alist/app.js"
        "https://raw.githubusercontent.com/jinnan11/serv00-alist/main/alist/start.sh"
        "https://raw.githubusercontent.com/jinnan11/serv00-alist/main/alist/package.json"
        "https://github.com/AlistGo/alist/releases/download/v3.29.1/alist-freebsd-amd64.tar.gz"
    )

    # 下载所需文件
    for i in "${!files[@]}"; do
        if [ ! -f "${files[$i]}" ]; then
            echo "正在下载 ${files[$i]} ..."
            wget -q "${urls[$i]}" -O "${files[$i]}"
        fi
    done

    # 解压 alist 文件
    if [ -f "alist-freebsd-amd64.tar.gz" ]; then
        tar -xzf alist-freebsd-amd64.tar.gz
        rm -f alist-freebsd-amd64.tar.gz
        rm -rf temp

        # 移动主程序到 web.js 并赋权
        if [ -f "alist" ]; then
            mv alist web.js
            chmod +x web.js
            ./web.js server
        else
            echo "未找到 alist 可执行文件，解压可能失败。"
            exit 1
        fi
    fi

    # 判断是否存在 data 文件夹
    if [ -d "data" ]; then
        clear
        echo -e "✅ 已成功安装 Alist（v3.29.1）！\n"
        echo -e "📁 请在 File manager 中，编辑 app.js 和 data/config.json\n"
    else
        # 使您能够运行自己的软件
        devil binexec on

        # 删除 web.js 和 start.sh 避免残留
        rm -f web.js start.sh

        clear
        echo "⚠️ 未检测到 data 文件夹，请断开 SSH 并重新运行本脚本。"
    fi

else
    clear
    echo "❌ 请确认已进入 public_nodejs 目录下再运行本脚本。"
    echo "建议检查您创建的网站类型是否为 Node.js。"
fi
