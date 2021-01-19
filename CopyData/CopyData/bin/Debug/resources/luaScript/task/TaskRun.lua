--[[测试用]]
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)
local GET 		= TaskBase.GET
local POST 		= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "wx.hoyatod.cn"  --域名，方便查找token
TaskTMP.DATA_TO_FIND_ARRAY 		= {"token"}      --需要查找的taken 或者cookie
TaskTMP.IS_OPEN_RECORD 			= false

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
}

return TaskTMP