--[[zfb]]

local TaskBase = require("resources.luaScript.task.base.TaskBase")
local TaskZFB = class("TaskZFB", TaskBase)
local CSFun = require("resources.luaScript.util.CSFun")
local GET = TaskBase.GET
local POST = TaskBase.POST

function TaskZFB:ctor()
	self.FIND_STRING_HOST = "loggw.alipay.com"  --域名，方便查找token
	self.FILE_SAVE_NAME = "task_zfb_token.lua" -- 保存本地token文件名字
	self.RECORD_SAVE_FILE_NAME = "task_zfb_record.lua" --交互记录文件
	self.DATA_TO_FIND_ARRAY = {"token"}      --需要查找的taken 或者cookie
	self.IS_OPEN_RECORD = true 	  --是否抓取接口保存到本地
	self._taskList = {}
	self:loadTask()
end

--任务列表
TaskZFB.TASK_LIST_URL_CONFIG = {
	-- {
		-- curTaskName = "请求活动码啊", 
		-- url = "https://hbz.qrmkt.cn/hbact/hyr/home/queryActCode",
		-- method = POST, 
		-- reqCount = 1,
		-- urlBody = "", 
		-- postBody = "actType=2", 
		-- delay = 0,
	-- },
}

return TaskZFB