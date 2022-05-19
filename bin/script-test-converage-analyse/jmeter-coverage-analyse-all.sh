#!/bin/bash 
# set -v on

# 将所有jmeter接口与yapi接口进行匹配，计算出整体覆盖率

export LC_COLLATE='C'
export LC_CTYPE='C'

system_type=`uname  -a`
system_mac="Darwin"


if [ ! -d "../out/all" ]; then
    mkdir -p ../out/all
fi
if [ ! -d "../out/tmp/all/tmp" ]; then
    mkdir -p ../out/tmp/all/tmp
fi


echo 开始处理Jmeter文件
find ../src | grep .jmx | xargs grep "HTTPSampler.path" > ../out/tmp/all/tmp/interfacelist-tmp
./script-test-converage-analyse/handle-jmeter-interface.sh all ../out/tmp/all/tmp/interfacelist-tmp ../out/all/jmeter-interfacelist


#######################################################################################################################
# ./handle-yapi-interface.sh ../out/tmp/yapi-interfacelist
#######################################################################################################################
# 开始计算整体覆盖率
echo 合并文件
cat ../out/all/jmeter-interfacelist ../out/tmp/yapi-interfacelist > ../out/tmp/all/tmp/merge

echo 取重复项（jmeter覆盖到的yapi接口清单）
sort ../out/tmp/all/tmp/merge | uniq -d > ../out/all/jmeter-match-in-yapi

echo 输出在Jmeter中有但没有在yapi中记录的接口
cat ../out/all/jmeter-interfacelist ../out/all/jmeter-match-in-yapi > ../out/tmp/all/tmp/merge2
sort ../out/tmp/all/tmp/merge2 | uniq -u > ../out/all/jmeter-not-match-in-yapi

echo 输出在Yapi中但没有在Jmeter中的接口
cat ../out/tmp/yapi-interfacelist ../out/all/jmeter-match-in-yapi > ../out/tmp/all/tmp/merge3
sort ../out/tmp/all/tmp/merge3 | uniq -u > ../out/all/yapi-not-match-in-jmeter

jmeter_interfacelist=$(wc -l < ../out/all/jmeter-interfacelist)
echo "all,Jmeter接口数,${jmeter_interfacelist}"

yapi_interfacelist=$(wc -l < ../out//tmp/yapi-interfacelist)
echo "all,Yapi接口数,${yapi_interfacelist}"

jmeter_match_in_yapi=$(wc -l < ../out/all/jmeter-match-in-yapi)
echo "all,Jmeter与Yapi匹配上的接口数,${jmeter_match_in_yapi}"

jmeter_not_match_in_yapi=$(wc -l < ../out/all/jmeter-not-match-in-yapi)
echo "all,Jmeter中未与Yapi匹配的接口数,${jmeter_not_match_in_yapi}"

yapi_not_match_in_jmeter=$(wc -l < ../out/all/yapi-not-match-in-jmeter)
echo "all,yapi中未与Jmeter匹配的接口数,${yapi_not_match_in_jmeter}"

subpath="all"
export subpath
export jmeter_interfacelist
export yapi_interfacelist
export jmeter_match_in_yapi
export jmeter_not_match_in_yapi
export yapi_not_match_in_jmeter
awk  'BEGIN{printf "%s,%d,%d,%d,%d,%d,%0.2f\n",ENVIRON["subpath"],ENVIRON["jmeter_interfacelist"],ENVIRON["yapi_interfacelist"],ENVIRON["jmeter_match_in_yapi"],ENVIRON["jmeter_not_match_in_yapi"],ENVIRON["yapi_not_match_in_jmeter"],ENVIRON["jmeter_match_in_yapi"]/ENVIRON["yapi_interfacelist"]*100}' >> ../out/jmeter-converage-result.csv