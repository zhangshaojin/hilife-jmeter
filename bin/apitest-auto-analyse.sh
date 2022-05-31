#!/bin/bash

# 该脚本用于从jenkins拉取apitest报告并且分析生成汇总报告

# 拉取测试报告 begin
# if [ -d "../out/apitest" ]; then
#     rm -rf ../out/apitest
# fi

if [ ! -d "../out/apitest" ]; then
    mkdir -p ../out/apitest
fi

rsync  -v -r --include-from=./conf/pull-apitest-include-from.txt root@10.1.1.136:/data01/jenkins/workspace/jobs/ ../out/apitest/
# 拉取测试报告 finish

# 生成测试分析报告 begin
if [ ! -d "../out/apitest/analyse-result" ]; then
    mkdir -p ../out/apitest/analyse-result
fi

find ../out/apitest | grep "\.html$" | xargs python ./script-apitest-auto-analyse/report-analyse.py > ../out/apitest/analyse-result/report.log

cat ../out/apitest/analyse-result/report.log | sed "s/..\/out\/apitest\///g" | sed "s/\/builds\//,/g" | sed "s/\/archive\/target\/jmeter\/html_report\//,/g" > ../out/apitest/analyse-result/report-sed.log
# 生成测试分析报告 finish