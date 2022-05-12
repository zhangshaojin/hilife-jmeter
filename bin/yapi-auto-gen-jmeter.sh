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


# java -jar ../lib/openapi-generator-cli.jar \
#     generate -i ../out/yapi-tmp/yapidoc-analyes-366-swaggerApi.json -o ../out/auto-gen-jmeter/yapidoc-analyes-366 -g jmeter \
#     --skip-validate-spec

# java -jar ../lib/openapi-generator-cli.jar \
#     generate -i ../out/yapi-tmp/hilife-yhbill-consumer-yapidoc.json -o ../out/auto-gen-jmeter/hilife-yhbill-consumer-yapidoc -g jmeter \
#     --skip-validate-spec

java -jar ../lib/openapi-generator-cli.jar \
    generate -i ../out/yapi-tmp/yapidoc-analyes-366-vshop-swaggerApi.json -o ../out/auto-gen-jmeter/yapidoc-analyes-366-vshop -g jmeter \
    --skip-validate-spec -t ./template/jmeter-template


# jq ../out/yapi-tmp/yapidoc-analyes-366-swaggerApi.json