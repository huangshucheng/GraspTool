--[[往来账薄试玩赚钱]]
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local CSFun 		= require("resources.luaScript.util.CSFun")
local StringUtils 	= require("resources.luaScript.util.StringUtils")
local LuaCallCShapUI = require("resources.luaScript.uiLogic.LuaCallCShapUI")
local GET 			= TaskBase.GET
local POST 			= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "shike.com"
TaskTMP.DEFAULT_KABAO_COUNT 	= 1
TaskTMP.IS_USE_FULL_REQDATA 	= true       --是否保存当前完整的请求数据,下次用当前数据去请求
TaskTMP.DATA_TO_FIND_ARRAY 		= 
{
	"shike.com/shike/api/appStep"
}

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "打开下载的app~",
		--https://shike.com/shike/api/appStep?sign=948E43EFF05D0BC28737B30CBC246B75306129C7E3E9A0D1628337E2CC325667C6E305FEAD0594531410D5349FC981EB&step=2&open=1
		url = "https://shike.com/shike/api/appStep",
		method = POST,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 0,
		isKabao = true,
	},
	{
		curTaskName = "下载结束提交~",
		url = "https://shike.com/shike/api/appSubmit",
		method = POST,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 0,
		isKabao = true,
	},
	{
		curTaskName = "打开红包~",
		url = "https://shike.com/shike/api/index/openPackage?bundleId=com.cash.gift",
		method = GET,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 0,
		isKabao = true,
	},
}

--找到token后保存在本地前，预留接口以便修改请求内容
function TaskTMP:onBeforeSaveToLocal(tokenTable)
	local tmpTokenTable = clone(tokenTable)
	local retTable = {}
	local reqUrl = tmpTokenTable["ReqUrl"] or "null"
	-- print("11111 " .. reqUrl)
	--打开app
	local tmpTokenTable_1  = clone(tokenTable)
	if CSFun.IsSubString(reqUrl, "shike.com/shike/api/appStep") and not CSFun.IsSubString(reqUrl,"step=") then
		-- print("22222 " .. reqUrl)
		tmpTokenTable_1["ReqUrl"] = reqUrl .. "&step=2&open=1"
		tmpTokenTable_1["Method"] = "GET"
		tmpTokenTable_1["ReqBody"] = ""
		tmpTokenTable_1["ResBody"] = ""
		tmpTokenTable_1["Headers"]["Content-Type"] = "application/json, text/plain, */*"
		table.insert(retTable,tmpTokenTable_1)
	end
	-- {"code":"0","desc":"OK","data":{"countdown":55,"step":"3"}}

	local tmpTokenTable_1_1  = clone(tokenTable)
	if CSFun.IsSubString(reqUrl, "shike.com/shike/api/appStep") and not CSFun.IsSubString(reqUrl,"step=") then
		-- print("22222_1 " .. reqUrl)
		tmpTokenTable_1_1["ReqUrl"] = reqUrl .. "&step=3"
		tmpTokenTable_1_1["Method"] = "GET"
		tmpTokenTable_1_1["ReqBody"] = ""
		tmpTokenTable_1_1["ResBody"] = ""
		tmpTokenTable_1_1["Headers"]["Content-Type"] = "application/json, text/plain, */*"
		table.insert(retTable,tmpTokenTable_1_1)
	end
	-- {"code":"0","desc":"OK","data":{"countdown":54,"step":"3"}}

	-- print("33333 " .. reqUrl)
	--提交
	local tmpTokenTable_2  = clone(tokenTable)
	if CSFun.IsSubString(reqUrl, "shike.com/shike/api/appStep") and not CSFun.IsSubString(reqUrl,"step=") then
		-- print("44444 " .. reqUrl)
		tmpTokenTable_2["ReqUrl"] = "https://shike.com/shike/api/appSubmit"
		tmpTokenTable_2["Method"] = "POST"

		local paramTable = StringUtils.getUrlParamTable(reqUrl) or {}
		local tmpReqBody = paramTable["sign"] or "null"
		tmpReqBody = "sign=" .. tmpReqBody .. "&type=1"

		tmpTokenTable_2["ReqBody"] = tmpReqBody
		tmpTokenTable_2["ResBody"] = ""
		tmpTokenTable_2["Headers"]["Content-Type"] = "application/x-www-form-urlencoded;charset=UTF-8"
		tmpTokenTable_2["Headers"]["Origin"] = "https://shike.com"
		table.insert(retTable,tmpTokenTable_2)
	end
	-- {"code":"0","desc":"OK","data":{"money":"0.80","firstTask":"0","has_zan":false,"percent":null,"inviteLimit":"1","status":"1"}} --成功
	-- {"code":"0","desc":"OK","data":{"firstTask":"0","time":1,"has_zan":false,"inviteLimit":"1","status":"704","second":56}} --失败
	print("55555 " .. reqUrl)
	--[[
	--打开红包
	local tmpTokenTable_3  = clone(tokenTable)
	if CSFun.IsSubString(reqUrl, "shike.com/shike/api/appStep") and not CSFun.IsSubString(reqUrl,"step=") then
		print("66666 " .. reqUrl)
		tmpTokenTable_3["ReqUrl"] = "https://shike.com/shike/api/index/openPackage?bundleId=com.cash.gift"
		tmpTokenTable_3["Method"] = "GET"
		tmpTokenTable_3["ReqBody"] = ""
		tmpTokenTable_3["ResBody"] = ""
		tmpTokenTable_3["Headers"]["Content-Type"] = "application/json, text/plain, */*"
		table.insert(retTable, tmpTokenTable_3)
	end
	]]
	return retTable
end

--请求服务之前,预留接口以便修改请求参数
function TaskTMP:onBeforeRequest(httpTaskObj)
	local reqUrl 	= httpTaskObj:getUrl()
	local urlBody 	= httpTaskObj:getUrlBody()
	local postBody 	= httpTaskObj:getPostBody()
	local headers 	= httpTaskObj:getHeader()
	local allInfo 	= httpTaskObj:getRequestInfo()
	dump(allInfo,"allInfo")
end

return TaskTMP