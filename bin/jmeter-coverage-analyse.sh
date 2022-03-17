#!/bin/bash 
# set -v on

export LC_COLLATE='C'
export LC_CTYPE='C'

system_type=`uname  -a`
system_mac="Darwin"

# 处理路径中存在.jmx导致后续处理把文件夹也作为文件处理并报错的问题
if [ -d "../src/test/jmeter/script/hilife-clothingsuppl.jmx" ]; then
    echo 修改带有jmx后缀的目录名
    mv ../src/test/jmeter/script/hilife-clothingsuppl.jmx ../src/test/jmeter/script/hilife-clothingsuppl
fi

# 处理文件名中存在空格的文件，这种文件在命令行中导致xargs命令处理参数是会出错
if [ -f "../src/test/jmeter/script/transactionmanage/hilife-Template/apiTest_ template.jmx" ]; then
    echo 修改带有空格的文件名
    mv "../src/test/jmeter/script/transactionmanage/hilife-Template/apiTest_ template.jmx" "../src/test/jmeter/script/transactionmanage/hilife-Template/apiTest_template.jmx"
fi

if [ -e "../out" ]; then
    rm -rf ../out
fi

if [ ! -d "../out" ]; then
    mkdir ../out
fi
if [ ! -d "../out/tmp" ]; then
    mkdir ../out/tmp
fi

echo 开始处理Jmeter文件
find ../ | grep .jmx | xargs grep "HTTPSampler.path" > ../out/tmp/interfacelist
echo 去掉xml标签头
if [[ $system_type =~ $system_mac ]];then 
    sed "s/\<stringProp\ name=\"HTTPSampler.path\"\>//g" ../out/tmp/interfacelist > ../out/tmp/interfacelist1
else
    sed "s/<stringProp\ name=\"HTTPSampler.path\">//g" ../out/tmp/interfacelist > ../out/tmp/interfacelist1
fi
echo 去掉xml标签尾
if [[ $system_type =~ $system_mac ]];then 
    sed "s/\<\/stringProp\>/\ /g" ../out/tmp/interfacelist1 > ../out/tmp/interfacelist2
else
    sed "s/<\/stringProp>/\ /g" ../out/tmp/interfacelist1 > ../out/tmp/interfacelist2
fi
echo 去掉前面文件路径部分
# (.*)标识匹配出换行符之外的任意字符任意次
if [[ $system_type =~ $system_mac ]];then 
    sed "s/\.\.\/\/src\/test\/jmeter.*\.jmx\://g" ../out/tmp/interfacelist2 > ../out/tmp/interfacelist3
else
    sed "s/\.\.\/src\/test\/jmeter.*\.jmx\://g" ../out/tmp/interfacelist2 > ../out/tmp/interfacelist3
fi
echo 去头尾空格
sed 's/[[:space:]]//g' ../out/tmp/interfacelist3 > ../out/tmp/interfacelist4
echo 去掉带有？的？后面的部分
sed 's/\?.*$//g' ../out/tmp/interfacelist4 > ../out/tmp/interfacelist5
echo 去掉带协议和domain部分
sed 's/https:\/\/test\.91hiwork\.com//g' ../out/tmp/interfacelist5 > ../out/tmp/interfacelist6
echo 去掉带协议和domain部分
sed 's/https:\/\/token\.91hiwork\.com//g' ../out/tmp/interfacelist6 > ../out/tmp/interfacelist7
echo 去掉带协议和domain部分
sed 's/https:\/\/token\.91hework\.com//g' ../out/tmp/interfacelist7 > ../out/tmp/interfacelist8
sed '/^\s*$/d' ../out/tmp/interfacelist8 > ../out/tmp/interfacelist9
echo 确保每行都已/开头，并去掉uri中存在的//的情况
echo 1
# 在每一行开头添加/
sed "s/^/\//g" ../out/tmp/interfacelist9 > ../out/tmp/interfacelist10
echo 2
# 将///替换成/
sed 's/\/\/\//\//g' ../out/tmp/interfacelist10 > ../out/tmp/interfacelist11
echo 3
# 将//替换成/
sed 's/\/\//\//g' ../out/tmp/interfacelist11 > ../out/tmp/interfacelist12


echo 去重
sort ../out/tmp/interfacelist12 | uniq > ../out/tmp/interfacelist13

echo 去掉结尾的.json
sed 's/\.json$//g' ../out/tmp/interfacelist13 > ../out/tmp/interfacelist14
sed 's/\.action$//g' ../out/tmp/interfacelist14 > ../out/tmp/interfacelist15

##################
# 去掉${*}的部分,这种部分是Jmeter引用参数的形式，降低Jmeter与Yapi参数不一致带来匹配偏差
# 这个必须放在处理/之后，因为这样处理过之后可能会出现尾部/、//、///的情况，这个特征与处理yapi一致，保障匹配的准确性
sed 's/\${[^}]*}//g' ../out/tmp/interfacelist15 > ../out/tmp/interfacelist16
##################
sed 's/^\/enterprise\/manage\//\//g' ../out/tmp/interfacelist16 > ../out/tmp/interfacelist17
##################

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
    appCode
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
    mall
    mallHome
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
    let interfacelistsource=i+17
    let interfacelistresult=i+18
    keystr=${my_array[$i]}
    sed 's/^\/'${keystr}'\//\//g' ../out/tmp/interfacelist${interfacelistsource} > ../out/tmp/interfacelist${interfacelistresult}
done;


