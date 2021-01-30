--[[中荷人寿-开车]]
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)

local GET = TaskBase.GET
local POST = TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "zhrs.ijoynet.com"
TaskTMP.IS_OPEN_RECORD 			= false
TaskTMP.DEFAULT_KABAO_COUNT 	= 1
TaskTMP.IS_USE_FULL_REQDATA 	= true       --是否保存当前完整的请求数据,下次用当前数据去请求

--需要查找的任务URL
TaskTMP.DATA_TO_FIND_ARRAY 		= 
{
	"https://zhrs.ijoynet.com/zhrs/game/start",
	"https://zhrs.ijoynet.com/zhrs/game/end",
	-- "https://zhrs.ijoynet.com/zhrs/prize/upgradePick", --抽奖
}

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["Referer"] = "https://zhrs.ijoynet.com/game/index.html",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "开车开始~",
		url = "https://zhrs.ijoynet.com/zhrs/game/start",
		method = GET,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 0,
		isKabao = false,
	},
	{
		curTaskName = "开车结束~",
		url = "https://zhrs.ijoynet.com/zhrs/game/end",
		method = GET,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 10,
		isKabao = false,
	},
}

return TaskTMP