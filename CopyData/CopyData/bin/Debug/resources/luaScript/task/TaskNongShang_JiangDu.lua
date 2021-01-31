--[[农商银行-江都]] 
local TaskBase 		= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 		= class("TaskTMP", TaskBase)
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local CSFun 		= require("resources.luaScript.util.CSFun")

local GET = TaskBase.GET
local POST = TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "jiangdu.bj-virgo.cn"
TaskTMP.DEFAULT_KABAO_COUNT 	= 100 	-- 默认卡包次数，需要设置isKabao后才生效
TaskTMP.IS_USE_FULL_REQDATA 	= true       --是否保存当前完整的请求数据,下次用当前数据去请求

TaskTMP.DATA_TO_FIND_ARRAY = {
	"http://jiangdu.bj-virgo.cn/win/WxyhServer_DY_V5/api/HMAnswerLottery/HMAnswerLotteryApi/SubmitAnswer",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {

	{
		curTaskName = "答题抽奖~", 
		url = "http://jiangdu.bj-virgo.cn/win/WxyhServer_DY_V5/api/HMAnswerLottery/HMAnswerLotteryApi/SubmitAnswer",
		method = POST, 
		reqCount = 100,
		urlBody = "", 
		postBody = "",
		delay = 0,
		isKabao = true,
	},
}

return TaskTMP