--[[钻石活动]]

local TaskBase = require("resources.luaScript.task.base.TaskBase")
local TaskDiamond = class("TaskDiamond", TaskBase)

TaskBase.FIND_STRING_HOST = "hbz.qrmkt.cn" --域名，方便查找token
TaskBase.FILE_SAVE_NAME = "task_diamond_token.lua" --保存本地token文件名字
TaskBase.RECORD_SAVE_FILE_NAME = "task_diamond_record.lua"
TaskBase.DATA_TO_FIND_ARRAY = {"token"} --需要查找的taken 或者cookie
TaskBase.IS_OPEN_RECORD = false --是否抓取接口保存到本地

local GET = TaskBase.GET
local POST = TaskBase.POST

--任务列表
TaskBase.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "sign_act_code", 
		url = "https://hbz.qrmkt.cn/hbact/hyr/home/queryActCode",
		method = POST, 
		preTaskName = "", 
		reqCount = 1,
		urlBody = "", 
		postBody = "actType=2", 
		delay = 0,
	},
	{
		curTaskName = "do_sign", 
		url = "hbz.qrmkt.cn/hbact/hyr/sign/doit",
		method = POST, 
		reqCount = 1,
		urlBody = "", 
		postBody = "shareCode=null", 
		delay = 0,
	},
	{
		curTaskName = "sign_list", 
		url = "hbz.qrmkt.cn/hbact/hyr/sign/list",
		method = POST, 
		reqCount = 1, 
		urlBody = "", 
		postBody = "", 
		delay = 0,
	},
	{
		curTaskName = "card_exchange_42", 
		url = "https://hbz.qrmkt.cn/hbact/commucard/exchange",
		method = GET, 
		reqCount = 1, 
		urlBody = "id=42",
		postBody = "", 
		delay = 0,
	},
	{
		curTaskName = "card_exchange_43", 
		url = "https://hbz.qrmkt.cn/hbact/commucard/exchange",
		method = GET, 
		reqCount = 1, 
		urlBody = "id=43", 
		postBody = "", 
		delay = 0,
	},
	{
		curTaskName = "card_exchange_51", 
		url = "https://hbz.qrmkt.cn/hbact/commucard/exchange",
		method = GET, 
		reqCount = 1, 
		urlBody = "id=51", 
		postBody = "", 
		delay = 0,
	},
	{
		curTaskName = "card_exchange_45", 
		url = "https://hbz.qrmkt.cn/hbact/commucard/exchange",
		method = GET, 
		reqCount = 1, 
		urlBody = "id=45", 
		postBody = "", 
		delay = 0,
	},
	{
		curTaskName = "card_exchange_46", 
		url = "https://hbz.qrmkt.cn/hbact/commucard/exchange",
		method = GET, 
		reqCount = 1, 
		urlBody = "id=46", 
		postBody = "", 
		delay = 0,
	},
	{
		curTaskName = "card_exchange_47", 
		url = "https://hbz.qrmkt.cn/hbact/commucard/exchange",
		method = GET, 
		reqCount = 1, 
		urlBody = "id=47", 
		postBody = "", 
		delay = 0,
	},
	{
		curTaskName = "card_exchange_49", 
		url = "https://hbz.qrmkt.cn/hbact/commucard/exchange",
		method = GET, 
		reqCount = 1, 
		urlBody = "id=49", 
		postBody = "", 
		delay = 0,
	},
	{
		curTaskName = "card_exchange_50", 
		url = "https://hbz.qrmkt.cn/hbact/commucard/exchange",
		method = GET, 
		reqCount = 1, 
		urlBody = "id=50", 
		postBody = "", 
		delay = 0,
	},
	{
		curTaskName = "card_exchange_52", 
		url = "https://hbz.qrmkt.cn/hbact/commucard/exchange",
		method = GET, 
		reqCount = 1, 
		urlBody = "id=52", 
		postBody = "", 
		delay = 0,
	},
	{
		curTaskName = "start_study", 
		url = "hbz.qrmkt.cn/hbact/school/study/start",
		method = POST, 
		reqCount = 1,
		delay = 0,
	},	
	{
		curTaskName = "end_study", 
		url = "hbz.qrmkt.cn/hbact/school/study/end",
		method = POST, 
		postBody = "shareCode=null",
		reqCount = 1,
		-- delay = 20,
		delay = 0,
	},
	{
		curTaskName = "active_exam_chance", 
		url = "hbz.qrmkt.cn/hbact/exam/chance",
		method = GET,
		reqCount = 1,
		delay = 0,
	},
	{
		curTaskName = "start_exam", 
		url = "hbz.qrmkt.cn/hbact/exam/random",
		method = GET,
		reqCount = 1,
		delay = 0,
	},
	--[[
	{
		curTaskName = "finish_exam", 
		url = "hbz.qrmkt.cn/hbact/exam/finish",
		method = POST,
		urlBody ="shareCode=null",
		postBody = "",
		reqCount = 1,
		delay = 0,
	},
	]]
	{
		curTaskName = "mine_check", 
		url = "hbz.qrmkt.cn/hbact/hyr/mine/check",
		method = POST,
		urlBody ="",
		postBody = "",
		reqCount = 1,
		delay = 0,
	},
	{
		curTaskName = "share_code", 
		url = "hbz.qrmkt.cn/hbact/hyr/home/hasAwd",
		method = GET,
		reqCount = 1,
		delay = 0,
	},
}

--开始执行下一个任务
function TaskDiamond:onNextTask(curHttpTaskObj, preHttpTaskObj)
	local curTaskName = curHttpTaskObj and curHttpTaskObj:getTaskName() or "empty"
	local preTaskName = preHttpTaskObj and preHttpTaskObj:getTaskName() or "empty"
	-- print("hcc>>TaskDiamond>>onTaskStart>> curTaskName: " .. curTaskName .. " ,preTaskName: " .. preTaskName)
end 

--切换下一个token执行任务
function TaskDiamond:onNextToken(curHttpTaskObj, preHttpTaskObj)
	local curTaskName = curHttpTaskObj and curHttpTaskObj:getTaskName() or "empty"
	local preTaskName = preHttpTaskObj and preHttpTaskObj:getTaskName() or "empty"
	-- print("hcc>>TaskDiamond>>onNextToken>> " .. curHttpTaskObj:getTaskName() .. "   ,preTaskName: " .. preTaskName)
end

return TaskDiamond