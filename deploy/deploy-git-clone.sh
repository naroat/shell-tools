#!/bin/sh

# ip
host=ip地址
# 端口
port=22
# 项目在服务器上的目录
project_dir=/disk2/www/

if [ ! -d $project_dir ]
then
	echo '目录不存在!';
	exit;
fi

ssh -p $port root@$host "cd $project_dir && git clone"