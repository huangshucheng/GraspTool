--[[任务启动脚本]]

local FindData = require("resources.luaScript.data.FindData")
local CSFun = require("resources.luaScript.util.CSFun")
local StringUtils = require("resources.luaScript.util.StringUtils")
local TaskData = require("resources.luaScript.data.TaskData")
local Sound = require("resources.luaScript.util.Sound")
local UIConfigData = require("resources.luaScript.data.UIConfigData")
local Define = require("resources.luaScript.config.Define")
local LuaCallCShapUI = require("resources.luaScript.uiLogic.LuaCallCShapUI")
local TaskList = require("resources.luaScript.config.TaskList")

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
	-- local date = os.date("%Y-%m-%d %H:%M:%S")
	local date = os.date("%H:%M:%S")
	httpRes = StringUtils.nullOrEmpty(httpRes) and CSFun.Utf8ToDefault("空~") or httpRes
	local tmpLogStr = CSFun.Utf8ToDefault("[" .. taskCur:getUserData() .. "]  任务>> " .. taskCur:getTaskName() .. " ,>> ") 
	print(date .. " " .. tmpLogStr .. tostring(httpRes))

	if TaskStart.isStop then --停止任务
		return
	end

	-- 以配置为准，否则用 界面上的配置
	local delayTime = tonumber(UIConfigData.getReqDelayTime()) --延迟时间
	local redPktCount = tonumber(UIConfigData.getReqPktCount()) --卡包次数

	--第一个任务执行次数到了，执行下一个任务
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
			local outLogStr = "(" ..taskCur:getUserData() .. ")" .. "完成!"
			CSFun.LogToken(CSFun.Utf8ToDefault(outLogStr))
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

-- 切换活动
--活动下标，在TaskList.ActMapTable
function TaskStart.onChangeActivity(actIndex)

	local ActMapTable = TaskList.ActMapTable or {}
	if ActMapTable and ActMapTable[actIndex] then
		local activityTable = ActMapTable[actIndex]
		local actName = activityTable.name or ""
		local script = activityTable.script or ""
		local curTaskObj = nil
		local changeTaskFunc = function()
			local CurTask = require(script)
			if CurTask then
				curTaskObj = CurTask.new()
			end
		end

		local ok, msg = pcall(changeTaskFunc)
		if ok then
			local printStr = CSFun.Utf8ToDefault("加载活动成功! [" .. actName .."] ,活动脚本>> ") .. tostring(script)
			print(printStr)
			if curTaskObj then
				TaskData.setCurTask(curTaskObj) --设置当前执行的任务对象
			end
		else
			print(tostring(CSFun.Utf8ToDefault("加载活动失败! ,[" .. actName .. "]  \n")) .. tostring(msg))
		end
		TaskStart.onChangeTaskData(activityTable)
	end
end

--切换了任务对象
function TaskStart.onChangeTaskData(activityTable)
	if not activityTable then return end

	--清理token日志
	CSFun.ClearTokenLog()
	--加载本地token缓存
	FindData:getInstance():readLocalFileToken()
	--清理二维码
	LuaCallCShapUI.ClearQRCode() 
	--切换二维码
	local qrCodeStr = activityTable.qrcode
	local qrCodeUrl = Define.QR_CODE_STR .. (qrCodeStr or "")
	-- print("qrCodeStr>> " .. qrCodeStr)
	LuaCallCShapUI.ShowQRCode(qrCodeUrl, "GET", function(retStr)
		if retStr ~= "SUCCESS" then
			print(CSFun.Utf8ToDefault("加载二维码失败了! ") .. tostring(retStr))
		end
	end)
end

return TaskStart