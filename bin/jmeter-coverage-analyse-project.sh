#!/bin/bash 
# set -v on
# copy from jmeter-coverage-analyse.sh
# 分开计算覆盖率

export LC_COLLATE='C'
export LC_CTYPE='C'

system_type=`uname  -a`
system_mac="Darwin"


# 先把yapi的接口列表整理一下，输出到../out/yapi-interfacelist文件中
./handle-yapi-interface.sh ../out/yapi-interfacelist

echo 开始处理Jmeter文件
find .. | grep "\.jmx" > ../out/jmx-file-list-tmp

# 设置IFS,将分隔符设置为换行符
OLDIFS=$IFS
IFS=$'\t\n'
# 读取文件中的内容到数组中
array=($(cat ../out/jmx-file-list-tmp))
# 恢复之前的设置
IFS=$OLDIFS

echo ${#array[@]}
for(( i=0;i<${#array[@]};i++)) do
    echo $i ${array[$i]} >> ../out/jmx-file-list
    echo ${array[$i]} > ../out/jmx-file
    subpath=`sed "s/.*\///g" ../out/jmx-file`
    if [ ! -d "../out/$subpath" ]; then
        mkdir ../out/$subpath
    fi    
    if [ ! -d "../out/$subpath/tmp" ]; then
        mkdir ../out/$subpath/tmp
    fi    

    grep "HTTPSampler.path" ${array[$i]} > ../out/$subpath/tmp/interfacelist-tmp
    ./handle-jmeter-interface.sh $subpath ../out/$subpath/tmp/interfacelist-tmp ../out/$subpath/jmeter-interfacelist-$subpath

    ./handle-coverage.sh $subpath ../out/$subpath/jmeter-interfacelist-$subpath ../out/yapi-interfacelist ../out/converage-result.csv
done;