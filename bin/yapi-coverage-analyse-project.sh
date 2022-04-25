#!/bin/bash 
# set -v on
# 分开计算覆盖率

export LC_COLLATE='C'
export LC_CTYPE='C'

system_type=`uname  -a`
system_mac="Darwin"

echo 开始处理Yapi Cat接口清单文件

awk  'BEGIN{printf "%s,%s,%s,%s,%s,%s,%s\n","项目名","yapi_interfacelist","jmeter_interfacelist","yapi_match_in_jmeter","yapi_not_match_in_jmeter","jmeter_not_match_in_yapi","yapi_interfacelist/jmeter_match_in_yapi*100"}' >> ../out/yapi-converage-result.csv

# 设置IFS,将分隔符设置为换行符
OLDIFS=$IFS
IFS=$'\t\n'
# 读取文件中的内容到数组中
array=($(cat ../out/yapi-interfacelist-filepath-list))
# 恢复之前的设置
IFS=$OLDIFS

echo ${#array[@]}
for(( i=1;i<${#array[@]};i++)) do
    OLDIFS=$IFS
    IFS=$','
    # 读取文件中的内容到数组中
    array_tmp=(${array[$i]})
    # 恢复之前的设置
    IFS=$OLDIFS
    cat_id=${array_tmp[0]}
    echo ${cat_id}
    cat_name=${array_tmp[1]}
    echo ${cat_name}
    cat_apicount=${array_tmp[2]}
    echo ${cat_apicount}
    yapi_interfacelist_filepath="${array_tmp[3]}"
    echo ${yapi_interfacelist_filepath}
    # subpath=`sed "s/.*\///g" ../out/tmp/jmx-file`
    if [ ! -d "../out/yapi-converage-tmp/${cat_name}/tmp/" ]; then
        mkdir -p ../out/yapi-converage-tmp/${cat_name}/tmp/
    fi
    ./handle-coverage.sh yapi-converage-tmp/${cat_name} ${cat_name} ${yapi_interfacelist_filepath} ../out/all/jmeter-interfacelist ../out/yapi-converage-result.csv
done;