--[[通用活动]]
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)

local GET = TaskBase.GET
local POST = TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "zhrs.ijoynet.com"
TaskTMP.IS_OPEN_RECORD 			= false
TaskTMP.DEFAULT_KABAO_COUNT 	= 100
TaskTMP.IS_USE_FULL_REQDATA 	= true       --是否保存当前完整的请求数据,下次用当前数据去请求

TaskTMP.DATA_TO_FIND_ARRAY 		= 
{
	-- "https://wanjia.zhenxiad.com/wj20200820/server/server.php",
	-- "https://applet.suofeiya.com.cn/api/v1/SfyActivitySummary/doLuckDraw",
	-- "https://25971934-3.hd.faisco.cn/api/result?",
	"https://zhrs.ijoynet.com/zhrs/prize/oclockPick?",
}

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["Referer"] = "https://zhrs.ijoynet.com/game/index.html",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "抽奖~",
		url = "",
		method = GET,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 0,
		isKabao = true,
	},
}

return TaskTMP