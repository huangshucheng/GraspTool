--[[
模板脚本
每次新活动可以直接在这里改，改好后还原	
]]
local TaskBase 		= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 		= class("TaskTMP", TaskBase)
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local CSFun 		= require("resources.luaScript.util.CSFun")
local StringUtils 	= require("resources.luaScript.util.StringUtils")
local LuaCallCShapUI 	= require("resources.luaScript.uiLogic.LuaCallCShapUI")
local GET 			= TaskBase.GET
local POST 			= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "rrxiu.net" --域名，方便查找token, 如：hbz.qrmkt.cn
TaskTMP.IS_USE_FULL_REQDATA 	= true        -- 是否保存当前完整的请求数据,下次用当前数据去请求，此时需要在DATA_TO_FIND_ARRAY配置要查找的Url,会用ReqUrl去做对比，一致则保存
TaskTMP.IS_REPEAT_FOREVER 		= false       -- 是否永久做此任务，停不下来(切换任务对象可以停下来)
TaskTMP.IS_AUTO_DO_ACTION 		= false 	  -- 是否自动做任务,是的话会默认把UI选中
TaskTMP.DEFAULT_KABAO_COUNT 	= 10 	      -- 默认卡包次数，需要设置isKabao后才生效
TaskTMP.DEFAULT_INPUT_TEXT 	    = "480" 		  -- 输入框默认值

-- IS_USE_FULL_REQDATA == true 查找的是URL链接或链接的子串, 否则就是查找的Header里面的token或CK
TaskTMP.DATA_TO_FIND_ARRAY 		= {
	"rrxiu.net/m/wechat/GetWxJsSign"
}

-- 额外的请求头,会单独配置到请求头进去,如：{["Refer"]="www.baidu.com"}
TaskTMP.ERQ_HEADER_EXT = {
	["Content-Type"] = "application/x-www-form-urlencoded",
	["Referer"] = "https://na.rrxiu.cc",
	["Accept"]  = "application/json, text/plain, */*",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "开始游戏~", 
		url = "nres2.rrxiu.net/game/GameView/startGame",
		method = POST, 
		reqCount = 1,
		urlBody = "", 
		postBody = "",
		delay = 0,
		isKabao = false,
	},
	{
		curTaskName = "结束游戏~", 
		url = "nres2.rrxiu.net/game/GameView/saveGame",
		method = POST, 
		reqCount = 1,
		urlBody = "", 
		postBody = "",
		delay = 20,
		isKabao = false,
	},
	{
		curTaskName = "抽奖~", 
		url = "nres2.rrxiu.net/m/activity/grab",
		method = GET, 
		reqCount = 1,
		urlBody = "", 
		postBody = "",
		delay = 0,
		isKabao = true,
	},
}

--客户端抓到token后保存到本地之前,预留接口以便修改保存数据
--[[
requestInfo ={
    "Headers" = {
     	"Cookies" = "reqid=123;uid=456;",
        "token"= "12345",
    },
    "Method"  = "",
    "ReqBody" = "",
    "ReqHost" = "",
    "ReqUrl"  = "",
    "UrlBody" = "",
}
StringUtils方法:
StringUtils.splitUrlWithHost(fullUrl)
StringUtils.splitUrlParam(urlParam)
StringUtils.getUrlParam(fullUrl)
StringUtils.getUrlParamTable(fullUrl)
StringUtils.makeUpUrlByParam(urlParamTable, host)
StringUtils.changeUrlParamByTable(fullUrl, changeTable)
StringUtils.splitCookiesParam(cookiesStr)
]]
function TaskTMP:onBeforeSaveToLocal(requestInfo)
	local tmpTokenTable = clone(requestInfo)
	local retTable = {}
	local reqUrl = tmpTokenTable["ReqUrl"]
	 
	 -- IS_USE_FULL_REQDATA == true 才能用连接来判断，否则只有Header的数据
	 -- 如果抓到这个子串，可以用这条请求信息制造成目标请求信息，保存在本地，方便用来请求
	 -- 可以制造多条本地记录,添加到retTable就行了

	 --开始游戏
	if CSFun.IsSubString(reqUrl, "rrxiu.net/m/wechat/GetWxJsSign") then
		tmpTokenTable["ReqUrl"] = [[https://nres2.rrxiu.net/game/GameView/startGame?channel=1&mallGuid=299341&wsiteGuid=swvdxg]]
		tmpTokenTable["Method"] = "POST"
		tmpTokenTable["ReqBody"] = "activityGuid=141af8a246dd5af89f38722812eacbbe&fmid="
		table.insert(retTable,tmpTokenTable)
	end

	--结束游戏
	local tmpTokenTable_2 = clone(requestInfo)
	if CSFun.IsSubString(reqUrl, "rrxiu.net/m/wechat/GetWxJsSign") then
		tmpTokenTable_2["ReqUrl"] = [[https://nres2.rrxiu.net/game/GameView/saveGame?channel=1&mallGuid=299341&wsiteGuid=swvdxg]]
		tmpTokenTable_2["Method"] = "POST"
		local tmpScore = LuaCallCShapUI.GetUserInputText()
		local currentTime = 4824 .. math.random(9)
		-- tmpTokenTable_2["ReqBody"] = "activityGuid=141af8a246dd5af89f38722812eacbbe&fmid=1d2c1324d49d0e0144211b1d29cf9ca5&currentScore=370&currentTime=48249&mallGuid=299341"
		tmpTokenTable_2["ReqBody"] = "activityGuid=141af8a246dd5af89f38722812eacbbe&fmid=1d2c1324d49d0e0144211b1d29cf9ca5&currentScore=" .. tmpScore .. "&currentTime=" .. currentTime .. "&mallGuid=299341"
		table.insert(retTable,tmpTokenTable_2)
	end
	--抽奖
	local tmpTokenTable_3 = clone(requestInfo)
	if CSFun.IsSubString(reqUrl, "rrxiu.net/m/wechat/GetWxJsSign") then
		tmpTokenTable_3["ReqUrl"] = [[https://nres2.rrxiu.net/m/activity/grab?channel=1&mallGuid=299341&wsiteGuid=swvdxg&activityGuid=141af8a246dd5af89f38722812eacbbe&activityType=700]]
		tmpTokenTable_3["Method"] = "GET"
		tmpTokenTable_3["ReqBody"] = ""
		table.insert(retTable,tmpTokenTable_3)
	end
	return retTable
end

--请求服务之前,预留接口以便修改请求参数
function TaskTMP:onBeforeRequest(httpTaskObj)
	local reqUrl 	= httpTaskObj:getUrl()
	local urlBody 	= httpTaskObj:getUrlBody()
	local postBody 	= httpTaskObj:getPostBody()
	local headers 	= httpTaskObj:getHeader()
	-- local allInfo 	= httpTaskObj:getRequestInfo()
	-- dump(allInfo,"allInfo")
	if CSFun.IsSubString(reqUrl, "https://nres2.rrxiu.net/game/GameView/saveGame") then
		local paramTable = StringUtils.splitUrlParam(postBody)
		paramTable["currentScore"] = LuaCallCShapUI.GetUserInputText()
		dump(paramTable,"paramTable")
		local tmpPostBody = StringUtils.makeUpUrlByParam(paramTable)
		print("postBody: " .. tmpPostBody)
		httpTaskObj:setPostBody(tmpPostBody)
		-- local allInfo 	= httpTaskObj:getRequestInfo()
		-- dump(allInfo,"allInfo")
	end
end

return TaskTMP