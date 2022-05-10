#!/bin/bash 
# set -v on

if [ ! -d "../out/yapi-tmp/cat" ]; then
    mkdir -p ../out/yapi-tmp/cat
fi
echo cat_name,cat_id,interface_count > ../out/yapi-cat-interface-statistics.csv
echo cat_id,cat_name,cat_apicount,yapi-interfacelist-filepath > ../out/yapi-interfacelist-filepath-list
for((i=1;i<$#;i+=2));
do
    let j=i+1
    cat_name=${!i}
    cat_id=${!j}

    
    let length=`cat ../out/yapi-tmp/yapi.json | jq '.data.list | map(select(.catid=='$cat_id')) | length'`
    echo $cat_name $cat_id $length
    echo $cat_name,$cat_id,$length >> ../out/yapi-cat-interface-statistics.csv
    cat ../out/yapi-tmp/yapi.json | jq '.data.list | map(select(.catid=='$cat_id'))' > ../out/yapi-tmp/cat/$cat_id-$cat_name.json
    cat ../out/yapi-tmp/cat/$cat_id-$cat_name.json | jq -r ".[].path" > ../out/yapi-tmp/cat/$cat_id-$cat_name.list
    # 's/\/\//\//g' 将接口文档中的//替换成/
    # 's/{[^}]*}//g' 将接口文档中路径参数{param}去除掉，做匹配的时候这部分没有意义
    cat ../out/yapi-tmp/cat/$cat_id-$cat_name.list \
    | sed 's/\/\//\//g' \
    | sed 's/{[^}]*}//g' \
    | sort | uniq > ../out/yapi-tmp/cat/yapi-interfacelist-$cat_id-$cat_name
    echo $cat_id,$cat_name,$length,../out/yapi-tmp/cat/yapi-interfacelist-$cat_id-$cat_name >> ../out/yapi-interfacelist-filepath-list
done
