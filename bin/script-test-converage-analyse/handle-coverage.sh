#!/bin/bash 
# set -v on

# 计算单独项目的覆盖率，由于总接口数参照的是所有项目接口的总和，所以这里计算jmeter覆盖到yapi的接口数与Yapi接口数的比例已经没有什么意义
# 所以这里计算jmeter覆盖到yapi的接口数与Jmeter接口数的比例，这样计算出来的结果代表了jmeter中的接口是不是都已经命中到yapi

source=$1
target=$2
subpath=$3
project_name=$4
jmeter_interfice_list_file_path=$5
yapi_interfice_list_file_path=$6
output_file_path=$7
awk_cmd=`echo ${@:8}`
echo jmeter_interfice_list_file_path:$jmeter_interfice_list_file_path
echo yapi_interfice_list_file_path:$yapi_interfice_list_file_path

# 开始计算覆盖率
echo 合并文件
cat $jmeter_interfice_list_file_path $yapi_interfice_list_file_path > ../out/tmp/$subpath/tmp/merge

echo 取重复项（jmeter覆盖到的yapi接口清单）
sort ../out/tmp/$subpath/tmp/merge | uniq -d > ../out/$subpath/$source-match-in-$target

echo 输出在Jmeter中有但没有在yapi中记录的接口
cat $jmeter_interfice_list_file_path ../out/$subpath/$source-match-in-$target > ../out/tmp/$subpath/tmp/merge2
sort ../out/tmp/$subpath/tmp/merge2 | uniq -u > ../out/$subpath/$source-not-match-in-$target

echo 输出在Yapi中但没有在Jmeter中的接口
cat $yapi_interfice_list_file_path ../out/$subpath/$source-match-in-$target > ../out/tmp/$subpath/tmp/merge3
sort ../out/tmp/$subpath/tmp/merge3 | uniq -u > ../out/$subpath/$target-not-match-in-$source


jmeter_interfacelist=$(wc -l < $jmeter_interfice_list_file_path)
echo "$subpath,Jmeter接口数,${jmeter_interfacelist}" 

yapi_interfacelist=$(wc -l < $yapi_interfice_list_file_path)
echo "$subpath,Yapi接口数,${yapi_interfacelist}"

jmeter_match_in_yapi=$(wc -l < ../out/$subpath/$source-match-in-$target)
echo "$subpath,Jmeter与Yapi匹配上的接口数,${jmeter_match_in_yapi}"

jmeter_not_match_in_yapi=$(wc -l < ../out/$subpath/$source-not-match-in-$target)
echo "$subpath,Jmeter中未与Yapi匹配的接口数,${jmeter_not_match_in_yapi}"

yapi_not_match_in_jmeter=$(wc -l < ../out/$subpath/$target-not-match-in-$source)
echo "$subpath,yapi中未与Jmeter汽配的接口数,${yapi_not_match_in_jmeter}"

export project_name
export jmeter_interfacelist
export yapi_interfacelist
export jmeter_match_in_yapi
export jmeter_not_match_in_yapi
export yapi_not_match_in_jmeter
awk "$awk_cmd" >> $output_file_path