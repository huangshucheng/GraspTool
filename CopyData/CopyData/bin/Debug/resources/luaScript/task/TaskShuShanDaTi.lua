--[[蜀山科协-答题抽奖活动]]
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)
local CSFun 		= require("resources.luaScript.util.CSFun")
local StringUtils 	= require("resources.luaScript.util.StringUtils")
local GET 		= TaskBase.GET
local POST 		= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "zsjs.123js.cn"
TaskTMP.DEFAULT_KABAO_COUNT 	= 10
TaskTMP.IS_USE_FULL_REQDATA 	= true

--需要查找的任务URL
TaskTMP.DATA_TO_FIND_ARRAY 		= 
{
	"http://zsjs.123js.cn/Mobile2_Redis/Welcome900.aspx",
}

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8",
	["Accept-Encoding"] = "gzip, deflate",
	["Accept"] = "*/*",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "抽奖~",
		url = "http://zsjs.123js.cn/Mobile2_Redis/addPrizeUser.aspx",
		method = POST,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 1,
		isKabao = true,
	},
	-- {
	-- 	curTaskName = "抽奖222~",
	-- 	url = "http://zsjs.123js.cn/Mobile2_Redis/Welcome900.aspx",
	-- 	method = POST,
	-- 	reqCount = 1,
	-- 	urlBody = "",
	-- 	postBody = "",
	-- 	delay = 1,
	-- 	isKabao = true,
	-- },
}

--找到token后，预留接口以便修改请求内容
--斗转星移,用别的请求Url和参数改造成我想要的请求Url和参数
function TaskTMP:onBeforeSaveToLocal(tokenTable)
	local tmpTokenTable = clone(tokenTable)
	local retTable = {}
	local reqUrl = tmpTokenTable["ReqUrl"]
	local reqHeaders = tmpTokenTable["Headers"] or {}
	-- print("1111")
	--抽奖逻辑
	if CSFun.IsSubString(reqUrl, "http://zsjs.123js.cn/Mobile2_Redis/Welcome900.aspx") then
		-- print("2222")
		tmpTokenTable["ReqUrl"] = "http://zsjs.123js.cn/Mobile2_Redis/addPrizeUser.aspx"
		local cookiesStr = reqHeaders["Cookie"] or ""
		local retTable_cookie = StringUtils.splitCookiesParam(cookiesStr) or ""
		local param_1 = retTable_cookie["lottery_sn"] or "null"
		local param_2 = retTable_cookie["123js_opendid1"] or "null"
		local param_1_1 = StringUtils.splitUrlParam(param_1) or {}
		local param_2_1 = StringUtils.splitUrlParam(param_2) or {}
		tmpTokenTable["ReqBody"] = "cid=" .. tostring(param_1_1["lottery_sn"]) .. "&uid=" .. tostring(param_2_1["123js_opendid"])
		tmpTokenTable["Method"] = "POST"
		table.insert(retTable,tmpTokenTable)
	end
	return retTable
end

return TaskTMP