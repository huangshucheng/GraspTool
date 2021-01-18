--[[测试用]]
local TaskBase = require("resources.luaScript.task.base.TaskBase")
local TaskTMP = class("TaskTMP", TaskBase)
local GET = TaskBase.GET
local POST = TaskBase.POST

function TaskTMP:ctor()
	self.CUR_TASK_TITLE = "测试活动"  --当前任务标题
	self.FIND_STRING_HOST = ""  --域名，方便查找token
	self.FILE_SAVE_NAME = "task_test_token.lua" -- 保存本地token文件名字
	self.RECORD_SAVE_FILE_NAME = "task_test_record.lua" --交互记录文件
	self.DATA_TO_FIND_ARRAY = {"token"}      --需要查找的taken 或者cookie
	self.IS_OPEN_RECORD = false 	  --是否抓取接口保存到本地
	self._taskList = {}
	self:loadTask()
end

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
}

return TaskTMP