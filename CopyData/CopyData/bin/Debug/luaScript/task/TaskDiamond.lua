--[[钻石任务]]
local TaskBase = require("luaScript.task.base.TaskBase")
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
		curTaskName = "do_sign", 
		url = "hbz.qrmkt.cn/hbact/hyr/sign/doit",
		method = POST, 
		preTaskName = "", 
		reqCount = 3,
		urlBody = "", 
		postBody = "", 
		delay = 0,
	},
	-- {
	-- 	curTaskName = "sign_list", 
	-- 	url = "hbz.qrmkt.cn/hbact/hyr/sign/list",
	-- 	method = POST, 
	-- 	preTaskName = "",
	-- 	reqCount = 1, 
	-- 	urlBody = "", 
	-- 	postBody = "", 
	-- 	delay = 0,
	-- },
	{
		curTaskName = "start_study", 
		url = "hbz.qrmkt.cn/hbact/school/study/start",
		method = POST, 
		preTaskName = "do_sign", 
		reqCount = 1,
		delay = 0,
	},	
	----[[
	{
		curTaskName = "end_study", 
		url = "hbz.qrmkt.cn/hbact/school/study/end",
		method = POST, 
		preTaskName = "start_study", 
		reqCount = 1,
		delay = 0,
	},

	{
		curTaskName = "share_code", 
		url = "hbz.qrmkt.cn/hbact/hyr/home/hasAwd",
		preTaskName = "end_study";
		method = GET,
		reqCount = 5,
		delay = 0,
	},

	-- {
	-- 	curTaskName = "my_card", 
	-- 	url = "hbz.qrmkt.cn/hbact/commucard/mycard",
	-- 	method = POST, 
	-- 	preTaskName = "share_code";
	-- 	reqCount = 1,
	-- 	delay = 0,
	-- },
	{
		curTaskName = "req_sutdy_page", 
		url = "hbz.qrmkt.cn/syx/wx/jsapi",
		method = POST,
		preTaskName = "share_code",
		reqCount = 10,
		delay = 0,
	},

	{
        -- {"code":"200","msg":null,"data":{"actCode":"ACT-8K38GWT8552W","id":245}}
		curTaskName = "active_exam",
		url = "hbz.qrmkt.cn/hbact/hyr/home/queryActCode",
		method = POST,
		preTaskName = "req_sutdy_page",
		reqCount = 10,
		delay = 0,
	},
	{
	    --answerNum考试机会 GET  {"code":"200","msg":null,"data":{"exchangeNum":10,"answerNum":1}}
		curTaskName = "active_exam_chance", 
		url = "hbz.qrmkt.cn/hbact/exam/chance",
		preTaskName = "active_exam";
		method = GET,
		reqCount = 10,
		delay = 0,
	},
	{
		-- curTaskName = "请求题目", url = "hbz.qrmkt.cn/hbact/exam/random",
	},
	{
		-- curTaskName = "提交答案", url = "hbz.qrmkt.cn/hbact/exam/finish", 
		-- method = POST,
	},
	--]]
}

--开始执行下一个任务
function TaskDiamond:onNextTask(curHttpTaskObj, preHttpTaskObj)
	local preTaskName = preHttpTaskObj and preHttpTaskObj:getTaskName() or "empty"
	print("hcc>>TaskDiamond>>onTaskStart>> curTaskName: " .. curHttpTaskObj:getTaskName() .. " ,preTaskName: " .. preTaskName)
end 

--切换下一个token执行任务
function TaskDiamond:onNextToken(curHttpTaskObj, preHttpTaskObj)
	local preTaskName = preHttpTaskObj and preHttpTaskObj:getTaskName() or "empty"
	print("hcc>>TaskDiamond>>onNextToken>> " .. curHttpTaskObj:getTaskName() .. "   ,preTaskName: " .. preTaskName)
end

return TaskDiamond