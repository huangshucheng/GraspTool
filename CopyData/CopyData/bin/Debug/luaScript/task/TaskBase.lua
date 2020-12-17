--[[任务基类]]

local TaskBase = class("TaskBase")

local Define = require("luaScript.config.Define")

TaskBase.FIND_STRING_HOST = "hbz.qrmkt.cn"  --域名，方便查找token

TaskBase.REQ_HEAD_STRING = Define.REQ_HEAD_BEFORE .. TaskBase.FIND_STRING_HOST
TaskBase.REQ_BODY_STRING = Define.REQ_BODY_BEFORE .. TaskBase.FIND_STRING_HOST
TaskBase.RES_HEAD_STRING = Define.RES_HEAD_BEFORE .. TaskBase.FIND_STRING_HOST
TaskBase.RES_BODY_STRING = Define.RES_BODY_BEFORE .. TaskBase.FIND_STRING_HOST

TaskBase.FILE_SAVE_NAME = "token.json" -- 保存本地token文件名字: token.json
TaskBase.DATA_TO_FIND_ARRAY = {"token"} -- 请求头中要查找的字段，如：token, Cookie

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
	local HttpTask = require("luaScript.task.HttpTask")
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

function TaskBase:getReqHeadString()
	return TaskBase.REQ_HEAD_STRING
end

function TaskBase:getReqBodyString()
	return TaskBase.REQ_BODY_STRING
end

function TaskBase:getResHeadString()
	return TaskBase.RES_HEAD_STRING
end

function TaskBase:getResBodyString()
	return TaskBase.RES_BODY_STRING
end

function TaskBase:getDataToFind()
	return TaskBase.DATA_TO_FIND_ARRAY
end

function TaskBase:getSaveFileName()
	local CSFun = require("luaScript.util.CSFun")
	local CUR_DIR_NAME = CSFun.GetCurDir()
	local fileName = tostring(CUR_DIR_NAME) .. [[\luaScript\token\]] .. TaskBase.FILE_SAVE_NAME
	return fileName
end

return TaskBase