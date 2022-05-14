#!/bin/bash

if [ ! -d "../out/auto-gen-jmeter" ]; then
    mkdir -p ../out/auto-gen-jmeter
fi

# API定义文件./template/test/yapi-auto-jmeter-demo.json
# 生成Jmeter脚本的模板./template/jmeter-template
# 输出目录../out/auto-gen-jmeter/yapi-auto-jmeter-demo
java -jar ../lib/openapi-generator-cli.jar \
    generate -i ./template/test/yapi-auto-jmeter-demo.json \
        -t ./template/jmeter-template \
        -o ../out/auto-gen-jmeter/yapi-auto-jmeter-demo -g jmeter \
        --skip-validate-spec