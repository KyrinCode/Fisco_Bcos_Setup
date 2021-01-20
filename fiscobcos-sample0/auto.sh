#!/usr/bin/env sh

# echo -e "\033[32m 绿色字 \033[0m"

# 确保脚本抛出遇到的错误
set -e

# 生成区块链配置文件
cat > ipconf << EOF
127.0.0.1:2 agencyA 1,2,3
127.0.0.1:2 agencyB 1
127.0.0.1:2 agencyC 2
127.0.0.1:2 agencyD 3
EOF

# 构建节点配置文件夹
bash build_chain.sh -f ipconf -p 30300,20200,8545

# 启动所有节点
cd nodes/127.0.0.1
bash start_all.sh

# 准备出4个机构的控制台
cd -
tar xzf console.tar.gz
mv console consoleA
cp -r consoleA consoleB
cp -r consoleA consoleC
cp -r consoleA consoleD

# 当前自动生层的sdk属于agencyA
cd nodes/127.0.0.1
mv sdk sdk_agencyA

# 为其余机构生成sdk
cp ../../gen_node_cert.sh ./
bash gen_node_cert.sh -c ../cert/agencyB -o sdk_agencyB -s
bash gen_node_cert.sh -c ../cert/agencyC -o sdk_agencyC -s
bash gen_node_cert.sh -c ../cert/agencyD -o sdk_agencyD -s

# 将机构的SDK证书拷贝至控制台配置目录
cd ../../consoleA
cp ../nodes/127.0.0.1/sdk_agencyA/* conf/
cd ../consoleB
cp ../nodes/127.0.0.1/sdk_agencyB/* conf/
cd ../consoleC
cp ../nodes/127.0.0.1/sdk_agencyC/* conf/
cd ../consoleD
cp ../nodes/127.0.0.1/sdk_agencyD/* conf/

# 获取各节点的channel_listen_port
grep "channel_listen_port" ../nodes/127.0.0.1/node*/config.ini

# 根据channel_listen_port修改控制台配置文件
cd ../consoleA/conf
cp config-example.toml config.toml
cd ../../consoleB/conf
sed 's/20200/20202/g' config-example.toml | sed 's/20201/20203/g' > config.toml
cd ../../consoleC/conf
sed 's/20200/20204/g' config-example.toml | sed 's/20201/20205/g' > config.toml
cd ../../consoleD/conf
sed 's/20200/20206/g' config-example.toml | sed 's/20201/20207/g' > config.toml

# 把代币合约放到合约目录
cd ../..
cp ICTCoin.sol consoleA/contracts/solidity/
cp ICTCoin.sol consoleB/contracts/solidity/