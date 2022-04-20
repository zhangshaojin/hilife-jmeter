import requests
import re
import json
import csv

# 读取jmx文件
jmx_path = 'C:/Users/77932/Desktop/接口/hilife-customerservice.jmx'  # jmx文件路径
jmx_text = ""   # 存取jmx文件内容
with open(jmx_path, mode="rb") as f1:
    jmx_text = f1.read().decode("UTF-8")
    f1.close()
    # 用于检测提取的信息中是否含有参数，以？为标准
def takeString(str):
    for i in str:
        if i=='?':
            return str[0:str.rfind('?',1)]
    return str

# 提取器，用于提取jmx文件中指定的path
obj1 = re.compile(r'<stringProp name="HTTPSampler.path">/customerservice(?P<path>.*?)</stringProp>', re.S)
jmx_path_list = obj1.finditer(jmx_text)
jmx_list = []   # 存储调用了的接口名称的列表
for i in jmx_path_list:
    print(takeString(i.group("path")))
    jmx_list.append(takeString(i.group("path")))
print("该jmx文件中共调用了customerservice的path", len(jmx_list), "次（可能重复调用）")

# 获取Yapi中的接口列表
# url = "https://yapi.91hiwork.com"
# path = "/api/interface/list_cat"
# query = {
#     "token": "163064c559069baa94533eb11d90a6a5a90376f3f209e145d54c21bee98024e5",
#     "catid": "customerservice"
# }
# json_list = []
# res = requests.get(url=url + path, params=query)
# # print(res.text)
# json_list = res.json()['list']
# res.close()

# 读取json文件
json_path = "C:/Users/77932/Desktop/接口/api.json"
json_text = {}
with open(json_path, mode="rb") as f2:
    json_text = json.load(f2)
    f2.close()

# 提取json文件中的内容
json_count = 0
json_customerservice = 0
name = "hilife-customerservice-consumer"
while json_count < len(json_text):
    if json_text[json_count]['name'] == name:
        json_customerservice = json_count  # 其中要找的类为第几个
        break
    json_count = json_count+1
print("其中promotion类为第", json_customerservice+1, "个")

# 获取到接口数据列表
json_list = json_text[json_customerservice]['list']

# 只取接口的名字
path_list = []  # 存储customerservice类中接口名称的列表
for j in json_list:
    path_list.append(j['path'])
print("customerservice类中共有接口", len(path_list), "个")

csv_path = "C:/Users/77932/Desktop/接口/result.csv"
with open(csv_path, mode="w", newline="") as f3:
    csv_writer = csv.writer(f3)
    csv_writer.writerow(['Yapi的接口名称', 'jemter的接口名称', '是否覆盖'])
    csv_w = 0
    yes_count = 0
    compare_count = 0
    # print(jmx_list)
    while compare_count < len(path_list):
        str = path_list[compare_count]
        j = 0
        while j < len(jmx_list):
            if str == jmx_list[j]:
                csv_w = 1
            # print(str, "对比", jmx_list[j], "是", str == jmx_list[j], "，判断值为", csv_w)
            j = j+1
        if csv_w == 1:
            csv_writer.writerow([str, str, 1])
            print(str, " 1")
            yes_count = yes_count+1
        if csv_w == 0:
            print(str, " 0")
            csv_writer.writerow([str, 0, 0])
        csv_w = 0
        compare_count = compare_count+1
    Coverage = yes_count/len(path_list)
    print("Yapi中customerservice类中共有接口", len(path_list), "个，jmeter中调用了其中的", yes_count, "个接口")
    print("总覆盖率为", Coverage)
    csv_writer.writerow(["总覆盖率", Coverage])
    f3.close()
print("over!")
