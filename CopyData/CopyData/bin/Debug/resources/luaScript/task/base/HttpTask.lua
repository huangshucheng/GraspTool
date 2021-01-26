--[[一个http任务对象]]
local HttpTask 		= class("HttpTask")
local Define 		= require("resources.luaScript.config.Define")
local CSFun 		= require("resources.luaScript.util.CSFun")
local TaskData 		= require("resources.luaScript.data.TaskData")
local UIConfigData  = require("resources.luaScript.data.UIConfigData")
local LuaCallCShapUI = require("resources.luaScript.uiLogic.LuaCallCShapUI")

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
	self._header 		= clone(Define.HTTP_HEADER_TABLE) --默认请求头
	self._delayTime  	= 0   -- 延迟时间
	self._responseData  = ""  -- 返回数据
	self._curHttpTaskIndex = 1      -- 当前任务下标
	self._respCallback  = nil       -- 回调
	self._proxyAddress 	= Define.DEFAULT_PROXY --代理如: "http://127.0.0.1:8888",如果不加http://前缀，会默认给你加http://
	self._state 		= HttpTask.GRASP_STATE.NONE --未开始
	self._isContinue    = true 	--执行完成后是否执行下一个CK
	self._graspRedPktCount   = 0 	--抢到的红包个数
	self._isKaBao 		= false  --当前请求是否需要手动设置卡包次数
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
	self._header 		= config.header or clone(Define.HTTP_HEADER_TABLE)
	self._delayTime 	= config.delay or 0
	self._proxyAddress  = config.proxyAddress or Define.DEFAULT_PROXY
	self._isKaBao 		= config.isKabao or false
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


--用JSON table 的格式设置postBody，最后转换成string
function HttpTask:addPostBodyForJsonTable(bodyTable)
	if not bodyTable or not next(bodyTable) then
	 	return self 
	end

	local curTask = TaskData.getCurTask()
	if curTask then
		if not curTask:isWriteTokenToPostBody() then --是否使用Json格式将token写到 reqBody
			return self
		end
	end
	
	local ok = nil
	local json_table_self = {}
	if self._postBody and self._postBody ~= "" then
		ok, json_table_self = pcall(function()
			return json.decode(self._postBody)
		end)
	end
	
	if ok then
		table.merge(json_table_self, bodyTable)
	end
	--dump(json_table_self,"hcc>>json_table_self")

	pcall(function()
		self._postBody = json.encode(json_table_self)
	end)

	return self
end

--设置postBody文本
function HttpTask:setPostBody(bodyString)
	self._postBody = bodyString
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
--如果脚本指定了使用postBody做凭证，token就放到postBody进去
function HttpTask:addHeader(headerTable)
	if not headerTable or not next(headerTable) then
	 	return self
  	end

	local curTask = TaskData.getCurTask()
	if curTask then
		if curTask:isWriteTokenToPostBody() then --是否使用Json格式将token写到 reqBody, 如果是，就不写到Header了
			return self
		end
	end

	table.merge(self._header, headerTable)
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

function HttpTask:getState()
	return self._state
end

function HttpTask:setState(state)
	self._state = state
	local TaskData 		= require("resources.luaScript.data.TaskData")
	local curTask = TaskData.getCurTask()
	if curTask then
		curTask:onTaskStateChanged(self)
	end
end

function HttpTask:setIsContinue(isContinue)
	self._isContinue = isContinue
	return self
end

function HttpTask:getIsContinue()
	return self._isContinue
end

--获取此条CK已经抓到的红包个数
function HttpTask:getGraspRedPktCount()
	return self._graspRedPktCount
end
--设置此条CK已经抓到的红包个数
function HttpTask:setGraspRedPktCount(count)
	self._graspRedPktCount = count
	return self
end

--是否卡包
function HttpTask:getIsKaBao()
	return self._isKaBao
end

-- 异步执行http请求
function HttpTask:start()
	-- 以配置为准，否则用 界面上的配置
	local delayTime = tonumber(UIConfigData.getReqDelayTime()) --延迟时间
	local proxyConfig = UIConfigData.getProxyIpConfig()
	if proxyConfig and #proxyConfig > 0 then
		math.randomseed(os.time())
		local proxyCount = #proxyConfig
	 	local ranNum = math.random(proxyCount) --从1 到总数，随机选一个proxy
		self._proxyAddress = proxyConfig[ranNum]
	end

	if delayTime and delayTime > 0 then
		self._delayTime = delayTime
	end

	if self._isKaBao then
		self._reqCount = LuaCallCShapUI.GetKaBaoCount() or 1
		print("kaBaoCount: " .. tostring(self._reqCount))
	end

	self:setState(HttpTask.GRASP_STATE.DOING)
	for index = 1 , self._reqCount do
		local reqFunc = function()
			CSFun.httpReqAsync(
			self._url,
			function(ret)
				self._curCount = self._curCount + 1
				self._responseData = ret
				if self._respCallback then
					self._respCallback(ret, self)
				end
			end,
			self._method, 
			self._header, 
			self._urlBody, 
			self._postBody, 
			self._cookies, 
			self._proxyAddress)
		end
		local delay = tonumber(self._delayTime)
		if delay and delay > 0 then
			if delay >= 3 then
				print(CSFun.Utf8ToDefault("正在等待中~,  " .. delay .. '秒后继续...'))
			end
			CSFun.SetDelayTime(delay, reqFunc)
		else
			reqFunc()
		end
	end
end

return HttpTask