#!/bin/bash

# Function to display the menu
show_menu() {
    echo "===================================="
    echo "脚本以及教程由推特用户大贺哥 @95277777 编写，免费开源，请勿相信收费"
    echo "===================================="
    echo "节点社区 Telegram 群组: https://t.me/niuwuriji"
    echo "节点社区 Telegram 频道: https://t.me/niuwuriji"
    echo "请选择要执行的操作:"
    echo "1. 安装常规节点"
    echo "2. 重启节点"
    echo "3. Mac 节点安装"
    echo "4. 更新本脚本"
    echo "5. 卸载节点"
    echo "6. 升级节点程序版本"
    echo "7. 开发节点程序版本 (针对contabo)"
    echo "8. 常规节点程序版本 (针对contabo)"
    echo "9. 安装grpc"
    echo "===================================="
    echo "单独使用功能"
    echo "===================================="
    echo "4. 独立启动挖矿 (安装好常规节点后搭配使用)"
    echo "5. 备份功能"
    echo "===================================="
    echo "收米查询"
    echo "===================================="
    echo "6. 查询余额 (需要先安装grpc)"
    echo "请输入选项 (1-13): "
}

# Function to handle user input
handle_choice() {
    case $1 in
        1)
            echo "安装节点..."
            mkdir -p ~/.morph 
            cd ~/.morph
            git clone https://github.com/morph-l2/morph.git
            cd morph
            git checkout v0.1.0-beta
            make nccc_geth
            cd ~/.morph
            wget https://raw.githubusercontent.com/morph-l2/config-template/main/holesky/data.zip
            unzip data.zip
            cd ~/.morph
            openssl rand -hex 32 > jwt-secret.txt
            echo "===========安装完成============"
            ;;
        2)
            echo "启动节点..."
            screen -S morphNode
            ./morph/go-ethereum/build/bin/geth --morph-holesky \
            --datadir "./geth-data" \
            --http --http.api=web3,debug,eth,txpool,net,engine \
            --authrpc.addr localhost \
            --authrpc.vhosts="localhost" \
            --authrpc.port 8551 \
            --authrpc.jwtsecret=./jwt-secret.txt \
            --miner.gasprice="100000000" \
            --log.filename=./geth.log
            # 按下 Ctrl+A，然后按 D 将会话分离

            ;;
        3)
            echo "查看gethLog"
            screen -S gethLog
            tail -f geth.log
            ;;
        4)
            echo "查看节点是否正常"
            screen -S netInfo
            curl http://localhost:26657/net_info
            ;;
        5)
            echo "查看同步状态..."
            curl http://localhost:26657/status
            echo "catching_up”表示节点是否同步。True 表示它是同步的。同时，返回的latest_block_height表示该节点同步的最新块高度。"
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

