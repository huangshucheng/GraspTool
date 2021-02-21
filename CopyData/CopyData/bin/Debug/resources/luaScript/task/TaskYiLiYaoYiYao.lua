--[[伊利摇一摇汤圆，活动]]
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)
local CSFun 		= require("resources.luaScript.util.CSFun")
local StringUtils 	= require("resources.luaScript.util.StringUtils")
local GET 		= TaskBase.GET
local POST 		= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "yilicny.beats-digital.com"
TaskTMP.DEFAULT_KABAO_COUNT 	= 10
TaskTMP.IS_USE_FULL_REQDATA 	= true

--需要查找的任务URL
TaskTMP.DATA_TO_FIND_ARRAY 		= 
{
	"https://yilicny.beats-digital.com/Api/yilicnyApi.ashx?method=AppLogin",
}

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "分享得到次数~",
		url = "https://yilicny.beats-digital.com/Api/yuandanApi.ashx?method=Addshare",
		method = POST,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 0,
		isKabao = true,
	},
	{
		curTaskName = "抽奖~",
		url = "https://yilicny.beats-digital.com/Api/yuandanApi.ashx?method=Luckdraw",
		method = POST,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 1,
		isKabao = true,
	},
}

--找到token后，预留接口以便修改请求内容
--斗转星移,用别的请求Url和参数改造成我想要的请求Url和参数
function TaskTMP:onAddFindInfo(tokenTable)
	local tmpTokenTable = clone(tokenTable)
	local retTable = {}
	local reqUrl = tmpTokenTable["ReqUrl"]
	--分享逻辑
	local tmpTokenTable_2 = clone(tokenTable)
	if CSFun.IsSubString(reqUrl, "https://yilicny.beats-digital.com/Api/yilicnyApi.ashx?method=AppLogin") then
		local tmpReqBody = tmpTokenTable_2["ReqBody"]
		local splitTable = StringUtils.splitUrlParam(tmpReqBody) or {}
		local sessionKey = splitTable["SessionKey"] or "null"
		tmpTokenTable_2["ReqUrl"] = "https://yilicny.beats-digital.com/Api/yuandanApi.ashx?method=Addshare"
		tmpTokenTable_2["ReqBody"] = "SessionKey=" .. sessionKey
		table.insert(retTable,tmpTokenTable_2)
	end

	--抽奖逻辑
	if CSFun.IsSubString(reqUrl, "https://yilicny.beats-digital.com/Api/yilicnyApi.ashx?method=AppLogin") then
		tmpTokenTable["ReqUrl"] = "https://yilicny.beats-digital.com/Api/yuandanApi.ashx?method=Luckdraw"
		local tmpReqBody = tmpTokenTable["ReqBody"]
		local splitTable = StringUtils.splitUrlParam(tmpReqBody) or {}
		local sessionKey = splitTable["SessionKey"] or "null"
		tmpTokenTable["ReqBody"] = "YuanDanCount=25&SessionKey=" .. sessionKey
		tmpTokenTable["Method"] = "POST"
		table.insert(retTable,tmpTokenTable)
	end
	-- dump(retTable,"retTable")
	return retTable
end

return TaskTMP