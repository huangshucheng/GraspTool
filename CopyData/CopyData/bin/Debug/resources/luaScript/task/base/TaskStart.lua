--[[任务启动脚本]]

local Define = require("resources.luaScript.config.Define")
local HttpTask = require("resources.luaScript.task.base.HttpTask")
local FindData = require("resources.luaScript.data.FindData")
local CSFun = require("resources.luaScript.util.CSFun")
local StringUtils = require("resources.luaScript.util.StringUtils")
local TaskData = require("resources.luaScript.data.TaskData")
local Sound = require("resources.luaScript.util.Sound")

local TaskStart = class("TaskStart")

function TaskStart.start()
	local index = 1
	local topToken = FindData:getInstance():getTop()
	if topToken then
		local taskListTop = TaskData.getCurTask():getTop()
		taskListTop:setUserData(index)
		taskListTop:addHeader(topToken)
		taskListTop:start(TaskStart.onResponseCallBack)
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
			-- Sound.playFinishTaskSound()
			Sound.playGetAward()
            --没找到下一个任务，就换一个token执行任务
			local tokenList = FindData:getInstance():getTokenList()
			local nextIndex = tonumber(taskCur:getUserData()) + 1
			local nextToken = tokenList[nextIndex]
			if nextToken then
				local taskListTop = TaskData.getCurTask():getTop()
				taskListTop:setUserData(nextIndex)
				taskListTop:addHeader(nextToken)
				TaskData.getCurTask():onNextTask(taskListTop, taskCur)
				taskListTop:start(TaskStart.onResponseCallBack)
			end
		end
	end
end

return TaskStart