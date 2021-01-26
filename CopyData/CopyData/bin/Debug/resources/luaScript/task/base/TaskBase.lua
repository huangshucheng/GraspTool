--[[任务配置类，其他任务可由本任务配置继承拓展, 任务配置，管理者很多个httpTask的配置]]

local TaskBase 		= class("TaskBase")
local Define 		= require("resources.luaScript.config.Define")
local CSFun 		= require("resources.luaScript.util.CSFun")
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local StringUtils 	= require("resources.luaScript.util.StringUtils")

TaskBase.GET 		= Define.Method.GET
TaskBase.POST 		= Define.Method.POST

TaskBase.CUR_TASK_TITLE 		= ""  --当前任务标题
TaskBase.FIND_STRING_HOST 		= ""  --域名，方便查找token, 如：hbz.qrmkt.cn
TaskBase.FILE_SAVE_NAME 		= ""  --保存本地token文件名字，如: token.lua
TaskBase.RECORD_SAVE_FILE_NAME 	= ""  --交互记录文件, 如：token_record_url.lua
TaskBase.DATA_TO_FIND_ARRAY 	= {}  --请求头中要查找的字段，如：token, Cookie
TaskBase.IS_OPEN_RECORD 		= false 	  --是否抓取接口保存到本地
TaskBase.ERQ_HEADER_EXT 		= {}          --额外的请求头,如：{["Refer"]="www.baidu.com"}
TaskBase.IS_WRITE_TOKEN_TO_POSTBODY = false   --是否将抓到的token放到请求体里面（原本就是token字段放在请求体的，只处理这种情况)
TaskBase.DEFAULT_KABAO_COUNT 	= 50 	-- 默认卡包次数：50次，需要设置isKabao后才生效

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
		isKabao = false, --是否卡包，若此条请求需要手动设置卡包次数的话，就用界面上配置的请求次数，reqCount就不生效了
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

--taken 记录的文件名，如果活动脚本为：TaskDiamond.lua 那么则为TaskDiamond_token.lua
local function getTaskTokenSaveFileName(script_path)
	local retTable = StringUtils.split2(script_path,".")
	-- dump(retTable, "hcc>>retTable")
	if retTable and next(retTable) then
		local script_name = retTable[#retTable] .. "_token.lua"
		return script_name
	end
end

--日志记录的文件名, 如果活动脚本为：TaskDiamond.lua 那么则为TaskDiamond_record.lua
local function getTaskRecordSaveFileName(script_path)
	local retTable = StringUtils.split2(script_path,".")
	if retTable and next(retTable) then
		local script_name = retTable[#retTable] .. "_record.lua"
		return script_name
	end
end

function TaskBase:ctor(param)
	self:initWithParam(param)
	self._taskList = {}
	self:loadTask()
end

function TaskBase:initWithParam(param)
	-- dump(param,"hcc>>param>>>>>")
	if not param or not next(param) then
		return
	end

	--设置活动标题
	self:setTitle(param.name or "")

	--设置保存tokan 的文件路径
	local scriptName = getTaskTokenSaveFileName(param.script or "")
	if scriptName then
		self:setSaveFileName(scriptName)
	end

     --设置保存抓token日志 的文件路径
	local scriptName2 = getTaskRecordSaveFileName(param.script or "")
	if scriptName2 then
		self:setRecordGraspFileName(scriptName2)
	end
end

--加载所有任务到任务列表
function TaskBase:loadTask()
	self._taskList = {}
	local HttpTask = require("resources.luaScript.task.base.HttpTask")
	for index, task_config in ipairs(self.TASK_LIST_URL_CONFIG) do
		local task = HttpTask.new()
		task:initWithConfig(task_config)
		task:setCurTaskIndex(index)
		-- dump(self.ERQ_HEADER_EXT,"hcc>>ERQ_HEADER_EXT")
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

--设置任务标题，切换任务的时候回自动修改
function TaskBase:setTitle(titleStr)
	self.CUR_TASK_TITLE = titleStr
end

--任务标题
function TaskBase:getTitle()
	return self.CUR_TASK_TITLE
end

--设置，保存tolen文件地址
function TaskBase:setSaveFileName(scriptName)
	if not scriptName or scriptName == "" then
		return
	end
	self.FILE_SAVE_NAME = scriptName
end

--返回保存tolen文件地址
function TaskBase:getSaveFileName()
	local CUR_DIR_NAME = CSFun.GetCurDir()
	local fileName = tostring(CUR_DIR_NAME) .. [[\resources\luaScript\token\]] .. self.FILE_SAVE_NAME
	return fileName
end

--设置，保存交互记录文件地址
function TaskBase:setRecordGraspFileName(scriptName)
	if not scriptName or scriptName == "" then
		return
	end
	self.RECORD_SAVE_FILE_NAME = scriptName
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

--子类自己实现reqBody的接口
function TaskBase:onReqBodyFind(reqBodyStr)

end

--是否将token放到请求体里面
function TaskBase:isWriteTokenToPostBody()
	return self.IS_WRITE_TOKEN_TO_POSTBODY
end

--卡包次数
function TaskBase:getDefaultKaBaoCount()
	return self.DEFAULT_KABAO_COUNT
end

return TaskBase