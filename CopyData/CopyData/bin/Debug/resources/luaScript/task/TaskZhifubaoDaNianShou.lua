--[[支付宝打年兽]]
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)

local GET = TaskBase.GET
local POST = TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= ""
TaskTMP.DEFAULT_KABAO_COUNT 	= 200
TaskTMP.IS_USE_FULL_REQDATA 	= true
TaskTMP.IS_REPEAT_FOREVER 		= false
TaskTMP.DATA_TO_FIND_ARRAY 		= 
{
	"http://xinhua.mofangdata.cn/wx/prize/tryit3.htm",
}

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "打年兽~",
		url = "",
		method = POST,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 0,
		isKabao = true,
	},
}

return TaskTMP