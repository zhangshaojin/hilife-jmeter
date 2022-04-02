#!/bin/bash 
# set -v on

if [ ! -d "../out/yapi-tmp/cat" ]; then
    mkdir -p ../out/yapi-tmp/cat
fi
echo cat_name,cat_id,interface_count > ../out/yapi-cat-interface-statistics.csv
for((i=1;i<$#;i+=2));
do
    let j=i+1
    cat_name=${!i}
    cat_id=${!j}

    
    let length=`cat ../out/yapi-tmp/yapi.json | jq '.data.list | map(select(.catid=='$cat_id')) | length'`
    echo $cat_name $cat_id $length
    echo $cat_name,$cat_id,$length >> ../out/yapi-cat-interface-statistics.csv
    cat ../out/yapi-tmp/yapi.json | jq '.data.list | map(select(.catid=='$cat_id'))' > ../out/yapi-tmp/cat/$cat_id-$cat_name.json
done
