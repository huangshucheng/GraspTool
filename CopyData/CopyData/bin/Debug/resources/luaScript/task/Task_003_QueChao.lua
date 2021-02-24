--[[雀巢]] 
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)
local CSFun 		= require("resources.luaScript.util.CSFun")
local StringUtils 	= require("resources.luaScript.util.StringUtils")
local GET 		= TaskBase.GET
local POST 		= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "nestle.h5-x.com"
TaskTMP.DEFAULT_KABAO_COUNT 	= 10
TaskTMP.IS_USE_FULL_REQDATA 	= true       --是否保存当前完整的请求数据,下次用当前数据去请求

--需要查找的任务URL
TaskTMP.DATA_TO_FIND_ARRAY 		= 
{
	"https://nestle.h5-x.com/cards2020/Api/All/GetUsers",
}

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "抽奖~",
		url = "https://nestle.h5-x.com/cards2020/Api/All/Lucky",
		method = POST,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 0,
		isKabao = true,
	},
}

--找到token后，预留接口以便修改请求内容
--用查找的的Url参数，替换成目标Url的参数，或请求体
function TaskTMP:onBeforeSaveToLocal(tokenTable)
	local tmpTokenTable = clone(tokenTable)
	local retTable = {}
	local reqUrl = tmpTokenTable["ReqUrl"]
	if CSFun.IsSubString(reqUrl, "https://nestle.h5-x.com/cards2020/Api/All/GetUsers") then
		local urlParam = StringUtils.getUrlParam(reqUrl)
		tmpTokenTable["ReqUrl"] = "https://nestle.h5-x.com/cards2020/Api/All/Lucky?" .. tostring(urlParam)
		tmpTokenTable["ReqBody"] = "{}"
		table.insert(retTable,tmpTokenTable)
	end
	return retTable
end

return TaskTMP