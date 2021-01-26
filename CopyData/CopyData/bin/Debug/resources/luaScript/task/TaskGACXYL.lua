--[[广安储蓄有礼]] 
local TaskBase 		= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 		= class("TaskTMP", TaskBase)
local FindData 		= require("resources.luaScript.data.FindData")
local UIConfigData  = require("resources.luaScript.data.UIConfigData")
local TaskStart 	= require("resources.luaScript.task.base.TaskStart")

local GET 	= TaskBase.GET
local POST 	= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "cdjkh.cn"
TaskTMP.DATA_TO_FIND_ARRAY 		= {"Cookie"}
TaskTMP.IS_OPEN_RECORD 			= false
TaskTMP.IS_WRITE_TOKEN_TO_POSTBODY = true --是否将token放到请求体里面
TaskTMP.DEFAULT_KABAO_COUNT 	= 60 	-- 默认卡包次数，需要设置isKabao后才生效

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["User-Agent"] = "Mozilla/5.0 (iPhone; CPU iPhone OS 11_2_1 like Mac OS X) AppleWebKit/604.4.7 (KHTML, like Gecko) Mobile/15C153 MicroMessenger/7.0.12(0x17000c33) NetType/WIFI Language/zh_CN",
	["Referer"] = "https://h5.cdjkh.cn/",
	["Content-Type"] = "application/json",
	["Origin"] = "https://h5.cdjkh.cn",
}

--[[
postBoyd:
5元：
{"token":"5mNvWdaQz4lSa3TtEnTGp41sIzVC90TG1vEx3oOiXTtCctxKLZUerfGYXSydDF/wLcI6QpOTGV6e61gfvR6G9g==","promotionId":21261630,"managerId":1191044,"itemId":21261631}
5元：
{"token":"5mNvWdaQz4lSa3TtEnTGp41sIzVC90TG1vEx3oOiXTtCctxKLZUerfGYXSydDF/wLcI6QpOTGV6e61gfvR6G9g==","promotionId":21261630,"managerId":1191044,"itemId":21261632}
10元：
{"token":"5mNvWdaQz4lSa3TtEnTGp41sIzVC90TG1vEx3oOiXTtCctxKLZUerfGYXSydDF/wLcI6QpOTGV6e61gfvR6G9g==","promotionId":21261630,"managerId":1191044,"itemId":21261633}
30元：
{"token":"5mNvWdaQz4lSa3TtEnTGp41sIzVC90TG1vEx3oOiXTtCctxKLZUerfGYXSydDF/wLcI6QpOTGV6e61gfvR6G9g==","promotionId":21261630,"managerId":1191044,"itemId":21261634}
38元:
{"token":"5mNvWdaQz4lSa3TtEnTGp41sIzVC90TG1vEx3oOiXTtCctxKLZUerfGYXSydDF/wLcI6QpOTGV6e61gfvR6G9g==","promotionId":21261630,"managerId":1191044,"itemId":21261635}
]]

local money_5_1 = {
	token = "",
	promotionId = "21261630",
	managerId =1191044,
	itemId = 21261631,
}

local money_5_2 = {
	token = "",
	promotionId = "21261630",
	managerId =1191044,
	itemId = 21261632,
}

local money_10 = {
	token = "",
	promotionId = "21261630",
	managerId =1191044,
	itemId = 21261633,
}

local money_30 = {
	token = "",
	promotionId = "21261630",
	managerId =1191044,
	itemId = 21261634,
}

local money_38 = {
	token = "",
	promotionId = "21261630",
	managerId =1191044,
	itemId = 21261635,
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "5yuan_1~!",
		url = "https://api.cdjkh.cn/api/v1/mpoc/create",
		method = POST,
		reqCount = 150,
		urlBody = "",
		postBody = json.encode(money_5_1),
		delay = 0,
	},
	{
		curTaskName = "5yuan_2~",
		url = "https://api.cdjkh.cn/api/v1/mpoc/create",
		method = POST,
		reqCount = 150,
		urlBody = "",
		postBody = json.encode(money_5_2),
		delay = 0,
	},
	{
		curTaskName = "10yuan~",
		url = "https://api.cdjkh.cn/api/v1/mpoc/create",
		method = POST,
		reqCount = 150,
		urlBody = "",
		postBody = json.encode(money_10),
		delay = 0,
	},
	{
		curTaskName = "30yuan~",
		url = "https://api.cdjkh.cn/api/v1/mpoc/create",
		method = POST,
		reqCount = 150,
		urlBody = "",
		postBody = json.encode(money_30),
		delay = 0,
	},
	{
		curTaskName = "38yuan~",
		url = "https://api.cdjkh.cn/api/v1/mpoc/create",
		method = POST,
		reqCount = 150,
		urlBody = "",
		postBody = json.encode(money_38),
		delay = 0,
	},
}

--找到了reqBody
function TaskTMP:onReqBodyFind(reqBodyStr)
	print("reqBodyStr" .. tostring(reqBodyStr))
	local ok, ret_table = pcall(function()
		return json.decode(reqBodyStr)
	end)

	if ok then
		ret_table = ret_table or {}
		local token_str = ret_table.token
		if token_str then
			-- print("token: " .. token_str)
			local findTable = { ["token"] = token_str}
			if not FindData:getInstance():isInFindList(findTable) then
				FindData:getInstance():addFindToken(findTable)
				--是否自动开始执行任务
				if UIConfigData.getIsAutoDoAction() then
					TaskStart.startEnd()
				end
			end
		end
	end
end

return TaskTMP