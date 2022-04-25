#!/bin/bash 
# set -v on

# 处理路径中存在.jmx导致后续处理把文件夹也作为文件处理并报错的问题
if [ -d "../src/test/jmeter/script/hilife-clothingsuppl.jmx" ]; then
    echo 修改带有jmx后缀的目录名
    mv ../src/test/jmeter/script/hilife-clothingsuppl.jmx ../src/test/jmeter/script/hilife-clothingsuppl
fi

# 处理文件名中存在空格的文件，这种文件在命令行中导致xargs命令处理参数是会出错
if [ -f "../src/test/jmeter/script/transactionmanage/hilife-Template/apiTest_ template.jmx" ]; then
    echo 修改带有空格的文件名
    mv "../src/test/jmeter/script/transactionmanage/hilife-Template/apiTest_ template.jmx" "../src/test/jmeter/script/transactionmanage/hilife-Template/apiTest_template.jmx"
fi

if [ -e "../out" ]; then
    rm -rf ../out
fi

if [ ! -d "../out/tmp" ]; then
    mkdir -p ../out/tmp
fi

awk  'BEGIN{printf "%s,%s,%s,%s,%s,%s,%s\n","项目名","jmeter_interfacelist","yapi_interfacelist","jmeter_match_in_yapi","jmeter_not_match_in_yapi","yapi_not_match_in_jmeter","jmeter_match_in_yapi/yapi_interfacelist*100"}' >> ../out/jmeter-converage-result.csv
#############################################################
# 预处理yapi接口
./handle-yapi-interface.sh ../out/yapi-interfacelist
# 计算整体覆盖率(以全部yapi接口为参照计算全部jmeter接口的覆盖率)
./jmeter-coverage-analyse-all.sh
# 计算项目覆盖率(以全部yapi接口为参照计算单个jmeter项目接口的覆盖率)
./jmeter-coverage-analyse-project.sh
# 计算项目覆盖率(以全部jmeter接口为参照计算单个yapi项目接口的覆盖率)
./yapi-coverage-analyse-project.sh
#############################################################

# 还原脚本开始的处理逻辑
# 处理路径中存在.jmx导致后续处理把文件夹也作为文件处理并报错的问题
if [[ -d "../src/test/jmeter/script/hilife-clothingsuppl" ]]; then
    echo 还原带有jmx后缀的目录名
    mv ../src/test/jmeter/script/hilife-clothingsuppl ../src/test/jmeter/script/hilife-clothingsuppl.jmx 
fi

# 处理文件名中存在空格的文件，这种文件在命令行中导致xargs命令处理参数是会出错
if [ -f "../src/test/jmeter/script/transactionmanage/hilife-Template/apiTest_template.jmx" ]; then
    echo 还原带有空格的文件名
    mv "../src/test/jmeter/script/transactionmanage/hilife-Template/apiTest_template.jmx" "../src/test/jmeter/script/transactionmanage/hilife-Template/apiTest_ template.jmx" 
fi

# #############################################################
# # 结果存档
# datetime=`date +%Y%m%d%H%m%s`
# if [[ ! -d "../analyse/$datetime" ]]; then
#     mkdir -p ../analyse/$datetime
# fi
# rsync -avt --exclude-from=./conf/archive-exclude.list ../out/ ../analyse/$datetime
#############################################################