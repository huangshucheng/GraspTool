--[[科学防御抽奖活动]]

local TaskBase 		= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 		= class("TaskTMP", TaskBase)
local GET 			= TaskBase.GET
local POST 			= TaskBase.POST

TaskTMP.FIND_STRING_HOST 	= "123js1.qmkp.com.cn"
TaskTMP.DATA_TO_FIND_ARRAY 	= {"Cookie","Referer"}      
TaskTMP.DEFAULT_KABAO_COUNT = 100

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8",
	["Accept-Encoding"] = "gzip,deflate",
	["Accept"] = "*/*",
	["X-Requested-With"] = "XMLHttpRequest",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "抽奖~", 
		url = "http://123js1.qmkp.com.cn/LotteryNew_Sql/addPrizeUser.aspx",
		method = POST, 
		reqCount = 100,
		urlBody = "", 
		postBody = "cid=fA6v2gs/BxPXWnT3dB4lcA==&uid=o9jjg0pVENZvlj_W_inWM4Cx3KsA",
		-- postBody = "",
		delay = 0,
		isKabao = true,
	},
}

return TaskTMP