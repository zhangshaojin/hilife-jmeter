#!/usr/bin/env python
# -*- coding:utf-8 -*-

#
# python ./script-apitest-auto-analyse/report-analyse.py ../out/apitest/hilife-activity-ApiTest/builds/61/archive/target/jmeter/html_report/ApiTest_activity-20210225-0208.html
#

import csv,os,sys
import re
from matplotlib.pyplot import switch_backend, table
import requests
import json
import json,time
from bs4 import BeautifulSoup
reload(sys)
sys.setdefaultencoding('utf-8')

          
def get_ApitestCount(HtmlReport):
    with open(HtmlReport, 'r') as strf:
        str = strf.read()    
    html = BeautifulSoup(str, "html.parser")
    tables = html.findAll("table")
    header = []
    data_list = []
    for index, table in enumerate(tables):
        if(index == 1):
            for idx, tr in enumerate(table.find_all('tr')):
                if idx == 0:
                    ths = tr.find_all('th')
                    for th in ths:
                        header.append(th.string)
                elif idx == 1:
                    tds = tr.find_all('td')
                    for tb in tds:
                        data_list.append(tb.string)
        if(index > 1):
            break
    return header,data_list

if __name__ == '__main__':
    print("文件路径,请求数量,成功,失败,成功率,平均响应时间,最短时间,最长时间,RT(≤0.5s),(0.5~1s),RT(>1s),90% Line,QPS")

    switch = {
        "请求数量" : 0,
        "# Samples" : 0,
        "成功" : 1,
        "Success" : 1,
        "失败" : 2,
        "Failures" : 2,
        "成功率" : 3,
        "Success Rate" : 3,
        "平均响应时间" : 4,
        "Average Time" : 4,
        "最短时间" : 5,
        "Min Time" : 5,
        "最长时间" : 6,
        "Max Time" : 6,
        "RT(≤0.5s)" : 7,
        "(0.5~1s)" : 8,
        "RT(>1s)" : 9,
        "90% Line" : 10,
        "QPS" : 11
    }
    print(switch)
    IFS = ","
    for htmlReportPath in sys.argv[1:]:
        if(os.path.exists(htmlReportPath)):
            header,data_list = get_ApitestCount(htmlReportPath)
            if(len(header) != len(data_list)):
                print(htmlReportPath + "," + "错误")
            else:
                values = ["","","","","","","","","","","",""]
                for idx, head in enumerate(header):
                    # if("# Samples" == header[idx]):
                    #     header[idx] = "请求数量"
                    # if("Success" == header[idx]):
                    #     header[idx] = "成功"
                    # if("Failures" == header[idx]):
                    #     header[idx] = "失败"
                    # if("Success Rate" == header[idx]):
                    #     header[idx] = "成功率"
                    # if("Average Time" == header[idx]):
                    #     header[idx] = "平均响应时间"
                    # if("Min Time" == header[idx]):
                    #     header[idx] = "最短时间"
                    # if("Max Time" == header[idx]):
                    #     header[idx] = "最长时间"

                    if("请求数量" == header[idx]):
                        index = 0
                    elif("# Samples" == header[idx]):
                        index = 0
                    elif("成功" == header[idx]):
                        index = 1
                    elif("Success" == header[idx]):
                        index = 1
                    elif("失败" == header[idx]):
                        index = 2
                    elif("Failures" == header[idx]):
                        index = 2
                    elif("成功率" == header[idx]):
                        index = 3
                    elif("Success Rate" == header[idx]):
                        index = 3
                    elif("平均响应时间" == header[idx]):
                        index = 4
                    elif("Average Time" == header[idx]):
                        index = 4
                    elif("最短时间" == header[idx]):
                        index = 5
                    elif("Min Time" == header[idx]):
                        index = 5
                    elif("最长时间" == header[idx]):
                        index = 6
                    elif("Max Time" == header[idx]):
                        index = 6
                    elif("RT(≤0.5s)" == header[idx]):
                        index = 7
                    elif("RT(≤0.5s) " == header[idx]):
                        index = 7
                    elif("(0.5~1s)" == header[idx]):
                        index = 8
                    elif("RT(0.5~1s)" == header[idx]):
                        index = 8
                    elif("RT(>1s)" == header[idx]):
                        index = 9
                    elif("90% Line" == header[idx]):
                        index = 10
                    elif("QPS" == header[idx]):
                        index = 11
                    else:
                        index = -1
                    
                    if(index != -1):
                        values[index] = data_list[idx]
                    else:
                        print(header[idx])
                value = IFS.join(values)
                print(htmlReportPath + "," + value)