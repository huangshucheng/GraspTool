--[[抖音急速版抓CK]]
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)
local GET 		= TaskBase.GET
local POST 		= TaskBase.POST
local CSFun 		= require("resources.luaScript.util.CSFun")

TaskTMP.FIND_STRING_HOST 		= ".amemv.com"
TaskTMP.DEFAULT_KABAO_COUNT 	= 1
TaskTMP.IS_USE_FULL_REQDATA 	= true       --是否保存当前完整的请求数据,下次用当前数据去请求
TaskTMP.DATA_TO_FIND_ARRAY 		= 
{
	-- "https://api5-normal-c-lq.amemv.com/luckycat/aweme/v1/task/done/read?in_sp_time=0&caid1=a9d507d7c49269a9ad8190401fbd6674&version_code=13.8.0&js_sdk_version=1.95.0.5&tma_jssdk_version=1.95.0.5&app_name=douyin_lite&app_version=13.8.0&vid=E73E49AF-201D-40B5-96FF-E83454806D25&device_id=55751700548&channel=App%20Store&mcc_mnc=&aid=2329&screen_width=1536&openudid=f84ef3ee46dc199f2eeea5341ecf6f6aef56945d&cdid=943E831D-E152-4CDA-99F4-C0A38CE5C65C&os_api=18&ac=WIFI&os_version=13.5.1&device_platform=ipad&build_number=138006&iid=2674450094636343&device_type=iPad7,5&idfa=99427376-F66F-4D8A-8DE9-9CF3626A9BCB"
	"/luckycat/aweme/v1/task/done/read"
}

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	-- ["Referer"] = "",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "抖音CK",
		url = "/luckycat/aweme/v1/task/done/read",
		method = POST,
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
	local reqUrl = tmpTokenTable["ReqUrl"]
	local tmpTokenTable_1  = clone(tokenTable)
	if CSFun.IsSubString(reqUrl, "/luckycat/aweme/v1/task/done/read") then
		tmpTokenTable_1["ResBody"] = ""
		tmpTokenTable_1["Headers"]["Content-Type"] = "application/x-www-form-urlencoded;charset=UTF-8"
		table.insert(retTable,tmpTokenTable_1)
	end
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