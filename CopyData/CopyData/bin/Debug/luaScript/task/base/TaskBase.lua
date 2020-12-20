--[[任务配置类，其他任务可由本任务配置继承拓展]]

local TaskBase = class("TaskBase")
local Define = require("luaScript.config.Define")

TaskBase.FIND_STRING_HOST = "hbz.qrmkt.cn"  --域名，方便查找token
TaskBase.FILE_SAVE_NAME = "token.lua" -- 保存本地token文件名字
TaskBase.RECORD_SAVE_FILE_NAME = "token_record_url.lua" --交互记录文件
TaskBase.DATA_TO_FIND_ARRAY = {}      -- 请求头中要查找的字段，如：token, Cookie
TaskBase.IS_OPEN_RECORD = false 	  --是否抓取接口保存到本地
TaskBase.GET = Define.Method.GET
TaskBase.POST = Define.Method.POST

--任务列表，例子
TaskBase.TASK_LIST_URL_CONFIG = {
	{
		taskName = "do_sign", 
		url = "hbz.qrmkt.cn/hbact/hyr/sign/doit",
		method = TaskBase.GET, 
		preTaskName = "", 
		reqCount = 3,
		urlBody = "", 
		postBody = "", 
		delay = 0.2,
	},
	{
		taskName = "start_study", 
		url = "hbz.qrmkt.cn/hbact/school/study/start",
		method = TaskBase.POST, 
		preTaskName = "do_sign", 
		reqCount = 3,
		urlBody = "", 
		postBody = "", 
		delay = 0.2,
	},
}

function TaskBase:ctor()
	self._taskList = {}
	self:loadTask()
end

function TaskBase:loadTask()
	local HttpTask = require("luaScript.task.base.HttpTask")
	for k, task_config in pairs(TaskBase.TASK_LIST_URL_CONFIG) do
		local task = HttpTask.new()
		task:initWithConfig(task_config)
		table.insert(self._taskList, task)
	end
end

function TaskBase:getTop()
	return self._taskList[1]
end

function TaskBase:getEnd()
	return self._taskList[#self._taskList]
end

function TaskBase:getTaskList()
	return self._taskList
end

--请求头
function TaskBase:getReqHeadString()
	-- print("getReqHeadString()>> " .. Define.REQ_HEAD_BEFORE .. TaskBase.FIND_STRING_HOST)
	return Define.REQ_HEAD_BEFORE .. TaskBase.FIND_STRING_HOST
end

--请求体
function TaskBase:getReqBodyString()
	return Define.REQ_BODY_BEFORE .. TaskBase.FIND_STRING_HOST
end

--返回头
function TaskBase:getResHeadString()
	return Define.RES_HEAD_BEFORE .. TaskBase.FIND_STRING_HOST
end

--返回体
function TaskBase:getResBodyString()
	return Define.RES_BODY_BEFORE .. TaskBase.FIND_STRING_HOST
end

--交互记录
function TaskBase:getRecordString()
	return Define.RES_RECORD .. TaskBase.FIND_STRING_HOST
end

--查找字段
function TaskBase:getDataToFind()
	return TaskBase.DATA_TO_FIND_ARRAY
end

--是否开启记录交互记录
function TaskBase:getIsRecord()
	return TaskBase.IS_OPEN_RECORD
end

--返回保存tolen文件地址
function TaskBase:getSaveFileName()
	local CSFun = require("luaScript.util.CSFun")
	local CUR_DIR_NAME = CSFun.GetCurDir()
	local fileName = tostring(CUR_DIR_NAME) .. [[\\luaScript\\token\\]] .. TaskBase.FILE_SAVE_NAME; --winform 路径需要用双斜杠， lua保存文件用但斜杠
	return fileName
end

--返回保存交互记录文件地址
function TaskBase:getRecordGraspFileName()
	local CSFun = require("luaScript.util.CSFun")
	local CUR_DIR_NAME = CSFun.GetCurDir()
	local fileName = tostring(CUR_DIR_NAME) .. [[\\luaScript\\token\\]] .. TaskBase.RECORD_SAVE_FILE_NAME; --winform 路径需要用双斜杠， lua保存文件用但斜杠
	return fileName
end

--开始执行下一个任务
--curHttpTaskObj: 当前task
--preHttpTaskObj: 前一个task
function TaskBase:onNextTask(curHttpTaskObj, preHttpTaskObj)
	local preTaskName = preHttpTaskObj and preHttpTaskObj:getTaskName() or "empty"
	print("hcc>>onTaskStart>> curTaskName: " .. curHttpTaskObj:getTaskName() .. " ,preTaskName: " .. preTaskName)
end 

--切换下一个token执行任务
--curHttpTaskObj: 当前task
--preHttpTaskObj: 前一个task
function TaskBase:onNextToken(curHttpTaskObj, preHttpTaskObj)
	local preTaskName = preHttpTaskObj and preHttpTaskObj:getTaskName() or "empty"
	print("hcc>>onNextToken>> " .. curHttpTaskObj:getTaskName() .. "   ,preTaskName: " .. preTaskName)
end

return TaskBase