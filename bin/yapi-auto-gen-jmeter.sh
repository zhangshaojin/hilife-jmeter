#!/bin/bash

# 该脚本用于从yapidoc生成jmeter测试脚本

if [ -d "../out/auto-gen-jmeter" ]; then
    rm -rf ../out/auto-gen-jmeter
fi

if [ ! -d "../out/auto-gen-jmeter" ]; then
    mkdir -p ../out/auto-gen-jmeter
fi

# API定义文件./template/test/demo-yapidoc-1.json；./template/test/demo-yapidoc-2.json
#   API定义文件暂定使用yapidoc-maven-plugin导入yapi server时生成的定义文件
#   注：不使用yapi server导出的Swagger文件的主要原因是yapi server导出的文件缺失components部分
# 生成Jmeter脚本的模板./template/jmeter-template
#   该模板中根据合生活现有接口情况做了一些定制
# 输出目录../out/auto-gen-jmeter/yapi-auto-jmeter-demo
java -jar ../lib/openapi-generator-cli.jar \
    generate -i ./template/test/demo-yapidoc-1.json \
        -t ./template/jmeter-template \
        -o ../out/auto-gen-jmeter/demo-yapidoc-1 -g jmeter \
        --skip-validate-spec
        
java -jar ../lib/openapi-generator-cli.jar \
    generate -i ./template/test/demo-yapidoc-2.json \
        -t ./template/jmeter-template \
        -o ../out/auto-gen-jmeter/demo-yapidoc-2 -g jmeter \
        --skip-validate-spec