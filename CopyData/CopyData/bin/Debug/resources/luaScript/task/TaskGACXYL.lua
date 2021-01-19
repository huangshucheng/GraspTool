--[[广安储蓄有礼]] 
local TaskBase 		= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 		= class("TaskTMP", TaskBase)

local GET 	= TaskBase.GET
local POST 	= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "cdjkh.cn"
TaskTMP.DATA_TO_FIND_ARRAY 		= {"Cookie"}
TaskTMP.IS_OPEN_RECORD 			= false

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["User-Agent"] = "Mozilla/5.0 (iPhone; CPU iPhone OS 11_2_1 like Mac OS X) AppleWebKit/604.4.7 (KHTML, like Gecko) Mobile/15C153 MicroMessenger/7.0.12(0x17000c33) NetType/WIFI Language/zh_CN",
	["Referer"] = "https://h5.cdjkh.cn/",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "抢红包!", 
		url = "",
		method = POST, 
		reqCount = 200,
		urlBody = "", 
		postBody = "", 
		delay = 0,
	},
}

return TaskTMP