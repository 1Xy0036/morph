#!/bin/bash

# Function to display the menu
show_menu() {
    echo "===================================="
    echo "脚本以及教程由推特用户大贺哥 @95277777 编写，免费开源，请勿相信收费"
    echo "===================================="
    echo "节点社区 Telegram 群组: https://t.me/niuwuriji"
    echo "节点社区 Telegram 频道: https://t.me/niuwuriji"
    echo "请选择要执行的操作:"
    echo "1. 安装节点"
    echo "2. 启动节点"
    echo "3. 查看gethLog"
    echo "4. 查看节点是否正常"
    echo "5. 查看同步状态..."
}

# Function to handle user input
handle_choice() {
    case $1 in
        1)
            echo "安装节点..."
            mkdir -p ~/.morph 
            cd ~/.morph
            if [ ! -d "morph" ]; then
                git clone https://github.com/morph-l2/morph.git
            fi
            cd morph
            git checkout v0.1.0-beta
            make nccc_geth
            cd ~/.morph
            wget https://raw.githubusercontent.com/morph-l2/config-template/main/holesky/data.zip -O data.zip
            unzip -o data.zip
            openssl rand -hex 32 > jwt-secret.txt
            echo "===========安装完成============"
            ;;
        2)
            echo "启动节点..."
            screen -dmS morphNode bash -c './morph/go-ethereum/build/bin/geth --morph-holesky \
            --datadir "./geth-data" \
            --http --http.api=web3,debug,eth,txpool,net,engine \
            --authrpc.addr localhost \
            --authrpc.vhosts="localhost" \
            --authrpc.port 8551 \
            --authrpc.jwtsecret=./jwt-secret.txt \
            --miner.gasprice="100000000" \
            --log.filename=./geth.log'
            echo "节点已在后台启动。使用 screen -r morphNode 查看节点运行情况。"
            ;;
        3)
            echo "查看gethLog"
            screen -dmS gethLog bash -c 'tail -f ~/.morph/geth.log'
            echo "日志已在后台查看。使用 screen -r gethLog 查看日志。"
            ;;
        4)
            echo "查看节点是否正常"
            curl http://localhost:26657/net_info
            ;;
        5)
            echo "查看同步状态..."
            curl http://localhost:26657/status
            echo "catching_up表示节点是否同步。True 表示它是同步的。同时，返回的latest_block_height表示该节点同步的最新块高度。"
            ;;
        *)
            echo "无效的选项，请输入1-5之间的数字。"
            ;;
    esac
}

# Main loop
while true; do
    show_menu
    read -r choice
    handle_choice $choice
done
