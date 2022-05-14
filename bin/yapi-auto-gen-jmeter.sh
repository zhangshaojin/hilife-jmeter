#!/bin/bash

if [ ! -d "../out/auto-gen-jmeter" ]; then
    mkdir -p ../out/auto-gen-jmeter
fi

java -jar ../lib/openapi-generator-cli.jar \
    generate -i ./template/test/yapi-auto-jmeter-demo.json \
        -t ./template/jmeter-template \
        -o ../out/auto-gen-jmeter/yapi-auto-jmeter-demo -g jmeter \
        --skip-validate-spec