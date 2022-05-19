#!/bin/bash 
# set -v on

if [ ! -d "../out/tmp/yapi-tmp/cat" ]; then
    mkdir -p ../out/tmp/yapi-tmp/cat
fi
echo cat_name,cat_id,interface_count > ../out/yapi-cat-interface-statistics.csv
echo cat_id,cat_name,cat_apicount,yapi-interfacelist-filepath > ../out/tmp/yapi-interfacelist-filepath-list
for((i=1;i<$#;i+=2));
do
    let j=i+1
    cat_name=${!i}
    cat_id=${!j}

    
    let length=`cat ../out/tmp/yapi-tmp/yapi.json | jq '.data.list | map(select(.catid=='$cat_id')) | length'`
    echo $cat_name $cat_id $length
    echo $cat_name,$cat_id,$length >> ../out/yapi-cat-interface-statistics.csv
    cat ../out/tmp/yapi-tmp/yapi.json | jq '.data.list | map(select(.catid=='$cat_id'))' > ../out/tmp/yapi-tmp/cat/$cat_id-$cat_name.json
    cat ../out/tmp/yapi-tmp/cat/$cat_id-$cat_name.json | jq -r ".[].path" > ../out/tmp/yapi-tmp/cat/$cat_id-$cat_name.list
    # 's/\/\//\//g' 将接口文档中的//替换成/
    # 's/{[^}]*}//g' 将接口文档中路径参数{param}去除掉，做匹配的时候这部分没有意义
    cat ../out/tmp/yapi-tmp/cat/$cat_id-$cat_name.list \
    | sed 's/\/\//\//g' \
    | sed 's/{[^}]*}//g' \
    | sort | uniq > ../out/tmp/yapi-tmp/cat/yapi-interfacelist-$cat_id-$cat_name
    echo $cat_id,$cat_name,$length,../out/tmp/yapi-tmp/cat/yapi-interfacelist-$cat_id-$cat_name >> ../out/tmp/yapi-interfacelist-filepath-list
done
