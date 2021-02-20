--[[期货消消乐,需要进我的奖品界面]]
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)

local CSFun = require("resources.luaScript.util.CSFun")
local StringUtils 	= require("resources.luaScript.util.StringUtils")

local GET = TaskBase.GET
local POST = TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "hds-api.eqxiu.com"
TaskTMP.DEFAULT_KABAO_COUNT 	= 100
TaskTMP.IS_USE_FULL_REQDATA 	= true       --是否保存当前完整的请求数据,下次用当前数据去请求

--需要查找的任务URL
TaskTMP.DATA_TO_FIND_ARRAY 		= 
{
	"https://hds-api.eqxiu.com//m/hd/preview/queryWinInfo",
}

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["Content-Type"] = "application/x-www-form-urlencoded",
	["Accept"]  = "application/json, text/plain, */*",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "抽奖~",
		url = "https://hdc-api.eqxiu.com/m/hd/lotterydraw/start",
		method = POST,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 0,
		isKabao = true,
	}
}

--找到token后，预留接口以便修改请求内容
--斗转星移,用别的请求Url和参数改造成我想要的请求Url和参数
function TaskTMP:onAddFindInfo(tokenTable)
	local tmpTokenTable = clone(tokenTable)
	local retTable = {}
	-- dump(tmpTokenTable)
	local reqUrl = tmpTokenTable["ReqUrl"]
	if CSFun.IsSubString(reqUrl, "https://hds-api.eqxiu.com//m/hd/preview/queryWinInfo") then
		tmpTokenTable["ReqUrl"] = "https://hdc-api.eqxiu.com/m/hd/lotterydraw/start"
		local splitTable = StringUtils.splitUrlWithHost(reqUrl) or {}
		tmpTokenTable["ReqBody"] = splitTable[2] or ""
		tmpTokenTable["Method"] = "POST"
		table.insert(retTable,tmpTokenTable)
	end
	return retTable
end

return TaskTMP