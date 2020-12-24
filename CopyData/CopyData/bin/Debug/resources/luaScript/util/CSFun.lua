local CSFun = class("CSFun")
local Define = require("resources.luaScript.config.Define")

-- 打印堆栈
function CSFun.GetTrace()
	return debug.traceback()
end

--打印到taken界面
function CSFun.LogToken(data)
	if LogToken then
		LogToken(tostring(data))
	end
end

--打印到输出界面
function CSFun.LogOut(data)
	if LogOut then
		LogOut(tostring(data))
	end
end

--打印到命令行
function CSFun.LogLua(data)
	if LogLua then
		LogLua(tostring(data))
	end
end

--获取fidder传过来的字符串
function CSFun.GetFidderString()
	if GetFidderString then
		return GetFidderString()
	end
end

--设置延时，time 秒
function CSFun.SetDelayTime(time ,func)
	if SetTimeOut then
		SetTimeOut(time, func)
	end
end

--获取当前exe所在目录
function CSFun.GetCurDir()
	if GetCurDir then
		return GetCurDir()
	end
end

--获取桌面目录
function CSFun.GetDeskTopDir()
	if GetDeskTopDir then
		return GetDeskTopDir()
	end
end

--[[
//url: "www.baidu.com"
//method: Method {GET,POST,PUT,DELETE}: 0 ,1 ,2 ,3
//headTable:{AAA = "" , bbb = "" }
//urlBody: "aaa=1&bbb=123"
//postBody: "anything"
//cookies: "cookie1=avlue;cookies2=cvalue"  需要用分号隔开
//taskEndAction: lua function
]]
--异步请求http
function CSFun.httpReqAsync(url, method, header, urlBody, postBody, cookies, callFunc)
	method = method or Define.Method.GET
	header = header or {}
	urlBody = urlBody or ""
	postBody = postBody or ""
	cookies = cookies or ""
	callFunc = callFunc or function(ret) end
	if type(header) ~= "table" then
		header = {}
	end

	if not url or url == "" then 
		LogOut("error url is empty>> " .. debug.traceback())
		return
	 end

	if HttpRequestAsync then
		HttpRequestAsync(url, method, header, urlBody, postBody, cookies , callFunc)
	end
end

--同步请求http（会卡住）
function CSFun.HttpReq(url, method, header, urlBody, postBody, cookies)
	method = method or Define.Method.GET
	header = header or {}
	urlBody = urlBody or ""
	postBody = postBody or ""
	cookies = cookies or ""
	if type(header) ~= "table" then
		header = {}
	end

	if not url or url == "" then 
		LogOut("error url is empty>> " .. debug.traceback())
		return
	 end

	if not HttpRequest then 
		return
	end

	return HttpRequest(url, method, header, urlBody, postBody, cookies)
end

--文件是否存在
function CSFun.IsFileExist(fileName)
	if IsFileExist then
		return IsFileExist(fileName)
	end
end

--写入字符串到文件，文件不存在会创建
function CSFun.WriteFile(fileName, dataStr)
	if WriteFile then
		return WriteFile(fileName, dataStr)
	end
end

--读取文件内容
function CSFun.ReadFile(fileName)
	if ReadFile then
		return ReadFile(fileName)
	end
end

--继续写入字符串
function CSFun.AppendText(fileName, dataStr)
	if AppendText then
		return AppendText(fileName, dataStr)
	end
end

--继续写入一行
function CSFun.AppendLine(fileName, dataStr)
	if AppendLine then
		return AppendLine(fileName, dataStr)
	end
end

--创建文件
function CSFun.CreateFile(fileName)
	if CreateFile then
		return CreateFile(fileName)
	end
end

--播放wav音效
function CSFun.PlayWAVSound(filePath)
	if PlayWAVSound then
		PlayWAVSound(filePath)
	end
end

--字符串比较
function CSFun.StringCompare(srcStr, desStr)
	if StringCompare then
		return StringCompare(srcStr, desStr)
	end
end

function CSFun.Utf8ToDefault(str)
	if Utf8ToDefault then
		return Utf8ToDefault(str)
	end
end

function CSFun.DefaultToUtf8(str)
	if DefaultToUtf8 then
		return DefaultToUtf8(str)
	end
end

return CSFun