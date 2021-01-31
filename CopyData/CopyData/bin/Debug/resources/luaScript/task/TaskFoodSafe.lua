--[[黄浦食品安全活动]] 
local TaskBase 		= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 		= class("TaskTMP", TaskBase)
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local CSFun 		= require("resources.luaScript.util.CSFun")

local GET = TaskBase.GET
local POST = TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "xinhua.mofangdata.cn"
TaskTMP.DATA_TO_FIND_ARRAY 		= {"Cookie","Referer"}
TaskTMP.DEFAULT_KABAO_COUNT 	= 100 	-- 默认卡包次数，需要设置isKabao后才生效

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
	},
}

return TaskTMP