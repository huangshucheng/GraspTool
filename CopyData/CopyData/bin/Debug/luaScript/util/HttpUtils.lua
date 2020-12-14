
local HttpUtils = class("HttpUtils")
local Define = require("luaScript.config.Define")

--[[
//url: "www.baidu.com"
//method: Method {GET,POST,PUT,DELETE}: 0 ,1 ,2 ,3
//headTable:{AAA = "" , bbb = "" }
//urlBody: "aaa=1&bbb=123"
//postBody: "anything"
//cookies: "a=avlue;c=cvalue"
//taskEndAction: lua function
]]
function HttpUtils.httpReqAsync(url, method, header, urlBody, postBody, cookies, callFunc)
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

	if not httpRequestAsync then 
		return
	end

	httpRequestAsync(url, method, header, urlBody, postBody, cookies , callFunc)
end

function HttpUtils.httpReq(url, method, header, urlBody, postBody, cookies)
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

	if not httpRequest then 
		return
	end

	return httpRequest(url, method, header, urlBody, postBody, cookies)
end

return HttpUtils