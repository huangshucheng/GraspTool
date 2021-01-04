--[[一个http任务对象]]

local HttpTask = class("HttpTask")
local Define = require("resources.luaScript.config.Define")
local CSFun = require("resources.luaScript.util.CSFun")
local TaskData = require("resources.luaScript.data.TaskData")

--抓包状态, 未开始0, 进行中1，已完成2
HttpTask.GRASP_STATE = {NONE = 1, DOING = 2, FINISH = 3}

function HttpTask:ctor()
	self._url 			= ""  -- 请求URL
	self._urlBody 		= ""  -- 放在URL后面的请求体,get,post都能用, 例：shareCode=123&code=abc
	self._postBody 		= ""  -- post请求的参数，只有post能用到
	self._curTaskName 	= ""  -- 当前任务名字
	self._preTaskName 	= ""  -- 前置任务名字：如果有前置任务名字，则需要等到前置任务做好后才去调用此任务
	self._userData 		= ""  -- 用户自定义数据
	self._cookies 		= ""  -- cookies : token=tokenqqqq; sscookie=bbbbb; cccookie=ccccc; cccc=456789
	self._reqCount 		= 1   -- 请求次数
	self._curCount 		= 0   -- 当前请求次数
	self._method 		= Define.Method.GET -- 请求方法
	self._header 		= Define.HTTP_HEADER_TABLE --默认请求头
	self._delayTime  	= 0   -- 延迟时间
	self._responseData  = ""  -- 返回数据
	self._curHttpTaskIndex = 1      -- 当前任务下标
	self._respCallback  = nil       -- 回调
	self._isRedPacket 	= false     -- 是否需要卡包，如果是的话，会优先使用界面上配置的卡包请求次数，否则用配置的请求次数
	self._proxyAddress 	= Define.DEFAULT_PROXY --代理如："false", "true", "http://127.0.0.1:8888"，一定要加http:// 或者https://
	self._state 		= HttpTask.GRASP_STATE.NONE --未开始
end

function HttpTask:initWithConfig(config)
	config = config or {}
	self._url 			= config.url or ""  
	self._urlBody 		= config.urlBody or ""
	self._postBody 		= config.postBody or ""
	self._curTaskName 	= config.curTaskName or ""
	self._preTaskName 	= config.preTaskName or ""  
	self._userData 		= config.userData or ""
	self._cookies 		= config.cookies or ""
	self._reqCount 		= config.reqCount or 1
	self._curCount 		= config.curCount or 0
	self._method 		= config.method or Define.Method.GET
	self._header 		= config.header or Define.HTTP_HEADER_TABLE
	self._delayTime 	= config.delay or 0
	self._isRedPacket   = config.isRedPacket or false
	self._proxyAddress  = config.proxyAddress or Define.DEFAULT_PROXY
end

function HttpTask:setUrl(url)
	if not url then return self end
	self._url = url
	return self
end

function HttpTask:getUrl()
	return self._url
end

function HttpTask:setProxy(proxyAddress)
	self._proxyAddress = proxyAddress
	return self
end

function HttpTask:getProxy()
	return self._proxyAddress
end

function HttpTask:addCallback(callback)
	self._respCallback  = callback
	return self
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

function HttpTask:setCurCount(count)
	self._reqCount = count
end

function HttpTask:getCurCount()
	return self._curCount
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
--添加请求头，Cookie也在里面的话，自动处理Cookie
function HttpTask:addHeader(headerTable)
	if not headerTable then return self end
	if headerTable then
		table.merge(self._header, headerTable)
	end
	if headerTable[Define.COOKIE_NAME] then
		self:setCookies(headerTable[Define.COOKIE_NAME])
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

--time second
function HttpTask:setDelay(time)
	self._delayTime = time
	return self
end

function HttpTask:getDelay()
	return self._delayTime
end

function HttpTask:getResPonseData()
	return self._responseData
end

function HttpTask:setCurTaskIndex(index)
	self._curHttpTaskIndex = index
end

function HttpTask:getCurTaskIndex()
	return self._curHttpTaskIndex
end

function HttpTask:setIsRedPacket(isRedPkt)
	self._isRedPacket = isRedPkt
	return self
end

function HttpTask:getIsRedPacket()
	return self._isRedPacket
end

function HttpTask:getState()
	return self._state
end

function HttpTask:setState(state)
	self._state = state
	local curTask = TaskData.getCurTask()
	if curTask then
		curTask:onTaskStateChanged(self)
	end
end

-- 异步执行http请求
function HttpTask:start()
	-- print("start .. count>> " .. self._reqCount  .. "  ,url>>" .. self._url)
	self:setState(HttpTask.GRASP_STATE.DOING)
	for index = 1 , self._reqCount do
		local reqFunc = function()
			CSFun.httpReqAsync(self._url, self._method, self._header, self._urlBody, self._postBody, self._cookies, self._proxyAddress, function(ret)
				self._curCount = self._curCount + 1
				self._responseData = ret
				if self._respCallback then
					self._respCallback(ret, self)
				end
			end)
		end
		local delay = tonumber(self._delayTime)
		if delay and delay > 0 then
			CSFun.SetDelayTime(delay, reqFunc)
		else
			reqFunc()
		end
	end
end

return HttpTask