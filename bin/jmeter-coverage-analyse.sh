#!/bin/bash 
set -v on

echo 开始处理Jmeter文件
find ../ | grep .jmx | xargs grep "HTTPSampler.path" > ../out/interfacelist
echo 去掉xml标签头
sed "s/\<stringProp\ name=\"HTTPSampler.path\"\>//g" ../out/interfacelist > ../out/interfacelist1
echo 去掉xml标签尾
sed "s/\<\/stringProp\>/\ /g" ../out/interfacelist1 > ../out/interfacelist2
echo 去掉前面文件路径部分
# (.*)标识匹配出换行符之外的任意字符任意次
sed "s/\.\.\/\/src\/test\/jmeter.*\.jmx\://g" ../out/interfacelist2 > ../out/interfacelist3
echo 去头尾空格
sed 's/[[:space:]]//g' ../out/interfacelist3 > ../out/interfacelist4
echo 去掉带有？的？后面的部分
sed 's/\?.*$//g' ../out/interfacelist4 > ../out/interfacelist5
echo 去掉带协议和domain部分
sed 's/https:\/\/test\.91hiwork\.com//g' ../out/interfacelist5 > ../out/interfacelist6
echo 去掉带协议和domain部分
sed 's/https:\/\/token\.91hiwork\.com//g' ../out/interfacelist6 > ../out/interfacelist7
echo 去掉带协议和domain部分
sed 's/https:\/\/token\.91hework\.com//g' ../out/interfacelist7 > ../out/interfacelist8
sed '/^\s*$/d' ../out/interfacelist8 > ../out/interfacelist9
echo 确保每行都已/开头，并去掉uri中存在的//的情况
echo 1
# 在每一行开头添加/
sed "s/^/\//g" ../out/interfacelist9 > ../out/interfacelist10
echo 2
# 将///替换成/
sed 's/\/\/\//\//g' ../out/interfacelist10 > ../out/interfacelist11
echo 3
# 将//替换成/
sed 's/\/\//\//g' ../out/interfacelist11 > ../out/interfacelist12


echo 去重
sort ../out/interfacelist12 | uniq > ../out/interfacelist13


# 按项目处理jmeter接口中多余的部分
# echo 去掉agent项目的uri前缀"/agent/"
# sed 's/^\/agent\//\//g' ../out/interfacelist13 > ../out/interfacelist14
# echo 去掉agent项目的uri前缀"/wxapplet/"
# sed 's/^\/wxapplet\//\//g' ../out/interfacelist14 > ../out/interfacelist15
# echo 去掉agent项目的uri前缀"/yhbill/"
# sed 's/^\/yhbill\//\//g' ../out/interfacelist15 > ../out/interfacelist16
# echo 去掉agent项目的uri前缀"/wxoperatingtools/"
# sed 's/^\/wxoperatingtools\//\//g' ../out/interfacelist16 > ../out/interfacelist17
# echo 去掉agent项目的uri前缀"/vshop/"
# sed 's/^\/vshop\//\//g' ../out/interfacelist17 > ../out/interfacelist18

my_array=(
    accesscontrol
    admin
    advert
    agent
    appmanage
    base-manage
    api
    appCode
    client
    clothWeChat
    co-partner
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
    order
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
    recommend
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
)

for(( i=0;i<${#my_array[@]};i++)) do
    let interfacelistsource=i+13
    let interfacelistresult=i+14
    echo ../out/interfacelist${interfacelistsource}
    echo ../out/interfacelist${interfacelistresult}
    keystr=${my_array[$i]}
    echo ${keystr}
    echo ${my_array[$i]}
    echo 's/^\/'${keystr}'\//\//g'
    sed 's/^\/'${keystr}'\//\//g' ../out/interfacelist${interfacelistsource} > ../out/interfacelist${interfacelistresult}
done;
#######################################################################################################################

echo 开始处理yapi接口导出文件
grep "        \"path\": \"" ../yapi/api.json > ../out/yapi-interfacelist
echo 去头尾空格
sed 's/[[:space:]]//g' ../out/yapi-interfacelist > ../out/yapi-interfacelist1
echo 去重
sort ../out/yapi-interfacelist1 | uniq > ../out/yapi-interfacelist2
echo 双斜线替换成单斜线
sed 's/\/\//\//g' ../out/yapi-interfacelist2 > ../out/yapi-interfacelist3
echo 去掉无用的头部
sed 's/\"path\":\"//g' ../out/yapi-interfacelist3 > ../out/yapi-interfacelist4
echo 去掉无用的尾部
sed 's/\"\,//g' ../out/yapi-interfacelist4 > ../out/yapi-interfacelist5

#######################################################################################################################
# 开始计算覆盖率
echo 合并文件
cat ../out/interfacelist82 ../out/yapi-interfacelist5 > ../out/merge

echo 取重复项
sort ../out/merge | uniq -d > ../out/coverage-interface-list
echo 取非重复项
sort ../out/merge | uniq  > ../out/not-coverage-interface-list