--[[通用活动]]
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)

local GET = TaskBase.GET
local POST = TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "e555916317699.fengchuanba.com"
TaskTMP.DEFAULT_KABAO_COUNT 	= 100
TaskTMP.IS_USE_FULL_REQDATA 	= true       --是否保存当前完整的请求数据,下次用当前数据去请求
TaskTMP.DATA_TO_FIND_ARRAY 		= 
{
	-- "https://applet.suofeiya.com.cn/api/v1/SfyActivitySummary/doLuckDraw",
	-- "https://25971934-3.hd.faisco.cn/api/result?",
	-- "https://zhrs.ijoynet.com/zhrs/prize/oclockPick",
	"https://e555916317699.fengchuanba.com/service/explore2/lottery",
	-- "https://e555916317699.fengchuanba.com/service/explore2/lottery"
}

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["Referer"] = "https://e555916317699.fengchuanba.com/index.html",
	["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "抽奖~",
		url = "https://e555916317699.fengchuanba.com/service/explore2/lottery",
		method = GET,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 0,
		isKabao = true,
	},
}

return TaskTMP