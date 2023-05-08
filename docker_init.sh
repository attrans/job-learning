#!/bin/bash

## 打开错误退出开关
sed -i 's/dexadfspringboot:.*/dexadfspringboot:'"$dexadfspringboot"'/g' dockerfile/Dockerfile
set -e

## 约定的传入参数，将gerrit工程的所有编译打包结果都拷贝到该目录下。该工程编译生成几个image就有几个子目录。
WORKSPACE=$1
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CODE_DIR="$(dirname ${SCRIPT_DIR})"
PROJECT_NAME="nia-qualcommon-service"

## 根据template.json蓝图的定义，要求必须与蓝图中定义的image名称一致
DEST_DIR=${WORKSPACE}/${PROJECT_NAME}-sl

##创建对应image的目标文件夹
mkdir -p ${DEST_DIR}

## 进入工程根目录
cd $CODE_DIR

## maven build，编译结果通常在target目录下
mvn install -Dmaven.test.skip=true
mkdir ./target/lib/activiti-engine-5.22.0
cp -rf ./activiti-schema/ ./target/lib/activiti-engine-5.22.0
mv ./target/lib/activiti-engine-5.22.0.jar ./target/lib/activiti-engine-5.22.0
pushd ./target/lib/activiti-engine-5.22.0
unzip activiti-engine-5.22.0.jar
rm activiti-engine-5.22.0.jar
rm -rf org/activiti/db/create/*.sql
mv ./activiti-schema/*.sql org/activiti/db/create/
rmdir ./activiti-schema
chown -R oes:oes ./
chmod -R 540 ./
zip -rv activiti-engine-5.22.0.jar ./
mv activiti-engine-5.22.0.jar ../
popd
rm -rf ./target/lib/activiti-engine-5.22.0/
chown oes:oes ./target/lib/activiti-engine-5.22.0.jar
chmod 540 ./target/lib/activiti-engine-5.22.0.jar

## 编译结果打包，取决于Dockerfile的build逻辑如何定义
cp ./bin/run.sh ./target
cp ./bin/setenv.sh ./target
#cp ./bin/push-menu-nii.sh ./target
cp -r ./config ./target/
cp -r ./menus ./target/
pushd target

mkdir -p tmp
JAR_NAME=`ls | grep -x ${PROJECT_NAME}-*-SNAPSHOT.jar`
unzip -q ${JAR_NAME} -d tmp
rm -rf ${JAR_NAME}

find ./tmp -name "pom.properties" -exec rm -rf {} \;
find ./tmp * -exec touch -t ${tag} {} \;

pushd tmp
zip -qXr ../${JAR_NAME} ./*
popd
rm -rf tmp

find ../ * -exec touch -t ${tag} {} \;

# 非root权限更改
chown -R oes:oes ./${JAR_NAME} ./lib ./*.sh ./config ./menus
chmod -R 540 ./${JAR_NAME} ./lib ./*.sh ./config ./menus
chmod 750 ./config ./menus

tar cvf ${PROJECT_NAME}.tar ./${JAR_NAME} ./lib ./*.sh ./config ./menus
touch -t ${tag} ${PROJECT_NAME}.tar
gzip ${PROJECT_NAME}.tar
rm ./*.sh
rm -rf ./config
rm -rf ./menus
popd

## 将Dockerfile和打包文件拷贝到目标文件夹
cp -rf dockerfile/Dockerfile ${DEST_DIR}
mv ./target/${PROJECT_NAME}.tar.gz ${DEST_DIR}
