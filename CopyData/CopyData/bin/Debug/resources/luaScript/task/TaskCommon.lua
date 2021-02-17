--[[通用活动]]
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)

local GET = TaskBase.GET
local POST = TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "xinhua.mofangdata.cn"
TaskTMP.DEFAULT_KABAO_COUNT 	= 200
TaskTMP.IS_USE_FULL_REQDATA 	= true
TaskTMP.IS_REPEAT_FOREVER 		= false
TaskTMP.DATA_TO_FIND_ARRAY 		= 
{
	-- "http://xinhua.mofangdata.cn/wx/prize/tryit3.htm",
}

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	-- ["Referer"] = "https://e555916317699.fengchuanba.com/index.html",
	-- ["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8",
	-- ["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8; application/json",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "抽奖~",
		url = "http://xinhua.mofangdata.cn/wx/prize/tryit3.htm",
		method = POST,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 0.5,
		isKabao = true,
	},
	{
		curTaskName = "参加活动~",
		url = "http://xinhua.mofangdata.cn/wx/prize/totryit5.htm",
		method = POST,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 0.5,
		isKabao = false,
	},
}

return TaskTMP