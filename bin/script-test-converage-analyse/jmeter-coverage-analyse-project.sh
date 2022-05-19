#!/bin/bash 
# set -v on
# copy from jmeter-coverage-analyse.sh
# 分开计算覆盖率

export LC_COLLATE='C'
export LC_CTYPE='C'

system_type=`uname  -a`
system_mac="Darwin"


# 先把yapi的接口列表整理一下，输出到../out/tmp/api-interfacelist文件中
# ./handle-yapi-interface.sh ../out/tmp/yapi-interfacelist

echo 开始处理Jmeter文件
find ../src | grep "\.jmx" > ../out/tmp/jmx-file-list-tmp

# 设置IFS,将分隔符设置为换行符
OLDIFS=$IFS
IFS=$'\t\n'
# 读取文件中的内容到数组中
array=($(cat ../out/tmp/jmx-file-list-tmp))
# 恢复之前的设置
IFS=$OLDIFS

echo ${#array[@]}
for(( i=0;i<${#array[@]};i++)) do
    echo $i ${array[$i]} >> ../out/tmp/jmx-file-list
    echo ${array[$i]} > ../out/tmp/jmx-file
    project_name=`sed "s/.*\///g" ../out/tmp/jmx-file`
    if [ ! -d "../out/tmp/jmater-converage/$project_name/tmp" ]; then
        mkdir -p ../out/tmp/jmater-converage/$project_name/tmp
    fi
    if [ ! -d "../out/jmater-converage/$project_name" ]; then
        mkdir -p ../out/jmater-converage/$project_name
    fi
    grep "HTTPSampler.path" ${array[$i]} > ../out/tmp/jmater-converage/$project_name/tmp/interfacelist-tmp
    ./script-test-converage-analyse/handle-jmeter-interface.sh jmater-converage/$project_name ../out/tmp/jmater-converage/$project_name/tmp/interfacelist-tmp ../out/jmater-converage/$project_name/jmeter-interfacelist-$project_name

    ./script-test-converage-analyse/handle-coverage.sh jmeter yapi \
        jmater-converage/$project_name $project_name \
        ../out/jmater-converage/$project_name/jmeter-interfacelist-$project_name \
        ../out/tmp/yapi-interfacelist ../out/jmeter-converage-result.csv \
        'BEGIN{printf "%s,%d,%d,%d,%d,%d,%0.2f\n",ENVIRON["project_name"], ENVIRON["jmeter_interfacelist"],ENVIRON["yapi_interfacelist"], ENVIRON["jmeter_match_in_yapi"],ENVIRON["jmeter_not_match_in_yapi"], ENVIRON["yapi_not_match_in_jmeter"],ENVIRON["jmeter_match_in_yapi"]/ENVIRON["yapi_interfacelist"]*100}'
done;