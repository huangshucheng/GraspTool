--[[抖音点赞]]
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)
local GET 		= TaskBase.GET
local POST 		= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "laotie8.com"
TaskTMP.DEFAULT_KABAO_COUNT 	= 100
TaskTMP.IS_USE_FULL_REQDATA 	= true       --是否保存当前完整的请求数据,下次用当前数据去请求
TaskBase.IS_REPEAT_FOREVER 		= true
TaskTMP.DATA_TO_FIND_ARRAY 		= 
{
	"https://laotie8.com",
}

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	-- ["Content-Type"] = "application/x-www-form-urlencoded",
	-- ["Accept-Encoding"] = "gzip, deflate, br",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "网站爆破~",
		url = "https://laotie8.com",
		method = GET,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 0,
		isKabao = true,
	},
}

function TaskTMP:onResponse(httpRes, taskCur)
end

return TaskTMP