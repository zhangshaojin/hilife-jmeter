#!/bin/bash 
# set -v on
# grep -o "\.\.\/src\/test\/jmeter.*\.jmx\:" ../out/tmp/interfacelist0 | sed "s/.*\///g" | sed "s/\.jmx://g"

subpath=$1
source_file_path=$2
target_file_path=$3
echo source_file_path:$source_file_path
echo target_file_path:$target_file_path

system_type=`uname  -a`
system_mac="Darwin"

cat $source_file_path > ../out/tmp/$subpath/tmp/interfacelist0
if [[ $system_type =~ $system_mac ]];then 
    sed_param_array=(
        "s/\<stringProp\ name=\"HTTPSampler.path\"\>//g" #去掉xml标签头
        "s/\<\/stringProp\>//g" #去掉xml标签尾
        "s/\.\.\/src\/test\/jmeter.*\.jmx\://g" #去掉前面文件路径部分
        "s/[[:space:]]//g" #去头尾空格
        "s/\?.*$//g" #去掉带有？的？后面的部分
        "s/https:\/\/test\.91hiwork\.com//g" #去掉带协议和domain部分
        "s/https:\/\/token\.91hiwork\.com//g" #去掉带协议和domain部分
        "s/https:\/\/token\.91hework\.com//g" #去掉带协议和domain部分
        "/^\s*$/d" #去掉空行
        "s/^/\//g" #确保每行都已/开头，并去掉uri中存在的//的情况
        "s/\/\/\//\//g" #确保每行都已/开头，并去掉uri中存在的//的情况
        "s/\/\//\//g" #确保每行都已/开头，并去掉uri中存在的//的情况
    )
else
    sed_param_array=(
        "s/<stringProp\ name=\"HTTPSampler.path\">//g" #去掉xml标签头
        "s/<\/stringProp>//g" #去掉xml标签尾
        "s/\.\.\/src\/test\/jmeter.*\.jmx\://g" #去掉前面文件路径部分
        "s/[[:space:]]//g" #去头尾空格
        "s/\?.*$//g" #去掉带有？的？后面的部分
        "s/https:\/\/test\.91hiwork\.com//g" #去掉带协议和domain部分
        "s/https:\/\/token\.91hiwork\.com//g" #去掉带协议和domain部分
        "s/https:\/\/token\.91hework\.com//g" #去掉带协议和domain部分
        "/^\s*$/d" #去掉空行
        "s/^/\//g" #确保每行都已/开头，并去掉uri中存在的//的情况
        "s/\/\/\//\//g" #确保每行都已/开头，并去掉uri中存在的//的情况
        "s/\/\//\//g" #确保每行都已/开头，并去掉uri中存在的//的情况
    )
fi

for(( i=0;i<${#sed_param_array[@]};i++)) do
        echo ${sed_param_array[$i]}
        let srcIndex=$i
        let targetIndex=$i+1
        sed "${sed_param_array[$i]}" ../out/tmp/$subpath/tmp/interfacelist$srcIndex > ../out/tmp/$subpath/tmp/interfacelist$targetIndex
done

echo 去重
sort ../out/tmp/$subpath/tmp/interfacelist12 | uniq > ../out/tmp/$subpath/tmp/interfacelist13

echo 去掉结尾的.json
sed 's/\.json$//g' ../out/tmp/$subpath/tmp/interfacelist13 > ../out/tmp/$subpath/tmp/interfacelist14
sed 's/\.action$//g' ../out/tmp/$subpath/tmp/interfacelist14 > ../out/tmp/$subpath/tmp/interfacelist15

##################
# 去掉${*}的部分,这种部分是Jmeter引用参数的形式，降低Jmeter与Yapi参数不一致带来匹配偏差
# 这个必须放在处理/之后，因为这样处理过之后可能会出现尾部/、//、///的情况，这个特征与处理yapi一致，保障匹配的准确性
sed 's/\${[^}]*}//g' ../out/tmp/$subpath/tmp/interfacelist15 > ../out/tmp/$subpath/tmp/interfacelist16

##################
# 按项目处理jmeter接口中多余的部分
my_array=(
    recommend
    order
    accesscontrol
    admin
    advert
    agent
    appmanage
    base-manage
    analysisacceptance
    client
    clothWeChat
    control-settlement
    coupon
    crm
    customerservice
    decoration
    deposit
    employeecenter
    erp
    estatepayment
    extecommerce
    finance
    front
    garbage
    goods
    heyoufamily
    householdv2
    housekeeper
    invoke
    manage
    md
    message
    mobile
    mobilemainpage
    mobilemainpageforthirdparty
    navigation
    new-payment
    oauth
    openid
    payment-account
    payment
    personregistermobile
    point
    polymerization
    popularize
    portal
    portalmanage
    programmanager
    promotion
    review
    sc-authority
    sc-crm
    shop
    shoppingCart
    smarttown
    staffworkbench
    stock
    supplier
    tickets
    transactionmanage
    transactionoauth
    vshop
    wxapplet
    wxoperatingtools
    yhbill
    backend
    backapi
)

for(( i=0;i<${#my_array[@]};i++)) do
    let interfacelistsource=i+16
    let interfacelistresult=i+17
    keystr=${my_array[$i]}
    sed 's/^\/'${keystr}'\//\//g' ../out/tmp/$subpath/tmp/interfacelist${interfacelistsource} > ../out/tmp/$subpath/tmp/interfacelist${interfacelistresult}
done;


let latestIndex=${#my_array[*]}+16
echo ${latestIndex}
let srcIndex=${latestIndex}
let targetIndex=${latestIndex}+1
##################
sed 's/^\/enterprise\/manage\//\//g' ../out/tmp/$subpath/tmp/interfacelist${srcIndex} > ../out/tmp/$subpath/tmp/interfacelist${targetIndex}
##################

sort ../out/tmp/$subpath/tmp/interfacelist${targetIndex} | uniq > $target_file_path