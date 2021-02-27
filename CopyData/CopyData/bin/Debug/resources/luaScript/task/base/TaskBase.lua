--[[任务配置类，其他任务可由本任务配置继承拓展, 任务配置，管理着很多个httpTask的配置]]

local TaskBase 		= class("TaskBase")
local Define 		= require("resources.luaScript.config.Define")
local CSFun 		= require("resources.luaScript.util.CSFun")
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local StringUtils 	= require("resources.luaScript.util.StringUtils")

TaskBase.GET 		= Define.Method.GET
TaskBase.POST 		= Define.Method.POST
TaskBase.PUT 		= Define.Method.PUT
TaskBase.DELETE 	= Define.Method.DELETE
TaskBase.OPTIONS 	= Define.Method.OPTIONS

TaskBase.CUR_TASK_TITLE 		= ""          -- 当前任务标题，在TaskList.lua 里配置好的
TaskBase.FIND_STRING_HOST 		= ""          -- 域名，方便查找token, 如：hbz.qrmkt.cn
TaskBase.FILE_SAVE_NAME 		= ""          -- 保存本地token文件名字，如: xxx_token.lua,会自动根据lua文件名字取生成
TaskBase.RECORD_SAVE_FILE_NAME 	= ""          -- 交互记录文件, 如：xxx_record.lua，会自动生成
TaskBase.DEFAULT_INPUT_TEXT 	= "" 		  -- 输入框默认值
TaskBase.DATA_TO_FIND_ARRAY 	= {}          -- 请求头中要查找的字段，如：token, Cookie，如果设置了IS_USE_FULL_REQDATA=true,则会找url来匹配，不找header
TaskBase.ERQ_HEADER_EXT 		= {}          -- 额外的请求头,会单独配置到请求头进去,如：{["Refer"]="www.baidu.com"}
TaskBase.DEFAULT_KABAO_COUNT 	= 50 	      -- 默认卡包次数：50次，需要设置isKabao后才生效
TaskBase.IS_OPEN_RECORD 		= false 	  -- 是否抓取接口保存到本地,保存在xxx_record.lua
TaskBase.IS_USE_FULL_REQDATA 	= false       -- 是否保存当前完整的请求数据,下次用当前数据去请求，此时需要在DATA_TO_FIND_ARRAY配置要查找的Url,会用ReqUrl去做对比，一致则保存
TaskBase.IS_REPEAT_FOREVER 		= false 	  -- 是否永久做此任务，停不下来(切换任务对象可以停下来)
TaskBase.IS_AUTO_DO_ACTION 		= false 	  -- 是否自动做任务,是的话会默认把UI选中

local state_table = {
	"未开始~","进行中~","已完成~"
}

--任务列表，例子
TaskBase.TASK_LIST_URL_CONFIG = {
	{
		taskName = "抽奖~",  --任务名
		url = "",--任务URL
		method = TaskBase.GET, --请求方法
		preTaskName = "",  --前置任务名
		reqCount = 1, --请求次数
		urlBody = "",  --URL参数
		postBody = "",  --post参数
		delay = 0, --延迟
		isKabao = false, --是否卡包，若此条请求需要手动设置卡包次数的话，就用界面上配置的请求次数，reqCount就不生效了
	},
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
		--这个修改额外Header，放在抓到包修改数据之前，初始化之后，不然会被抓的包冲掉,在Finddata->addFindToken的时候加
		-- if table.nums(self.ERQ_HEADER_EXT) > 0 then
		-- 	task:addHeader(self.ERQ_HEADER_EXT)
		-- end
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
local tmp_redpkt_str = CSFun.Utf8ToDefault("红包")
function TaskBase:onResponse(httpRes, taskCur)
	local index = taskCur:getUserData()
	if CSFun.IsSubString(httpRes, tmp_redpkt_str) then
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

--卡包次数
function TaskBase:getDefaultKaBaoCount()
	return self.DEFAULT_KABAO_COUNT
end

--是否保存当前完整的请求数据,下次用当前数据去请求
function TaskBase:isUseFullReqData()
	return self.IS_USE_FULL_REQDATA
end

--当前任务是否永久执行
function TaskBase:isRepeatForever()
	return self.IS_REPEAT_FOREVER
end

--是否自动做任务，是的话会默认把UI选中
function TaskBase:isAutoDoAction()
	return self.IS_AUTO_DO_ACTION
end

--额外请求头
function TaskBase:getHeaderExt()
	return self.ERQ_HEADER_EXT
end

--输入框默认值
function TaskBase:getDefaultInputText()
	return self.DEFAULT_INPUT_TEXT
end

--客户端抓到token后保存到本地之前,预留接口以便修改保存数据
--如果是 IS_USE_FULL_REQDATA == true 情况，保存了完整的请求信息，就能拿到所有请求数据， 否则，只能拿到所有请求头的信息
--参数：requestInfo: 一条请求记录
--返回：｛requestInfo1,requestInfo2,...｝多个请求记录的集合，这里用table是为了方便脚本手动制造多个本地token记录
--[[
requestInfo ={
    "Headers" = {
     	"Cookies" = "reqid=123;uid=456;",
        "token"= "12345",
    },
    "Method"  = "",
    "ReqBody" = "",
    "ReqHost" = "",
    "ReqUrl"  = "",
    "UrlBody" = "",
}
]]
function TaskBase:onBeforeSaveToLocal(requestInfo)
	return {requestInfo}
end

--在请求服务之前，预留接口，预留接口以便修改请求参数
--httpTaskObj: HttpTask对象
function TaskBase:onBeforeRequest(httpTaskObj)

end

return TaskBase