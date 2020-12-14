local HttpTask = class("HttpTask")
local Define = require("luaScript.config.Define")
local HttpUtils = require("luaScript.util.HttpUtils")

function HttpTask:ctor()
	self._url 			= ""  -- 请求URL
	self._urlBody 		= ""  -- 放在URL后面的请求体,get,post都能用, 例：shareCode=123&code=abc
	self._postBody 		= ""  -- post请求的参数，只有post能用到
	self._curTaskName 	= ""  -- 当前任务名字
	self._preTaskName 	= ""  -- 前置任务名字：如果有前置任务名字，则需要等到前置任务做好后才去调用此任务
	self._userData 		= ""  -- 用户自定义数据
	self._cookies 		= ""  -- cookies : token=tokenqqqq; sscookie=bbbbb; cccookie=ccccc; cccc=456789
	self._reqCount 		= 1   -- 请求次数
	self._method 		= Define.Method.GET -- 请求方法
	self._header 		= Define.HTTP_HEADER_TABLE --默认请求头
end

function HttpTask:setUrl(url)
	if not url then return self end
	self._url = url
	return self
end

function HttpTask:getUrl()
	return self._url
end

function HttpTask:setUrlBody(body)
	if not body then return self end
	self._urlBody = body
	return self
end

function HttpTask:getUrlBody()
	return self._urlBody
end

function HttpTask:setPostBody(body)
	if not body then return self end
	self._postBody = body
	return self
end

function HttpTask:getPostBody()
	return self._postBody
end

function HttpTask:setTaskName(name)
	if not name then return self end
	self._curTaskName = name
	return self
end

function HttpTask:getTaskName()
	return self._curTaskName
end

function HttpTask:setPreTaskName(name)
	if not name then return self end
	self._preTaskName = name
	return self
end

function HttpTask:getPreTaskName()
	return self._preTaskName
end

function HttpTask:setReqCount(count)
	if not count then return self end
	self._reqCount = count
	return self
end

function HttpTask:getReqCount()
	return self._reqCount
end

function HttpTask:setMethod(method)
	if not method then return self end
	self._method = method
	return self
end

function HttpTask:getMethod()
	return self._method
end

function HttpTask:getHeader()
	return self._header
end

function HttpTask:addHeader(headerTable)
	if not headerTable or not next(headerTable) then return self end
	if headerTable and next(headerTable) then
		table.merge(self._header, headerTable)
	end
	return self
end

function HttpTask:getCookies()
	return self._cookies
end

function HttpTask:setCookies(cookiesString)
	if not cookiesString then return self end
	self._cookies = cookiesString
	return self
end

function HttpTask:setUserData(data)
	self._userData = data or ""
	return self
end

function HttpTask:getUserData()
	return self._userData
end

-- 异步执行http请求
function HttpTask:start(callfunc)
	for index = 1 , self._reqCount do
		HttpUtils.httpReqAsync(self._url, self._method, self._header, self._urlBody, self._postBody, self._cookies ,function(ret)
			if callfunc then
				callfunc(ret, self)
			end
		end)
	end
end

--工作线程执行http请求
function HttpTask:startWork(callfunc)
	for index = 1 , self._reqCount do
	 	HttpUtils.httpReqWork(self._url, self._method, self._header, self._urlBody, self._postBody, self._cookies, function()
		 	if callfunc then
		 		callfunc(ret, self)
		 	end
	 	end)
	end
end

return HttpTask