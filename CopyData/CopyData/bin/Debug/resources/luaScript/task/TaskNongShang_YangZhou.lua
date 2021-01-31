--[[农商银行-扬州]] 
local TaskBase 		= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 		= class("TaskTMP", TaskBase)
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local CSFun 		= require("resources.luaScript.util.CSFun")

local GET = TaskBase.GET
local POST = TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "yzweixin.yznsh.net"
TaskTMP.DATA_TO_FIND_ARRAY 		= {"XAuthToken","Cookie"}
TaskTMP.DEFAULT_KABAO_COUNT 	= 100 	-- 默认卡包次数，需要设置isKabao后才生效

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["Referer"] = "http://yzweixin.yznsh.net/win/WxyhServerV5/Areas/NTStartGood/Pages/picturePuzzle.html?mpId=rcb&typeCode=PCZNN",
	["Accept"] = "*/*",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "抽奖", 
		url = "http://yzweixin.yznsh.net/win/WxyhServerV5/api/LottApi/Run",
		method = POST, 
		reqCount = 150,
		urlBody = "", 
		postBody = [[{"typeCode":"PCZNN","wxLatitude":30.27662,"wxLongitude":120.0997,"locName":null,"testRun":true}]],
		delay = 0,
		isKabao = true,
	},
}

return TaskTMP