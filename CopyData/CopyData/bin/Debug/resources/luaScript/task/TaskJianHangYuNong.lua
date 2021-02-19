--[[建行裕农红包加码]]
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)

local GET = TaskBase.GET
local POST = TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "activity.ynt.freeairnet.cn"
TaskTMP.DEFAULT_KABAO_COUNT 	= 100
TaskTMP.IS_USE_FULL_REQDATA 	= true
TaskTMP.IS_AUTO_DO_ACTION 		= true
TaskTMP.DATA_TO_FIND_ARRAY 		=
{
	"http://activity.ynt.freeairnet.cn/newyear/api/redeem",
}

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "领红包~",
		url = "http://activity.ynt.freeairnet.cn/newyear/api/redeem",
		method = GET,
		reqCount = 100,
		urlBody = "",
		postBody = "",
		delay = 0,
		isKabao = true,
	},
}

return TaskTMP