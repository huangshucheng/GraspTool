--[[六合抽奖]] 
local TaskBase 		= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 		= class("TaskTMP", TaskBase)
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local CSFun 		= require("resources.luaScript.util.CSFun")
local StringUtils 	= require("resources.luaScript.util.StringUtils")

local GET = TaskBase.GET
local POST = TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "123js1.qmkp.com.cn"
-- TaskTMP.DATA_TO_FIND_ARRAY 		= {"Referer","Cookie"}
TaskTMP.DATA_TO_FIND_ARRAY 		= {"Cookie"}
TaskTMP.DEFAULT_KABAO_COUNT 	= 100 	-- 默认卡包次数，需要设置isKabao后才生效

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8",
	["Accept"] = "*/*",
	["Accept-Encoding"] = "gzip, deflate",
	['Accept-Language'] = "zh-CN,zh;q=0.9,en-US;q=0.8,en;q=0.7",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "抽奖", 
		url = "http://123js1.qmkp.com.cn/LotteryNew_Sql/addPrizeUser.aspx",
		method = POST, 
		reqCount = 100,
		urlBody = "", 
		postBody = "",
		delay = 0,
		isKabao = true,
	},
}


--找到token后，预留接口以便修改本地保存的内容
function TaskTMP:onAddFindInfo(tokenTable)
	local tmpTokenTable = clone(tokenTable)
	local retTable = {}
	-- dump(tmpTokenTable)
	local reqHeaders = tmpTokenTable["Headers"]
	if reqHeaders and next(reqHeaders) then
		local cookiesStr = reqHeaders["Cookie"]
		local retTable = StringUtils.splitCookiesParam(cookiesStr)
		local param_1 = retTable["lottery_sn"] or "null"
		local param_2 = retTable["123js_opendid"] or "null"

		local param_1_1 = StringUtils.splitUrlParam(param_1) or {}
		local param_2_1 = StringUtils.splitUrlParam(param_2) or {}

		local reqBody = "cid=" .. tostring(param_1_1["lottery_sn"]) .. "&" .. "uid=" .. tostring(param_2_1["123js_opendid"])
		tmpTokenTable["ReqBody"] = reqBody
	end
	table.insert(retTable,tmpTokenTable)
	return retTable
end

return TaskTMP