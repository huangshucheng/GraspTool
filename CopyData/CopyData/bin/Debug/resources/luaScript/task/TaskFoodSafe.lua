--[[黄浦食品安全活动]] 
local TaskBase 		= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 		= class("TaskTMP", TaskBase)
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local CSFun 		= require("resources.luaScript.util.CSFun")

local GET = TaskBase.GET
local POST = TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "xinhua.mofangdata.cn"
TaskTMP.DATA_TO_FIND_ARRAY 		= {"Cookie","Referer"}
TaskTMP.DEFAULT_KABAO_COUNT 	= 150 	-- 默认卡包次数，需要设置isKabao后才生效

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8; application/json",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "抽奖", 
		url = "http://xinhua.mofangdata.cn/wx/prize/tryit3.htm",
		method = POST, 
		reqCount = 150,
		urlBody = "", 
		postBody = "id=88", 
		delay = 0,
		isKabao = true,
	},
}

return TaskTMP