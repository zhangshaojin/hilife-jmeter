# 项目目标
    该项目主要用于统计Jmeter接口测试覆盖率，通过与yapi汇聚起来各项目的接口进行比对，最终统计出当前Jmeter自动化接口测试覆盖的接口清单以及接口数，同时将未覆盖到的接口清单也列出来为后续提高自动化接口测试覆盖率做准备。
# 目录说明
> ./bin
> 为脚本存放路径，也是脚本运行的根路径
> ./out
> 存放输出结果，运行完成后目录树类似如下
```

```
# 准备工作
> #### 安装jq用于完成json文件格式化
> ```
> yum install jq
> ```
> ### 无法安装jq的情况，需要添加EPEL源
> ```
> yum install epel-release 
> ```
> ## 安装wget
> ```
> yum install wget
> ```
# 使用方式
> ```
> # 从代码仓库中拉去代码之后进入代码路径，以下说明中相对路径均以代码根目录为基准
> cd ./bin
> ./jmeter-coverage-analyse.sh
> ```
# 结果
> ./out目录下为分析后的结果
> 目录    all     中放的是Jmeter全部接口和Yapi全部接口一起分析的结果
> 目录    **.jmx  中放的是对应的jmx文件中抓取的接口和Yapi全部接口分析的结果
> 文件    converage-result.csv    报表
> 文件    yapi-interfacelist      Yapi全部接口清单

使用说明：



# Jmeter接口覆盖率统计过程中发现的问题
## Jmeter项目中存在的问题
> 1.文件名以及路径名不规范，有些文件名中带空格导致shell脚本处理有问题，有些目录名中带有jmx后缀也导致shell脚本误判处理出错
> ```
>     /Users/lihz/workspace/workspace_test/hilife-jmeter/src/test/jmeter/script/transactionmanage/hilife-Template/apiTest_ template.jmx
>     /Users/lihz/workspace/workspace_test/hilife-jmeter/src/test/jmeter/script/hilife-clothingsuppl.jmx/hilife-clothingsuppl.jmx
> ```
## Yapi中存在的问题
> 
## 项目代码中存在的问题
> ### 1.有些接口给代码中写的不规范例如"/CommonPermissionisPermission"在vshop代码如下
> ```
> @RequestMapping("CommonPermission") 
> public class CommonPermissionController {
>     ...
>     @PostMapping("isPermission")
>     @ResponseBody
>     public Map isPermission(Integer roleCode) {  
>     ...
> ```
> 导入到yapi是接口变成了"/CommonPermissionisPermission"，而Jmeter中是"/CommonPermission/isPermission"
> 解决思路：修改导入Yapi的插件，解决注解不规范的问题，后续代码规范里面添加响应的规范
> 状态：已解决
> ### 2.导入插件对@RequestMapping({"/demo","/example"})语法的支撑有问题，导致生成的接口会变成[/demo,/example]/...，在Yapi导入中会被遗弃掉，导致部分接口无法导入到yapi中
> 解决思路：修改导入Yapi插件
> 状态：解决了一部分，@RequestMapping({"/demo"})类的已经解决，但是@RequestMapping({"/demo","/example"})导入时还是导入不进去，需要再次优化