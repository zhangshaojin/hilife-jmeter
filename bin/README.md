Jmeter接口覆盖率统计过程中发现的问题
Jmeter项目中存在的问题
1.文件名以及路径名不规范，有些文件名中带空格导致shell脚本处理有问题，有些目录名中带有jmx后缀也导致shell脚本误判处理出错
```
    /Users/lihz/workspace/workspace_test/hilife-jmeter/src/test/jmeter/script/transactionmanage/hilife-Template/apiTest_ template.jmx
    /Users/lihz/workspace/workspace_test/hilife-jmeter/src/test/jmeter/script/hilife-clothingsuppl.jmx/hilife-clothingsuppl.jmx
```
Yapi中存在的问题
项目代码中存在的问题
1.有些接口给代码中写的不规范例如"/CommonPermissionisPermission"在vshop代码如下
```
@RequestMapping("CommonPermission") 
public class CommonPermissionController {
    ...
    @PostMapping("isPermission")
    @ResponseBody
    public Map isPermission(Integer roleCode) {  
    ...
```
导入到yapi是接口变成了"/CommonPermissionisPermission"，而Jmeter中是"/CommonPermission/isPermission"
解决思路：修改导入Yapi的插件，解决注解不规范的问题，后续代码规范里面添加响应的规范
2.