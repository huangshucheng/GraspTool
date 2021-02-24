--[[黄浦食品安全活动]] 
local TaskBase 		= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 		= class("TaskTMP", TaskBase)
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local CSFun 		= require("resources.luaScript.util.CSFun")
local GET 			= TaskBase.GET
local POST 			= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "xinhua.mofangdata.cn"
TaskTMP.DATA_TO_FIND_ARRAY 		= {"Cookie","Referer"}
TaskTMP.DEFAULT_KABAO_COUNT 	= 1 	-- 默认卡包次数，需要设置isKabao后才生效
TaskTMP.IS_REPEAT_FOREVER 		= true

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
		reqCount = 1,
		urlBody = "", 
		postBody = "id=90",
		delay = 1.5,
		isKabao = true,
	},
}

--找到token后，预留接口以便修改本地保存的内容
--[[
function TaskTMP:onBeforeSaveToLocal(tokenTable)
	local tmpTokenTable = clone(tokenTable)
	local retTable = {}
	-- local reqUrl = tmpTokenTable["Headers"]
	tmpTokenTable["ReqBody"] = "id=89"
	table.insert(retTable,tmpTokenTable)
	return retTable
end
]]

return TaskTMP