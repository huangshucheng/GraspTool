--[[红牛活动]]

local TaskBase 		= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 		= class("TaskTMP", TaskBase)
local GET 			= TaskBase.GET
local POST 			= TaskBase.POST

TaskTMP.FIND_STRING_HOST 	= "hzhnapi.msjp1.com"
TaskTMP.DATA_TO_FIND_ARRAY 	= {"Authorization"}
TaskTMP.DEFAULT_KABAO_COUNT = 100

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["Content-Type"] = "application/json;charset=utf-8",
	["Accept"] = "application/json, text/plain, */*",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	-- {
	-- 	curTaskName = "预抽奖~", 
	-- 	url = "http://hzhnapi.msjp1.com/LuckDraw",
	-- 	method = POST, 
	-- 	reqCount = 1,
	-- 	urlBody = "", 
	-- 	postBody = "", 
	-- 	delay = 0,
	-- 	isKabao = true,
	-- },
	{
		curTaskName = "抽奖~", 
		url = "http://hzhnapi.msjp1.com/LuckDraw",
		method = POST, 
		reqCount = 1,
		urlBody = "", 
		postBody = [[{"isVerification":true,"orderType":""}]], 
		delay = 0,
		isKabao = true,
	},
}
return TaskTMP