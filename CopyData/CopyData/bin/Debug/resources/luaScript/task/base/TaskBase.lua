--[[任务配置类，其他任务可由本任务配置继承拓展]]

local TaskBase = class("TaskBase")
local Define = require("resources.luaScript.config.Define")
local CSFun = require("resources.luaScript.util.CSFun")
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")

TaskBase.GET = Define.Method.GET
TaskBase.POST = Define.Method.POST

--额外的请求头,如：{["Refer"]="www.baidu.com"}
TaskBase.ERQ_HEADER_EXT = {}

local state_table = {
	"未开始~","进行中~","已完成~"
}

--任务列表，例子
TaskBase.TASK_LIST_URL_CONFIG = {
--[[
	{
		taskName = "签到",  --任务名
		url = "hbz.qrmkt.cn/hbact/hyr/sign/doit",--任务URL
		method = TaskBase.GET, --请求方法
		preTaskName = "",  --前置任务名
		reqCount = 3, --请求次数
		urlBody = "",  --URL参数
		postBody = "",  --post参数
		delay = 0.2, --延迟
	},
	{
		taskName = "开始学习", 
		url = "hbz.qrmkt.cn/hbact/school/study/start",
		method = TaskBase.POST, 
		preTaskName = "签到", 
		reqCount = 3,
		urlBody = "", 
		postBody = "", 
		delay = 0.2,
	},
	]]
}

function TaskBase:ctor()
	self.CUR_TASK_TITLE 		= ""  --当前任务标题
	self.FIND_STRING_HOST 		= ""  --域名，方便查找token, 如：hbz.qrmkt.cn
	self.FILE_SAVE_NAME 		= ""  --保存本地token文件名字，如: token.lua
	self.RECORD_SAVE_FILE_NAME 	= ""  --交互记录文件, 如：token_record_url.lua
	self.DATA_TO_FIND_ARRAY = {}      --请求头中要查找的字段，如：token, Cookie
	self.IS_OPEN_RECORD = false 	  --是否抓取接口保存到本地
	self._taskList = {}
	self:loadTask()
end

--加载所有任务到任务列表
function TaskBase:loadTask()
	self._taskList = {}
	local HttpTask = require("resources.luaScript.task.base.HttpTask")
	for index, task_config in ipairs(self.TASK_LIST_URL_CONFIG) do
		local task = HttpTask.new()
		task:initWithConfig(task_config)
		task:setCurTaskIndex(index)
		if table.nums(self.ERQ_HEADER_EXT) > 0 then
			task:addHeader(self.ERQ_HEADER_EXT)
		end
		table.insert(self._taskList, task)
	end
end

--获取第一个任务
function TaskBase:getTop()
	return self._taskList[1]
end

--获取最后一个任务
function TaskBase:getEnd()
	return self._taskList[#self._taskList]
end

--获取任务列表
function TaskBase:getTaskList()
	return self._taskList
end

--获取任务数量
function TaskBase:getTaskCount()
	return #self._taskList
end

function TaskBase:getHost()
	return self.FIND_STRING_HOST
end

--请求头
function TaskBase:getReqHeadString()
	-- print("getReqHeadString()>> " .. Define.REQ_HEAD_BEFORE .. self.FIND_STRING_HOST)
	return Define.REQ_HEAD_BEFORE .. self.FIND_STRING_HOST
end

--请求体
function TaskBase:getReqBodyString()
	return Define.REQ_BODY_BEFORE .. self.FIND_STRING_HOST
end

--返回头
function TaskBase:getResHeadString()
	return Define.RES_HEAD_BEFORE .. self.FIND_STRING_HOST
end

--返回体
function TaskBase:getResBodyString()
	return Define.RES_BODY_BEFORE .. self.FIND_STRING_HOST
end

--交互记录
function TaskBase:getRecordString()
	return Define.RES_RECORD .. self.FIND_STRING_HOST
end

--查找字段
function TaskBase:getDataToFind()
	return self.DATA_TO_FIND_ARRAY
end

--是否开启记录交互记录
function TaskBase:getIsRecord()
	return self.IS_OPEN_RECORD
end

--任务标题
function TaskBase:getTitle()
	return self.CUR_TASK_TITLE
end

--返回保存tolen文件地址
function TaskBase:getSaveFileName()
	local CUR_DIR_NAME = CSFun.GetCurDir()
	local fileName = tostring(CUR_DIR_NAME) .. [[\resources\luaScript\token\]] .. self.FILE_SAVE_NAME
	return fileName
end

--返回保存交互记录文件地址
function TaskBase:getRecordGraspFileName()
	local CUR_DIR_NAME = CSFun.GetCurDir()
	local fileName = tostring(CUR_DIR_NAME) .. [[\resources\luaScript\token\]] .. self.RECORD_SAVE_FILE_NAME
	return fileName
end

--状态改变了
function TaskBase:onTaskStateChanged(curHttpTaskObj)
	local state = curHttpTaskObj:getState()
	local index = tonumber(curHttpTaskObj:getUserData())
	local stateStr = state_table[curHttpTaskObj:getState()] or ""
	CShapListView.ListView_set_item({index, nil, nil, nil, CSFun.Utf8ToDefault(stateStr)})
end

--返回,各个活动自己去做json解析，显示红包多少
function TaskBase:onResponse(httpRes, taskCur)
	local index = taskCur:getUserData()
	if string.find(httpRes,"红包") then
		taskCur:setGraspRedPktCount(taskCur:getGraspRedPktCount() + 1)
		local redPktCount = taskCur:getGraspRedPktCount()
		CShapListView.ListView_set_item({index, nil, nil, redPktCount, nil})
	end
end

--开始执行下一个任务,参数为HttpTask对象
--nextHttpTaskObj: 接下来要执行的task
--preHttpTaskObj: 前一个task
function TaskBase:onNextTask(nextHttpTaskObj, preHttpTaskObj)
	local index = preHttpTaskObj:getUserData()
	local resData = preHttpTaskObj:getResPonseData()
	local retStr = ""
end 

--切换下一个token执行任务
--nextHttpTaskObj: 接下来要执行的task
--preHttpTaskObj: 前一个task
function TaskBase:onNextToken(nextHttpTaskObj, preHttpTaskObj)

end

return TaskBase