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

# 按照yapi接口分类统计接口数量并拆分接口定义到对应的json文件中
cat ../out/yapi-tmp/yapi_cat.json | jq -r '.data | map(.name,._id) | join(" ")' | xargs ./handle-yapi-cat.sh

echo 开始处理yapi接口导出文件

# 's/\/\//\//g' 将接口文档中的//替换成/
# 's/{[^}]*}//g' 将接口文档中路径参数{param}去除掉，做匹配的时候这部分没有意义
jq -r '.data.list[].path' ../out/yapi-tmp/yapi.json \
| sed 's/\/\//\//g' \
| sed 's/{[^}]*}//g' \
| sort | uniq > $target_file_path
#######################################################################################################################