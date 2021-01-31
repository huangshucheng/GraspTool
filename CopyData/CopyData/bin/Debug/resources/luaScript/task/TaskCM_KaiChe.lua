--[[中荷人寿-开车]]
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)

local GET = TaskBase.GET
local POST = TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "zhrs.ijoynet.com"
TaskTMP.DEFAULT_KABAO_COUNT 	= 100
TaskTMP.IS_USE_FULL_REQDATA 	= true       --是否保存当前完整的请求数据,下次用当前数据去请求

--需要查找的任务URL
TaskTMP.DATA_TO_FIND_ARRAY 		= 
{
	"https://zhrs.ijoynet.com/zhrs/game/start", --开车开始
	"https://zhrs.ijoynet.com/zhrs/game/end", --开车结束
	"https://zhrs.ijoynet.com/zhrs/prize/upgradePick", --开车后抽奖
	"https://zhrs.ijoynet.com/zhrs/prize/oclockPick", --晚8点抽奖
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
		delay = 5,
		isKabao = false,
	},
	{
		curTaskName = "开车后抽奖~",
		url = "https://zhrs.ijoynet.com/zhrs/prize/upgradePick",
		method = GET,
		reqCount = 100,
		urlBody = "",
		postBody = "",
		delay = 0,
		isKabao = true,
	},
	{
		curTaskName = "晚八点抽奖~",
		url = "https://zhrs.ijoynet.com/zhrs/prize/oclockPick",
		method = GET,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 0,
		isKabao = true,
	},
}

return TaskTMP