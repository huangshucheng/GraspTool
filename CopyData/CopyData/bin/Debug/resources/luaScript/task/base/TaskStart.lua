--[[任务启动脚本]]

local FindData = require("resources.luaScript.data.FindData")
local CSFun = require("resources.luaScript.util.CSFun")
local StringUtils = require("resources.luaScript.util.StringUtils")
local TaskData = require("resources.luaScript.data.TaskData")
local Sound = require("resources.luaScript.util.Sound")
local UIConfigData = require("resources.luaScript.data.UIConfigData")

local TaskStart = class("TaskStart")

--从头开始执行任务，一个个执行
function TaskStart.start()
	local tmpCurTask = TaskData.getCurTask()
	if not tmpCurTask then
		print(CSFun.Utf8ToDefault("还没指定任务!"))
		return
	end
	tmpCurTask = clone(tmpCurTask)
	local tokenIndex = 1
	local topToken = FindData:getInstance():getTop()
	if topToken then
		local taskListTop = tmpCurTask:getTop()
		taskListTop:setUserData(tokenIndex)
		taskListTop:addHeader(topToken)
		taskListTop:addCallback(TaskStart.onResponseCallBack)
		taskListTop:start()
	end
end

--执行最后一个任务
function TaskStart.startEnd()
	local tmpCurTask = TaskData.getCurTask()
	if not tmpCurTask then
		print(CSFun.Utf8ToDefault("还没指定任务!"))
		return
	end
	tmpCurTask = clone(tmpCurTask)
	local tokenIndex = FindData:getInstance():getTokenCount()
	local lastToken = FindData:getInstance():getEnd()
	if lastToken then
		local taskListTop = tmpCurTask:getTop()
		taskListTop:setUserData(tokenIndex)
		taskListTop:addHeader(lastToken)
		taskListTop:addCallback(TaskStart.onResponseCallBack)
		taskListTop:start()
	end
end

--停止任务
function TaskStart.stop()
	TaskStart.isStop = true
	CSFun.SetDelayTime(2.0, function()
		TaskStart.isStop = false
	end)
end

--任务返回
function TaskStart.onResponseCallBack(httpRes, taskCur)
	httpRes = StringUtils.nullOrEmpty(httpRes) and " empty" or httpRes
	local tmpLogStr = CSFun.Utf8ToDefault("[" .. taskCur:getUserData() .. "]  任务>> " .. taskCur:getTaskName() .. "   ,返回>> ") 
	print(tmpLogStr .. tostring(httpRes))

	if TaskStart.isStop then --停止任务
		return
	end

	-- 以配置为准，否则用 界面上的配置
	local delayTime = tonumber(UIConfigData.getReqDelayTime()) --延迟时间
	local redPktCount = tonumber(UIConfigData.getReqPktCount()) --卡包次数

	-- print(">>>delayTime>> " .. tostring(delayTime))	
	-- print(">>>redPktCount>> " .. tostring(redPktCount))	
	--第一个任务执行次数到了，执行 下一个任务
	local tmpCurTask = TaskData.getCurTask()
	if not tmpCurTask then 
		return
	end

	tmpCurTask = clone(tmpCurTask)
	if taskCur:getCurCount() >= taskCur:getReqCount() then
		local allTaskList = tmpCurTask:getTaskList()
		local taskNext = allTaskList[taskCur:getCurTaskIndex()+1]
		if taskNext then 
			--找到了下一个任务，继续用当前用户的token执行下一个任务
			taskNext:setUserData(taskCur:getUserData())
			taskNext:addHeader(taskCur:getHeader())
			tmpCurTask:onNextTask(taskNext, taskCur)
			taskNext:addCallback(TaskStart.onResponseCallBack)

			--使用UI界面的延迟时间，否则用配置的延迟时间
			if delayTime and delayTime > 0 then
				taskNext:setDelay(delayTime)
			end
			--用UI界面的卡包次数，否则用配置的卡包次数
			if taskNext:getIsRedPacket() and redPktCount and redPktCount > 0 then
				taskNext:setReqCount(redPktCount)
			end
			taskNext:start()
		else
			Sound.playGetAward()
            --没找到下一个任务，就换一个token执行任务
			local tokenList = FindData:getInstance():getTokenList()
			local nextTokenIndex = tonumber(taskCur:getUserData()) + 1
			local nextToken = tokenList[nextTokenIndex]
			if nextToken then
				local taskListTop = tmpCurTask:getTop()
				taskListTop:setUserData(nextTokenIndex)
				taskListTop:addHeader(nextToken)
				tmpCurTask:onNextTask(taskListTop, taskCur)
				taskListTop:addCallback(TaskStart.onResponseCallBack)
				if delayTime and delayTime > 0 then
					taskListTop:setDelay(delayTime)
				end
				if taskListTop:getIsRedPacket() and redPktCount and redPktCount > 0 then
					taskListTop:setReqCount(redPktCount)
				end
				taskListTop:start()
			end
		end
	end
end

return TaskStart