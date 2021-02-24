--[[建信基金-抽奖活动]]
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)
local CSFun 		= require("resources.luaScript.util.CSFun")
local StringUtils 	= require("resources.luaScript.util.StringUtils")
local GET 		= TaskBase.GET
local POST 		= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "engine.cdollar.cn"
TaskTMP.DEFAULT_KABAO_COUNT 	= 10
TaskTMP.IS_USE_FULL_REQDATA 	= true

--需要查找的任务URL
TaskTMP.DATA_TO_FIND_ARRAY 		= 
{
	"https://engine.cdollar.cn/activity-engine/draw",
}

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "抽奖~",
		url = "https://engine.cdollar.cn/activity-engine/draw",
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
function TaskTMP:onBeforeSaveToLocal(tokenTable)
	local tmpTokenTable = clone(tokenTable)
	local retTable = {}
	local reqUrl = tmpTokenTable["ReqUrl"]

	--抽奖逻辑
	if CSFun.IsSubString(reqUrl, "https://engine.cdollar.cn/activity-engine/draw") then
		local splitTable = StringUtils.getUrlParamTable(reqUrl) or {}

		local reqBodyTable = {}
		reqBodyTable["activityId"] = splitTable["activityId"]
		reqBodyTable["type"] = "WECHAT"
		reqBodyTable["appId"] = splitTable["appId"]
		reqBodyTable["authKey"] = splitTable["authKey"]
		reqBodyTable["sign"] = splitTable["sign"]
		reqBodyTable["phone"] = "1847032" .. math.random(9) .. math.random(9) .. math.random(9) .. math.random(9)

		tmpTokenTable["ReqUrl"] = "https://engine.cdollar.cn/activity-engine/draw?sign=" .. tostring(splitTable["sign"])
		tmpTokenTable["Method"] = "POST"
		tmpTokenTable["ReqBody"] = json.encode(reqBodyTable)
		table.insert(retTable,tmpTokenTable)
	end
	return retTable
end

return TaskTMP