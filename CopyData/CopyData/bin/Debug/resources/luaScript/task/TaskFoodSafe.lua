--[[黄浦食品安全活动]] 
--这个活动http的，不是https
local TaskBase = require("resources.luaScript.task.base.TaskBase")
local TaskFoodSafe = class("TaskFoodSafe", TaskBase)
local GET = TaskBase.GET
local POST = TaskBase.POST

function TaskFoodSafe:ctor()
	self.FIND_STRING_HOST = "xinhua.mofangdata.cn"  --域名，方便查找token
	self.FILE_SAVE_NAME = "task_foodsafe_token.lua" -- 保存本地token文件名字
	self.RECORD_SAVE_FILE_NAME = "task_foodsafe_record.lua" --交互记录文件
	self.DATA_TO_FIND_ARRAY = {"Cookie","Referer"}      --需要查找的taken 或者cookie
	self.IS_OPEN_RECORD = false 	  --是否抓取接口保存到本地
	self._taskList = {}
	self:loadTask()
end

--额外的请求头,也可以不用配置
TaskFoodSafe.ERQ_HEADER_EXT = {
	-- ["token"] = "hcctoken",
}

--任务列表
TaskFoodSafe.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "抽奖", 
		url = "http://xinhua.mofangdata.cn/wx/prize/tryit3.htm",
		method = POST, 
		reqCount = 100,
		urlBody = "", 
		postBody = "id=88", 
		delay = 0,
		-- isRedPacket = true,
	},
}


return TaskFoodSafe