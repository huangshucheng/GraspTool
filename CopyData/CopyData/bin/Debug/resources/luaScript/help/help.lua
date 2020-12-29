--帮助

--[[
c# 接口: 

1.
打印：不能使用逗号分开，Lua 的打印,c#显示不出来
LogLua("test")   --打印到控制台界面
LogOut("test") --打印到界面输出，下面,绿色

2.
GetCurDir() --获取当前exe文件位置
GetDeskTopDir() --获取桌面位置

curDir: C:\Users\95\Desktop\FD\GraspTool\CopyData\CopyData\bin\Debug
desDir: C:\Users\95\Desktop

3.
GetFidderString() --获取Fidder传过来的string

4.http请求：注意：多个为nil的参数，会报错，可以传空字符串

--请求头
local dic = {
	["Accept"] = "application/json, text/plain, */*",
	["Proxy-Connection"] = "keep-alive",
	["X-Requested-With"] = "XMLHttpRequest",
	["Accept-Encoding"] = "gzip, deflate",
	["Accept-Language"] = "keep-alive",
	["token"] = "keep-alive",
	["Content-Type"] = "application/x-www-form-urlencoded",
	-- ["Content-Length"] = "0",
	["Connection"] = "keep-alive",
	["User-Agent"] = "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13G34 MicroMessenger/7.0.9(0x17000929) NetType/WIFI Language/zh_CN",
}

异步请求
HttpRequestAsync("www.baidu.com",0, dic,"urlbody=body","postbody=body",function(ret)
	print("hcc>>ret: " .. tostring(ret))
end)

同步请求（会卡住）
local ret = HttpRequest("www.baidu.com",0, dic, "","")

]]