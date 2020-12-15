local CSFun = {}
local Define = require("luaScript.config.Define")

function CSFun.LogToken(data)
	if LogToken then
		LogToken(tostring(data))
	end
end

function CSFun.LogOut(data)
	if LogOut then
		LogOut(tostring(data))
	end
end

function CSFun.LogLua(data)
	if LogLua then
		LogLua(tostring(data))
	end
end

function CSFun.GetFidderString()
	if GetFidderString then
		return GetFidderString()
	end
end

--time 秒
function CSFun.SetDelayTime(time ,func)
	if SetTimeOut then
		SetTimeOut(time, func)
	end
end

function CSFun.GetCurDir()
	if GetCurDir then
		return GetCurDir()
	end
end

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
//cookies: "a=avlue;c=cvalue"
//taskEndAction: lua function
]]
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
		LogOut("error url is empty")
		return
	 end

	if HttpRequestAsync then
		HttpRequestAsync(url, method, header, urlBody, postBody, cookies , callFunc)
	end
end

--用backGroundWork(工作线程)的形式请求http（会卡住）
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
		LogOut("error url is empty")
		return
	 end

	if not HttpRequest then 
		return
	end

	return HttpRequest(url, method, header, urlBody, postBody, cookies)
end

return CSFun