--[[荷声活动--跑步领奖活动]]

local TaskBase = require("resources.luaScript.task.base.TaskBase")
local TaskRun = class("TaskRun", TaskBase)
local CSFun = require("resources.luaScript.util.CSFun")

local CUR_DIR_NAME = CSFun.GetCurDir()

function TaskRun:ctor()
	self.FIND_STRING_HOST = "hbz.qrmkt.cn"  --域名，方便查找token
	self.FILE_SAVE_NAME = "task_run_token.lua" -- 保存本地token文件名字
	self.RECORD_SAVE_FILE_NAME = "task_run_record.lua" --交互记录文件
	self.DATA_TO_FIND_ARRAY = {"token"}      --需要查找的taken 或者cookie
	self.IS_OPEN_RECORD = false 	  --是否抓取接口保存到本地
	self._taskList = {}
	self:loadTask()
end

return TaskRun