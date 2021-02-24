--[[肥东工会 - 答题]] 
local TaskBase 		= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 		= class("TaskTMP", TaskBase)
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local CSFun 		= require("resources.luaScript.util.CSFun")
local GET 			= TaskBase.GET
local POST 			= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "fdgh202001.open.ixiaomayun.com"
TaskTMP.DATA_TO_FIND_ARRAY 		= {"Cookie","Referer"}
TaskTMP.DEFAULT_KABAO_COUNT 	= 1 	-- 默认卡包次数，需要设置isKabao后才生效
TaskTMP.IS_REPEAT_FOREVER 		= false

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "测试能否答题~", 
		url = "http://fdgh202001.open.ixiaomayun.com/api/Active/Misc/Question/start?activeid=1542",
		method = POST, 
		reqCount = 1,
		urlBody = "", 
		postBody = "",
		delay = 0,
		isKabao = true,
		-- {"success":false,"message":"\u6bcf\u65e511:00\u5f00\u59cb","data":null,"status":null}
	},
	-- {
	-- 	curTaskName = "抽奖~", 
	-- 	url = "",
	-- 	method = POST, 
	-- 	reqCount = 1,
	-- 	urlBody = "", 
	-- 	postBody = "",
	-- 	delay = 0,
	-- 	isKabao = true,
	-- },
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

--请求服务之前,预留接口以便修改请求参数
function TaskTMP:onBeforeRequest(httpTaskObj)
	local reqUrl = httpTaskObj:getUrl()
	local urlBody = httpTaskObj:getUrlBody()
	local postBody = httpTaskObj:getPostBody()
	local headers = httpTaskObj:getHeader()
	local allInfo = httpTaskObj:getRequestInfo()
	-- dump(allInfo,"allInfo")
	-- print(reqUrl)
	-- dump(headers,"headers")
end

return TaskTMP