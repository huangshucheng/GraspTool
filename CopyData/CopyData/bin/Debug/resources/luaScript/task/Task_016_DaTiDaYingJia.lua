--[[
模板脚本
每次新活动可以直接在这里改，改好后还原	
]]
local TaskBase 		= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 		= class("TaskTMP", TaskBase)
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local CSFun 		= require("resources.luaScript.util.CSFun")
local StringUtils 	= require("resources.luaScript.util.StringUtils")
local LuaCallCShapUI = require("resources.luaScript.uiLogic.LuaCallCShapUI")
local GET 			= TaskBase.GET
local POST 			= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "picture.huixuanjiasu.com" --域名，方便查找token, 如：hbz.qrmkt.cn
TaskTMP.IS_USE_FULL_REQDATA 	= true        -- 是否保存当前完整的请求数据,下次用当前数据去请求，此时需要在DATA_TO_FIND_ARRAY配置要查找的Url,会用ReqUrl去做对比，一致则保存
TaskTMP.IS_REPEAT_FOREVER 		= false       -- 是否永久做此任务，停不下来(切换任务对象可以停下来)
TaskTMP.IS_AUTO_DO_ACTION 		= false 	  -- 是否自动做任务,是的话会默认把UI选中
TaskTMP.DEFAULT_KABAO_COUNT 	= 1 	      -- 默认卡包次数，需要设置isKabao后才生效
TaskTMP.DEFAULT_INPUT_TEXT 	    = "" 		  -- 输入框默认值

-- IS_USE_FULL_REQDATA == true 查找的是URL链接或链接的子串, 否则就是查找的Header里面的token或CK
TaskTMP.DATA_TO_FIND_ARRAY 		= {
	-- "http://picture.huixuanjiasu.com/game/get_question",--抓题目
	"http://picture.huixuanjiasu.com/game/submit_answer",--答题
	-- "http://picture.huixuanjiasu.com/tasks/ad_reward",
}

-- 额外的请求头,会单独配置到请求头进去,如：{["Refer"]="www.baidu.com"}
TaskTMP.ERQ_HEADER_EXT = {
	["Content-Type"] = "application/x-www-form-urlencoded",
	["Accept"]  = "*/*",
	["Accept-Language"] = "zh-Hans-US;q=1",
	["Accept-Encoding"] = "gzip, deflate",
	["User-Agent"] = "da ti da ying jia/1.0.0 (iPhone; iOS 14.4; Scale/3.00)",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	-- {
	-- 	curTaskName = "请求题目~", 
	-- 	url = "",
	-- 	method = POST, 
	-- 	reqCount = 1,
	-- 	urlBody = "", 
	-- 	postBody = "",
	-- 	delay = 0,
	-- 	isKabao = true,
	-- },
	{
		curTaskName = "答题~", 
		url = "http://picture.huixuanjiasu.com/game/submit_answer",
		method = POST, 
		reqCount = 1,
		urlBody = "", 
		postBody = "",
		delay = 0,
		isKabao = true,
	},
	{
		curTaskName = "看广告~", 
		url = "http://picture.huixuanjiasu.com/tasks/ad_reward",
		method = POST, 
		reqCount = 1,
		urlBody = "", 
		postBody = "",
		delay = 0,
		isKabao = true,
	},
	-- {
	-- 	curTaskName = "请求玩家信息~", 
	-- 	url = "",
	-- 	method = POST, 
	-- 	reqCount = 1,
	-- 	urlBody = "", 
	-- 	postBody = "",
	-- 	delay = 0,
	-- 	isKabao = true,
	-- },
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
    "ResBody" = "",
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
	local reqBody =  tmpTokenTable["ReqBody"]
	local resBody = tmpTokenTable["ResBody"]
	 -- IS_USE_FULL_REQDATA == true 才能用连接来判断，否则只有Header的数据
	 -- 如果抓到这个子串，可以用这条请求信息制造成目标请求信息，保存在本地，方便用来请求
	 -- 可以制造多条本地记录,添加到retTable就行了

	 --抓到题目就去答题
	 --[[
	local tmpTokenTable_1 = clone(requestInfo)
	if CSFun.IsSubString(reqUrl, "http://picture.huixuanjiasu.com/game/get_question") then
		local decodeResBody = json.decode(resBody)
		dump(decodeResBody,"hcc>>resBody")
		local answer_id = decodeResBody["data"]["subject_info"]["_id"] or "null"
		local question_id = decodeResBody["data"]["question_id"] or "null"
		local answer_str = "answer_id=" .. answer_id .. "&question_id=" .. question_id
		print("answer_str: " .. answer_str)

		local tmpUrlBody = StringUtils.splitUrlWithHost(reqUrl) or {}
		dump(tmpUrlBody,"tmpUrlBody")

		tmpTokenTable_1["ReqUrl"] = "http://picture.huixuanjiasu.com/game/submit_answer"
		tmpTokenTable_1["Method"] = "POST"
		tmpTokenTable_1["ReqBody"] = answer_str
		tmpTokenTable_1["UrlBody"] = tmpUrlBody[2]
		tmpTokenTable_1["ResBody"] = ""
		table.insert(retTable,tmpTokenTable_1)
	end
	]]

	--答完题去看广告
	local tmpTokenTable_1 = clone(requestInfo)
	if CSFun.IsSubString(reqUrl, "http://picture.huixuanjiasu.com/game/submit_answer") then
		-- tmpTokenTable_1["ReqUrl"] = "http://picture.huixuanjiasu.com/tasks/ad_reward"
		-- local tmpUrlBody = StringUtils.splitUrlWithHost(reqUrl) or {}
		-- tmpTokenTable_1["UrlBody"] = tmpUrlBody[2]
		-- tmpTokenTable_1["ReqBody"] = ""
		table.insert(retTable,tmpTokenTable_1)
	end

	--看广澳
	local tmpTokenTable_2 = clone(requestInfo)
	if CSFun.IsSubString(reqUrl, "http://picture.huixuanjiasu.com/tasks/ad_reward") then
		table.insert(retTable,tmpTokenTable_2)
	end
	return retTable
end

--请求服务之前,预留接口以便修改请求参数
function TaskTMP:onBeforeRequest(httpTaskObj)
	local reqUrl 	= httpTaskObj:getUrl()
	local urlBody 	= httpTaskObj:getUrlBody()
	local postBody 	= httpTaskObj:getPostBody()
	local headers 	= httpTaskObj:getHeader()
	local allInfo 	= httpTaskObj:getRequestInfo()
	dump(allInfo,"allInfo")
end

return TaskTMP