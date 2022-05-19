#!/bin/bash

# 该脚本用于从jenkins拉取apitest报告并且分析生成汇总报告

if [ -d "../out/apitest" ]; then
    rm -rf ../out/apitest
fi

if [ ! -d "../out/apitest" ]; then
    mkdir -p ../out/apitest
fi

rsync  -v -r --include-from=./conf/pull-apitest-include-from.txt root@10.1.1.136:/data01/jenkins/workspace/jobs/ ../out/apitest/