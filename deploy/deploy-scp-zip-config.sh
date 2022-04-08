#!/bin/bash

# ######################
# 一个临时的ci/cd脚本    
#   - 压缩并上传zip到指定服务器目录
#   - 解压后根据命令配置项目
# ######################

# 文件名
FILENAME='example'`date +%Y%m%d%H%M%S`
# 压缩包名
FILENAME_ZIP=${FILENAME}'.zip'
# 服务器账户
SERVER_USER=root
# 服务器ip
SERVER_IP=xxx.xxx.xxx.xxx
# 端口
SERVER_PORT=22
# 代码存放目录
SERVER_PATH=/home/wwwroot/example/
# 服务运行目录（这个会通过ln将代码目录映射并启动）
SERVER_RUN_PATH=/home/wwwroot/example
# env
ENV=/home/wwwroot/example/example.env

echo '>>> 压缩文件： 文件名： '${FILENAME}

# 压缩文件
if [ ! -d ./deploy ]; then
    mkdir ./deploy
fi
# -x 忽略压缩文件或目录
zip -r ./deploy/${FILENAME_ZIP} ./ -x .env deploy-example.sh deploy/\* runtime/\* .idea/\* .DS_Store/\* .git/\*

echo '>>> 部署代码：目标服务器:'${SERVER_IP}'， 存放代码目录：'${SERVER_PATH}

# 发送到远程服务器
scp -P ${SERVER_PORT} ./deploy/${FILENAME_ZIP} ${SERVER_USER}@${SERVER_IP}:${SERVER_PATH}

echo '>>> 解压和配置'
# 解压和配置
ssh -p ${SERVER_PORT} ${SERVER_USER}@${SERVER_IP} << EOF
cd ${SERVER_PATH}
mkdir ./${FILENAME}
unzip -o ./${FILENAME_ZIP} -d ./${FILENAME}
cp ${ENV} ./${FILENAME}/.env
EOF

# chmod +x ./${FILENAME}/bin/server.sh
# ln -fbs ${SERVER_PATH}/${FILENAME} ${SERVER_RUN_PATH}

# 安全起见：
# 需要自行到服务器移动项目目录或添加软链接
# 不使用脚本重启服务，到线上检查没问题后手动重启
# 根据打包时间区分版本控制，如有问题可以重新建立软连接重启
# 重启提示端口占用： netstat -tunlp|grep 9501
echo '>>> 部署完成, 安全起见，请确认后手动启动服务'








