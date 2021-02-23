--[[抖音抓CK]]
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)
local GET 		= TaskBase.GET
local POST 		= TaskBase.POST
local CSFun 		= require("resources.luaScript.util.CSFun")

TaskTMP.FIND_STRING_HOST 		= "normal-c-"
TaskTMP.DEFAULT_KABAO_COUNT 	= 1
TaskTMP.IS_USE_FULL_REQDATA 	= true       --是否保存当前完整的请求数据,下次用当前数据去请求
TaskTMP.DATA_TO_FIND_ARRAY 		= 
{
	"aweme/v1/user/profile/self/",
}

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "CK1",
		url = "aweme/v1/user/profile/self/",
		method = POST,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 0,
		isKabao = false,
	},
}

--找到token后保存在本地前，预留接口以便修改请求内容
function TaskTMP:onBeforeSaveToLocal(tokenTable)
	local tmpTokenTable = clone(tokenTable)
	local retTable = {}
	local reqUrl = tmpTokenTable["ReqUrl"]
	print("11111")
	-- local tmpTokenTable_2 = {["Headers"] = {["Cookie"]= ""}}
	local tmpTokenTable_2 = {["Headers"] = {["Cookie"]= ""}}
	if CSFun.IsSubString(reqUrl, "aweme/v1/user/profile/self/") then
		print("22222")
		tmpTokenTable_2["Headers"]["Cookie"] = tmpTokenTable["Headers"]["Cookie"]
		table.insert(retTable,tmpTokenTable_2)
		print("333333333333333")
	end
	print("33333")

	-- if CSFun.IsSubString(reqUrl, "https://api3-core-c-lf.amemv.com/aweme/v1/user/profile/self/") then
	-- 	print("4444")
	-- 	tmpTokenTable_2["Headers"]["Cookie"] = tmpTokenTable["Headers"]["Cookie"]
	-- 	table.insert(retTable,tmpTokenTable_2)
	-- 	print("5555")
	-- end
	return retTable
end

return TaskTMP