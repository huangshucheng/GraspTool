--[[任务启动脚本]]

local Define = require("luaScript.config.Define")
local HttpTask = require("luaScript.task.base.HttpTask")
local FindData = require("luaScript.data.FindData")
local CSFun = require("luaScript.util.CSFun")
local StringUtils = require("luaScript.util.StringUtils")
local TaskData = require("luaScript.data.TaskData")

local TaskStart = class("TaskStart")


function TaskStart.start()
	local index = 1
	local topToken = FindData:getInstance():getTop()
	if topToken then
		local taskList = TaskData.getCurTask():getTop()
		taskList:setUserData(index)
		taskList:addHeader(topToken)
		taskList:start(TaskStart.onResponseCallBack)
	end
end

function TaskStart.onResponseCallBack(httpRes, taskCur)
	httpRes = StringUtils.nullOrEmpty(httpRes) and " empty" or httpRes
	print("hcc>> index>> " .. taskCur:getUserData() .. "  ,name>> " .. taskCur:getTaskName() .. "   ,ret>> ".. tostring(httpRes));

	--第一个任务执行次数到了，执行 下一个任务
	if taskCur:getCurCount() >= taskCur:getReqCount() then

		local allTaskList = TaskData.getCurTask():getTaskList()
		local taskNext = allTaskList[taskCur:getCurTaskIndex()+1]

		if taskNext then 
			--找到了下一个任务，继续用当前用户的token执行下一个任务
			taskNext:setUserData(taskCur:getUserData())
			taskNext:addHeader(taskCur:getHeader())
			TaskData.getCurTask():onNextTask(taskNext, taskCur)
			taskNext:start(TaskStart.onResponseCallBack)

		else
            --没找到下一个任务，就换一个token执行任务
			local tokenList = FindData:getInstance():getTokenList()
			local nextIndex = tonumber(taskCur:getUserData()) + 1
			local nextToken = tokenList[nextIndex]
			if nextToken then
				local taskList = TaskData.getCurTask():getTop()
				taskList:setUserData(nextIndex)
				taskList:addHeader(nextToken)
				TaskData.getCurTask():onNextTask(taskList, taskCur)
				taskList:start(TaskStart.onResponseCallBack)
			end

		end
	end
end

return TaskStart