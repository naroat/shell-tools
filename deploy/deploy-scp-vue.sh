#!/bin/sh

# ip
host=ip地址
# 端口
port=22
# 部署后的目录名称
deploy_name=dist
# 需要上传的文件夹名称(保持默认)
build_dir=dist
# 项目在服务器上的目录
project_dir=/disk2/www/

if [ ! -d $build_dir ]
then
	echo '目录不存在!';
	exit;
fi

# 上传
scp -r -P $port $build_dir root@$host:$project_dir;
# 改名
if [ $deploy_name != $build_dir ]
then
    ssh -p $port root@$host "mv $project_dir$build_dir $project_dir$deploy_name"
fi