let latestIndex=${#my_array[*]}+17
echo ${latestIndex}
sort ../out/tmp/interfacelist${latestIndex} | uniq > ../out/jmeter-interfacelist


#######################################################################################################################
echo 拉取Yapi中的接口列表
wget -q -O ../out/tmp/yapi.json.tmp "https://yapi.91hiwork.com/api/interface/list?project_id=366&token=59a4540a18d128222d3da393b6b14a0500fc21d96e0bed172d02fd5b137ea68f&page=1&limit=100000"
echo 格式化接口文档
cat ../out/tmp/yapi.json.tmp | jq > ../out/tmp/yapi.json

echo 开始处理yapi接口导出文件
grep "        \"path\": \"" ../out/tmp/yapi.json > ../out/tmp/yapi-interfacelist0
echo 去头尾空格
sed 's/[[:space:]]//g' ../out/tmp/yapi-interfacelist0 > ../out/tmp/yapi-interfacelist1
echo 双斜线替换成单斜线
sed 's/\/\//\//g' ../out/tmp/yapi-interfacelist1 > ../out/tmp/yapi-interfacelist2
echo 去掉无用的头部
sed 's/\"path\":\"//g' ../out/tmp/yapi-interfacelist2 > ../out/tmp/yapi-interfacelist3
echo 去掉无用的尾部
sed 's/\"\,//g' ../out/tmp/yapi-interfacelist3 > ../out/tmp/yapi-interfacelist4
##################
# 去掉{*}的部分,这种部分是Yapi定义参数的形式，降低Jmeter与Yapi参数不一致带来匹配偏差
# 这个必须放在处理/之后，因为这样处理过之后可能会出现尾部/、//、///的情况，这个特征与处理jmeter一致，保障匹配的准确性
sed 's/{[^}]*}//g' ../out/tmp/yapi-interfacelist4 > ../out/tmp/yapi-interfacelist5
##################
echo 去重
sort ../out/tmp/yapi-interfacelist5 | uniq > ../out/yapi-interfacelist
#######################################################################################################################
# 开始计算覆盖率
echo 合并文件
cat ../out/jmeter-interfacelist ../out/yapi-interfacelist > ../out/tmp/merge

echo 取重复项（jmeter覆盖到的yapi接口清单）
sort ../out/tmp/merge | uniq -d > ../out/jmeter-match-in-yapi

echo 输出在Jmeter中有但没有在yapi中记录的接口
cat ../out/jmeter-interfacelist ../out/jmeter-match-in-yapi > ../out/tmp/merge2
sort ../out/tmp/merge2 | uniq -u > ../out/jmeter-not-match-in-yapi

echo 输出在Yapi中但没有在Jmeter中的接口
cat ../out/yapi-interfacelist ../out/jmeter-match-in-yapi > ../out/tmp/merge3
sort ../out/tmp/merge3 | uniq -u > ../out/yapi-not-match-in-jmeter


# awk '{print NR}' ../out/jmeter-interfacelist | tail -n1
# awk '{print NR}' ../out/jmeter-match-in-yapi | tail -n1
# awk '{print NR}' ../out/jmeter-not-match-in-yapi | tail -n1
# awk '{print NR}' ../out/yapi-not-match-in-jmeter | tail -n1

jmeter_interfacelist=$(wc -l < ../out/jmeter-interfacelist)
echo "Jmeter接口数,${jmeter_interfacelist}" >> ../out/converage-result.csv

yapi_interfacelist=$(wc -l < ../out/yapi-interfacelist)
echo "Yapi接口数,${yapi_interfacelist}"  >> ../out/converage-result.csv

jmeter_match_in_yapi=$(wc -l < ../out/jmeter-match-in-yapi)
echo "Jmeter与Yapi匹配上的接口数,${jmeter_match_in_yapi}"  >> ../out/converage-result.csv

jmeter_not_match_in_yapi=$(wc -l < ../out/jmeter-not-match-in-yapi)
echo "Jmeter中未与Yapi匹配的接口数,${jmeter_not_match_in_yapi}" >> ../out/converage-result.csv

yapi_not_match_in_jmeter=$(wc -l < ../out/yapi-not-match-in-jmeter)
echo "yapi中未与Jmeter汽配的接口数,${yapi_not_match_in_jmeter}" >> ../out/converage-result.csv

export jmeter_match_in_yapi;
export yapi_interfacelist
awk  'BEGIN{printf "整体代码覆盖率，%0.2f",ENVIRON["jmeter_match_in_yapi"]/ENVIRON["yapi_interfacelist"]*100}' >> ../out/converage-result.csv



# 还原脚本开始的处理逻辑
# 处理路径中存在.jmx导致后续处理把文件夹也作为文件处理并报错的问题
if [[ -d "../src/test/jmeter/script/hilife-clothingsuppl" ]]; then
    echo 还原带有jmx后缀的目录名
    mv ../src/test/jmeter/script/hilife-clothingsuppl ../src/test/jmeter/script/hilife-clothingsuppl.jmx 
fi

# 处理文件名中存在空格的文件，这种文件在命令行中导致xargs命令处理参数是会出错
if [ -f "../src/test/jmeter/script/transactionmanage/hilife-Template/apiTest_template.jmx" ]; then
    echo 还原带有空格的文件名
    mv "../src/test/jmeter/script/transactionmanage/hilife-Template/apiTest_template.jmx" "../src/test/jmeter/script/transactionmanage/hilife-Template/apiTest_ template.jmx" 
fi