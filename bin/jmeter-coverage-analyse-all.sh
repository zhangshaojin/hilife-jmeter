#!/bin/bash 
# set -v on

# 将所有jmeter接口与yapi接口进行匹配，计算出整体覆盖率

export LC_COLLATE='C'
export LC_CTYPE='C'

system_type=`uname  -a`
system_mac="Darwin"


if [ ! -d "../out/all" ]; then
    mkdir ../out/all
fi
if [ ! -d "../out/all/tmp" ]; then
    mkdir ../out/all/tmp
fi

echo 开始处理Jmeter文件
find ../src | grep .jmx | xargs grep "HTTPSampler.path" > ../out/all/tmp/interfacelist
echo 去掉xml标签头
if [[ $system_type =~ $system_mac ]];then 
    sed "s/\<stringProp\ name=\"HTTPSampler.path\"\>//g" ../out/all/tmp/interfacelist > ../out/all/tmp/interfacelist1
else
    sed "s/<stringProp\ name=\"HTTPSampler.path\">//g" ../out/all/tmp/interfacelist > ../out/all/tmp/interfacelist1
fi
echo 去掉xml标签尾
if [[ $system_type =~ $system_mac ]];then 
    sed "s/\<\/stringProp\>/\ /g" ../out/all/tmp/interfacelist1 > ../out/all/tmp/interfacelist2
else
    sed "s/<\/stringProp>/\ /g" ../out/all/tmp/interfacelist1 > ../out/all/tmp/interfacelist2
fi
echo 去掉前面文件路径部分
# (.*)标识匹配出换行符之外的任意字符任意次
sed "s/\.\.\/src\/test\/jmeter.*\.jmx\://g" ../out/all/tmp/interfacelist2 > ../out/all/tmp/interfacelist3

echo 去头尾空格
sed 's/[[:space:]]//g' ../out/all/tmp/interfacelist3 > ../out/all/tmp/interfacelist4
echo 去掉带有？的？后面的部分
sed 's/\?.*$//g' ../out/all/tmp/interfacelist4 > ../out/all/tmp/interfacelist5
echo 去掉带协议和domain部分
sed 's/https:\/\/test\.91hiwork\.com//g' ../out/all/tmp/interfacelist5 > ../out/all/tmp/interfacelist6
echo 去掉带协议和domain部分
sed 's/https:\/\/token\.91hiwork\.com//g' ../out/all/tmp/interfacelist6 > ../out/all/tmp/interfacelist7
echo 去掉带协议和domain部分
sed 's/https:\/\/token\.91hework\.com//g' ../out/all/tmp/interfacelist7 > ../out/all/tmp/interfacelist8
sed '/^\s*$/d' ../out/all/tmp/interfacelist8 > ../out/all/tmp/interfacelist9
echo 确保每行都已/开头，并去掉uri中存在的//的情况
echo 1
# 在每一行开头添加/
sed "s/^/\//g" ../out/all/tmp/interfacelist9 > ../out/all/tmp/interfacelist10
echo 2
# 将///替换成/
sed 's/\/\/\//\//g' ../out/all/tmp/interfacelist10 > ../out/all/tmp/interfacelist11
echo 3
# 将//替换成/
sed 's/\/\//\//g' ../out/all/tmp/interfacelist11 > ../out/all/tmp/interfacelist12


echo 去重
sort ../out/all/tmp/interfacelist12 | uniq > ../out/all/tmp/interfacelist13

echo 去掉结尾的.json
sed 's/\.json$//g' ../out/all/tmp/interfacelist13 > ../out/all/tmp/interfacelist14
sed 's/\.action$//g' ../out/all/tmp/interfacelist14 > ../out/all/tmp/interfacelist15

##################
# 去掉${*}的部分,这种部分是Jmeter引用参数的形式，降低Jmeter与Yapi参数不一致带来匹配偏差
# 这个必须放在处理/之后，因为这样处理过之后可能会出现尾部/、//、///的情况，这个特征与处理yapi一致，保障匹配的准确性
sed 's/\${[^}]*}//g' ../out/all/tmp/interfacelist15 > ../out/all/tmp/interfacelist16

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
    sed 's/^\/'${keystr}'\//\//g' ../out/all/tmp/interfacelist${interfacelistsource} > ../out/all/tmp/interfacelist${interfacelistresult}
done;


let latestIndex=${#my_array[*]}+16
echo ${latestIndex}
let srcIndex=${latestIndex}
let targetIndex=${latestIndex}+1
##################
sed 's/^\/enterprise\/manage\//\//g' ../out/all/tmp/interfacelist${srcIndex} > ../out/all/tmp/interfacelist${targetIndex}
##################

sort ../out/all/tmp/interfacelist${targetIndex} | uniq > ../out/all/jmeter-interfacelist


#######################################################################################################################
./handle-yapi-interface.sh ../out/all/yapi-interfacelist
#######################################################################################################################
# 开始计算整体覆盖率
echo 合并文件
cat ../out/all/jmeter-interfacelist ../out/all/yapi-interfacelist > ../out/all/tmp/merge

echo 取重复项（jmeter覆盖到的yapi接口清单）
sort ../out/all/tmp/merge | uniq -d > ../out/all/jmeter-match-in-yapi

echo 输出在Jmeter中有但没有在yapi中记录的接口
cat ../out/all/jmeter-interfacelist ../out/all/jmeter-match-in-yapi > ../out/all/tmp/merge2
sort ../out/all/tmp/merge2 | uniq -u > ../out/all/jmeter-not-match-in-yapi

echo 输出在Yapi中但没有在Jmeter中的接口
cat ../out/all/yapi-interfacelist ../out/all/jmeter-match-in-yapi > ../out/all/tmp/merge3
sort ../out/all/tmp/merge3 | uniq -u > ../out/all/yapi-not-match-in-jmeter

jmeter_interfacelist=$(wc -l < ../out/all/jmeter-interfacelist)
echo "all,Jmeter接口数,${jmeter_interfacelist}"

yapi_interfacelist=$(wc -l < ../out/all/yapi-interfacelist)
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