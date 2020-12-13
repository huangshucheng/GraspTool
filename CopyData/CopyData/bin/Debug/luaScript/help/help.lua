--帮助

--[[
c# 接口: 

1.
打印：不能使用逗号分开，Lua 的打印,c#显示不出来
LogLua("test")   --打印到控制台界面
LogToken("test")  --打印到界面输出，上面
LogOut("test") --打印到界面输出，下面,绿色

2.
getCurDir() --获取当前exe文件位置
getDeskTopDir() --获取桌面位置

curDir: C:\Users\95\Desktop\FD\GraspTool\CopyData\CopyData\bin\Debug
desDir: C:\Users\95\Desktop

3.
getFidderString() --获取Fidder传过来的string

4.http请求：注意：多个为nil的参数，会报错，可以传空字符串

异步请求
httpRequestAsync("www.baidu.com",0, dic,"hcc=fuck","postbody=body",function(ret)
	print("hcc>>ret: " .. tostring(ret))
end)

同步请求
local ret = httpRequest("www.baidu.com",0, dic, "","")

]]