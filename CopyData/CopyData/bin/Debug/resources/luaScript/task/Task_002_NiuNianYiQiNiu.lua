--[[牛年一起牛-跑酷刷分活动]]
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)
local CSFun 			= require("resources.luaScript.util.CSFun")
local StringUtils 		= require("resources.luaScript.util.StringUtils")
local LuaCallCShapUI 	= require("resources.luaScript.uiLogic.LuaCallCShapUI")
local GET 		= TaskBase.GET
local POST 		= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "bright-dairy.tb21.cn"
TaskTMP.DEFAULT_KABAO_COUNT 	= 1
TaskTMP.IS_USE_FULL_REQDATA 	= true       --是否保存当前完整的请求数据,下次用当前数据去请求
TaskTMP.DEFAULT_INPUT_TEXT 		= "15000"

--需要查找的任务URL
TaskTMP.DATA_TO_FIND_ARRAY 		= 
{
	"http://bright-dairy.tb21.cn/bright-dairy-h5-2021/game/gameOver", --开车开始
}

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["Referer"] = "http://bright-dairy.tb21.cn/bright-dairy-h5-2021/game",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "设置分数~",
		url = "http://bright-dairy.tb21.cn/bright-dairy-h5-2021/game/gameOver",
		method = POST,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 0,
		isKabao = true,
	},
}

--找到token后保存在本地前，预留接口以便修改请求内容
function TaskTMP:onBeforeSaveToLocal(tokenTable)
	local tmpTokenTable = clone(tokenTable)
	local retTable = {}
	local reqUrl = tmpTokenTable["ReqUrl"]
	if CSFun.IsSubString(reqUrl, "http://bright-dairy.tb21.cn/bright-dairy-h5-2021/game/gameOver") then
		local tmpReqBody = tmpTokenTable["ReqBody"]
		-- lockNum=0&score=399&redpacketNum=0&goldNum=28&gameUuid=db880429-5170-4180-92d1-76da4af5fefb&reviveStatus=0
		local reqBodyTable = StringUtils.splitUrlParam(tmpReqBody)
		local inputStr = LuaCallCShapUI.GetUserInputText()
		reqBodyTable["score"] = inputStr
		local reqBodyStr = StringUtils.makeUpUrlByParam(reqBodyTable)
		-- print("ReqBody: " .. reqBodyStr)
		tmpTokenTable["ReqBody"] = reqBodyStr
		table.insert(retTable,tmpTokenTable)
	end
	return retTable
end

--请求服务之前,预留接口以便修改请求参数
function TaskTMP:onBeforeRequest(httpTaskObj)
	local reqUrl = httpTaskObj:getUrl()
	local urlBody = httpTaskObj:getUrlBody()
	local postBody = httpTaskObj:getPostBody()
	-- print("reqUrl: " .. reqUrl)
	-- print("urlBody: " .. urlBody)
	-- print("postBody11: " .. postBody)
	if CSFun.IsSubString(reqUrl,"http://bright-dairy.tb21.cn/bright-dairy-h5-2021/game/gameOver") then
		local reqBodyTable = StringUtils.splitUrlParam(postBody)
		local inputStr = LuaCallCShapUI.GetUserInputText()
		reqBodyTable["score"] = inputStr
		local tmpPostBodyStr = StringUtils.makeUpUrlByParam(reqBodyTable)
		-- print("postBody22: " .. tmpPostBodyStr)
		httpTaskObj:setPostBody(tmpPostBodyStr)
	end
end

return TaskTMP