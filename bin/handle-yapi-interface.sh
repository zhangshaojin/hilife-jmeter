#!/bin/bash 
# set -v on

# ./handle-yapi-interface.sh ../out/yapi-interfacelist

target_file_path=$1
if [ ! -d "../out/yapi-tmp" ]; then
    mkdir -p ../out/yapi-tmp
fi
#######################################################################################################################
echo 拉取Yapi中的接口列表
wget -q -O ../out/yapi-tmp/yapi.json.tmp "https://yapi.91hiwork.com/api/interface/list?project_id=366&token=59a4540a18d128222d3da393b6b14a0500fc21d96e0bed172d02fd5b137ea68f&page=1&limit=100000"
echo 格式化接口文档
cat ../out/yapi-tmp/yapi.json.tmp | jq > ../out/yapi-tmp/yapi.json
echo 拉取Yapi中的接口分类列表
wget -q -O ../out/yapi-tmp/yapi_cat.json.tmp "https://yapi.91hiwork.com/api/interface/getCatMenu?project_id=366&token=59a4540a18d128222d3da393b6b14a0500fc21d96e0bed172d02fd5b137ea68f"
echo 格式化接口分类文档
cat ../out/yapi-tmp/yapi_cat.json.tmp | jq > ../out/yapi-tmp/yapi_cat.json

# 打印分类清单
# cat ../out/yapi-tmp/yapi_cat.json | jq '.data[].name'
# cat ../out/yapi-tmp/yapi_cat.json | jq '.data[].name,.data[]._id'
# cat ../out/yapi-tmp/yapi.json | jq '.data.list | map(select(.catid==8175)) | length'
cat ../out/yapi-tmp/yapi_cat.json | jq -r '.data | map(.name,._id) | join(" ")' | xargs ./handle-yapi-cat.sh

echo 开始处理yapi接口导出文件
grep "        \"path\": \"" ../out/yapi-tmp/yapi.json > ../out/yapi-tmp/yapi-interfacelist0
echo 去头尾空格
sed 's/[[:space:]]//g' ../out/yapi-tmp/yapi-interfacelist0 > ../out/yapi-tmp/yapi-interfacelist1
echo 双斜线替换成单斜线
sed 's/\/\//\//g' ../out/yapi-tmp/yapi-interfacelist1 > ../out/yapi-tmp/yapi-interfacelist2
echo 去掉无用的头部
sed 's/\"path\":\"//g' ../out/yapi-tmp/yapi-interfacelist2 > ../out/yapi-tmp/yapi-interfacelist3
echo 去掉无用的尾部
sed 's/\"\,//g' ../out/yapi-tmp/yapi-interfacelist3 > ../out/yapi-tmp/yapi-interfacelist4
##################
# 去掉{*}的部分,这种部分是Yapi定义参数的形式，降低Jmeter与Yapi参数不一致带来匹配偏差
# 这个必须放在处理/之后，因为这样处理过之后可能会出现尾部/、//、///的情况，这个特征与处理jmeter一致，保障匹配的准确性
sed 's/{[^}]*}//g' ../out/yapi-tmp/yapi-interfacelist4 > ../out/yapi-tmp/yapi-interfacelist5
##################
echo 去重
sort ../out/yapi-tmp/yapi-interfacelist5 | uniq > $target_file_path
#######################################################################################################################