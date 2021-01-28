--[[集荷新春活动]] 
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)

local GET = TaskBase.GET
local POST = TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "hbh.qrmkt.cn"
TaskTMP.DATA_TO_FIND_ARRAY 		= {"token"}
TaskTMP.IS_OPEN_RECORD 			= false
TaskTMP.DEFAULT_KABAO_COUNT 	= 100

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	-- ["User-Agent"] = "Mozilla/5.0 (iPhone; CPU iPhone OS 11_2_1 like Mac OS X) AppleWebKit/604.4.7 (KHTML, like Gecko) Mobile/15C153 MicroMessenger/7.0.12(0x17000c33) NetType/WIFI Language/zh_CN",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	-- {
	-- 	curTaskName = "抽奖", 
	-- 	url = "http://wx.hoyatod.cn/wxh5/hx/hongbao/20210114/WLSUEcodHy8check",
	-- 	method = POST, 
	-- 	reqCount = 200,
	-- 	urlBody = "", 
	-- 	postBody = "openid=oePCMuK9NrVSZTa_TEo9BMfZcU4M", 
	-- 	delay = 0,
	-- },
}

return TaskTMP