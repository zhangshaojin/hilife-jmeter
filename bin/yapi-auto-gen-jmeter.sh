#!/bin/bash

if [ ! -d "../out/auto-gen-jmeter" ]; then
    mkdir -p ../out/auto-gen-jmeter
fi


# java -jar ../lib/openapi-generator-cli.jar \
#     generate -i ../out/yapi-tmp/hilife-vshop-44-swaggerapi.json -o ../out/auto-gen-jmeter/hilife-vshop-44 -g mysql-schema \
#     --skip-validate-spec

# java -jar ../lib/openapi-generator-cli.jar \
#     generate -i ../out/yapi-tmp/hilife-vshop-44-swaggerapi.json -o ../out/auto-gen-jmeter/hilife-vshop-44/objc -g objc \
#     --skip-validate-spec


java -jar ../lib/openapi-generator-cli.jar \
    generate -i ../out/yapi-tmp/hilife-vshop-44-swaggerapi.json -o ../out/auto-gen-jmeter/hilife-vshop-44 -g jmeter \
    --skip-validate-spec
