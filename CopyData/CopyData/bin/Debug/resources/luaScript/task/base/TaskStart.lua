--[[任务启动脚本]]
local FindData 		= require("resources.luaScript.data.FindData")
local CSFun 		= require("resources.luaScript.util.CSFun")
local StringUtils 	= require("resources.luaScript.util.StringUtils")
local TaskData 		= require("resources.luaScript.data.TaskData")
local Sound 		= require("resources.luaScript.util.Sound")
local Define 		= require("resources.luaScript.config.Define")
local TaskList 		= require("resources.luaScript.config.TaskList")
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local LuaCallCShapUI = require("resources.luaScript.uiLogic.LuaCallCShapUI")

local TaskStart = class("TaskStart")
local SELECT_CK_INDEX = {} --选中的CK下标

--[[
执行一个httpTask 请求
httpTask: HttpTask对象
requestInfo: 请求信息
tokenIndex: 当前token下标
isConitnue: 是否是连续token，如果是手动选择的token就不是连续的,否则就是连续的
]]
function TaskStart.doRequest(httpTask, requestInfo, tokenIndex, isContinue)
	if not httpTask or not requestInfo or not tokenIndex then return end
	-- dump(requestInfo,"requestInfo")
	local tmpHttpTask = clone(httpTask)
	tmpHttpTask:initWithLocalSaveData(requestInfo)
	tmpHttpTask:setUserData(tokenIndex)
	tmpHttpTask:setIsContinue(isContinue)
	tmpHttpTask:addCallback(TaskStart.onResponseCallBack)
	TaskData.getCurTask():onBeforeRequest(tmpHttpTask) --请求之前预留接口,方便操作请求参数
	tmpHttpTask:start()
end

--从头开始执行任务，一个个执行
function TaskStart.start()
	local tmpCurTask = TaskData.getCurTask()
	if not tmpCurTask then
		print(CSFun.Utf8ToDefault("还没指定任务!"))
		return
	end
	local tokenIndex = 1
	TaskStart.doRequest(tmpCurTask:getTop(), FindData:getInstance():getTop(), tokenIndex, true)
end

--执行最后一个任务
function TaskStart.startEnd()
	local tmpCurTask = TaskData.getCurTask()
	if not tmpCurTask then
		print(CSFun.Utf8ToDefault("还没指定任务!"))
		return
	end
	local tokenIndex = FindData:getInstance():getTokenCount()
	TaskStart.doRequest(tmpCurTask:getTop(), FindData:getInstance():getEnd(), tokenIndex, false)
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
	--第一个任务执行次数到了，执行下一个任务
	local tmpCurTask = TaskData.getCurTask()
	if not tmpCurTask then return end
	local date = os.date("%H:%M:%S")
	httpRes = StringUtils.nullOrEmpty(httpRes) and CSFun.Utf8ToDefault("空~") or httpRes
	local tmpLogStr = CSFun.Utf8ToDefault("[" .. tmpCurTask:getTitle() .. ">>" .. taskCur:getUserData() .. "]>> " .. taskCur:getTaskName() .. " ,返回:  ")
	print(date .. " " .. tmpLogStr .. tostring(httpRes))

	if TaskStart.isStop then --停止任务
		return
	end

	tmpCurTask:onResponse(httpRes, taskCur)
	if taskCur:getCurCount() >= taskCur:getReqCount() then --需要切换任务
		local allTaskList = tmpCurTask:getTaskList()
		local httpTaskNext = allTaskList[taskCur:getCurTaskIndex()+1]
		if httpTaskNext then 
			--找到了下一个任务，继续用当前用户的token执行下一个任务
			TaskStart.doRequest(httpTaskNext, taskCur:getHeader(), taskCur:getUserData(), taskCur:getIsContinue())
			tmpCurTask:onNextTask(httpTaskNext, taskCur)
		else --需要切换token,又从第一个task开始做
			local date = os.date("%H:%M:%S")
			local outLogStr = date .. " [" .. tmpCurTask:getTitle() .. ">>" ..taskCur:getUserData() .. "]>> " .. "完成!!!!!!!!!!!!!!!!!!!!!!!!!"
			CSFun.LogOut(CSFun.Utf8ToDefault(outLogStr))
			Sound.playGetAward()
			taskCur:setState(taskCur.GRASP_STATE.FINISH)
			local tokenList = FindData:getInstance():getTokenList()
            
			if taskCur:getIsContinue() then 
				--没找到下一个任务，就换一个token执行任务
				local userData = taskCur:getUserData()
				if not userData or userData == "" or not tonumber(userData) then return end
				local nextTokenIndex = tonumber(userData) + 1
				local nextToken = tokenList[nextTokenIndex]
				if nextToken then
					TaskStart.doRequest(tmpCurTask:getTop(), nextToken, nextTokenIndex, taskCur:getIsContinue())
					tmpCurTask:onNextTask(tmpCurTask:getTop(), taskCur)
				else
					--token走完了，如果是永久执行的任务，又从第一个token开始执行
					if tmpCurTask:isRepeatForever() then
						TaskStart.start()
					end
				end
			else
				--设置了当前任务做完后，不再执行下个token任务, 但是可以执行指定token任务
				local curTokenIndex = table.indexof(SELECT_CK_INDEX,taskCur:getUserData())
				if curTokenIndex then
					local nextTokenIndex = curTokenIndex + 1
					local nextToken = tokenList[SELECT_CK_INDEX[nextTokenIndex]]
					if nextToken then
						TaskStart.doRequest(tmpCurTask:getTop(), nextToken, SELECT_CK_INDEX[nextTokenIndex], taskCur:getIsContinue())
						tmpCurTask:onNextTask(tmpCurTask:getTop(), taskCur)
					else
					    --token走完了，如果是永久执行的任务，又从选中的第一个token开始执行
					    if tmpCurTask:isRepeatForever() then
					    	TaskStart.doSelectTask()
					    end
					end
				end
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
		local ok, cur_task_obj = pcall(function()
			if script and script ~= "" then
		 		return require(script).new(activityTable)
			end
	 	end)
		if ok then
			local tmpScript = StringUtils.nullOrEmpty(script) and CSFun.Utf8ToDefault("暂无") or script
			local printStr = CSFun.Utf8ToDefault("加载活动成功! [" .. actName .."] ,活动脚本>> ") .. tostring(tmpScript)
			print(printStr)
			TaskData.setCurTask(cur_task_obj) --设置当前执行的任务对象
		else
			print(tostring(CSFun.Utf8ToDefault("加载活动失败! ,[" .. actName .. "]  \n")) .. tostring(cur_task_obj))
			TaskData.setCurTask(nil)
		end
		TaskStart.onChangeTaskData(activityTable)
	end
end

--切换了任务对象
function TaskStart.onChangeTaskData(activityTable)
	activityTable = activityTable or {}

	--清理token显示列表
	CShapListView.ListView_clear()

	--加载本地token缓存
	FindData:getInstance():readLocalFileToken()

	--清理二维码
	LuaCallCShapUI.ClearQRCode()
	LuaCallCShapUI.SetQRCodeString("")
	LuaCallCShapUI.SetUserInputText("")

	local curTaskObj = TaskData.getCurTask()
	if curTaskObj then
		local curKaBaoCount = curTaskObj:getDefaultKaBaoCount()
		LuaCallCShapUI.SetKaBaoCount(curKaBaoCount)
		-- print("curKaBaoCount: " .. tostring(curKaBaoCount))
		--是否自动做任务
		local isAutoDoAction = curTaskObj:isAutoDoAction()
		LuaCallCShapUI.SetAutoDoAction(isAutoDoAction)
		-- print("isAutoDoAction: " .. tostring(isAutoDoAction))

		local defaultInputText = curTaskObj:getDefaultInputText()
		LuaCallCShapUI.SetUserInputText(defaultInputText)
	end

	--切换二维码
	local qrCodeStr = activityTable.qrcode or ""
	local qrCodeUrl = qrCodeStr
	if not StringUtils.checkWithHttp(qrCodeStr) then
		qrCodeUrl = Define.QR_CODE_STR .. qrCodeStr
		LuaCallCShapUI.SetQRCodeString(qrCodeStr)
	end
	if qrCodeStr == "" then
		print(CSFun.Utf8ToDefault("暂无二维码~"))
	else
		LuaCallCShapUI.ShowQRCode(qrCodeUrl, "GET", function(retStr)
			if retStr ~= "SUCCESS" then
				print(CSFun.Utf8ToDefault("加载二维码失败了! ") .. tostring(retStr))
			end
		end)
	end

	local linkUrl = activityTable.linkUrl or ""
	local descStr = activityTable.desc or ""
	LuaCallCShapUI.SetActivityLink(linkUrl)
	LuaCallCShapUI.SetActivityDesc(CSFun.Utf8ToDefault(descStr))

	--停下所有定时器
	local TimerManager = require("resources.luaScript.manager.TimerManager")
	TimerManager.stopAllTimer()

end

--选中了当前活动的某一部分CK
function TaskStart.doSelectTask()
	local selTable = CShapListView.ListView_get_select_index()
	SELECT_CK_INDEX = clone(selTable)
	if selTable and next(selTable) then
		dump(selTable,CSFun.Utf8ToDefault("当前选中: "))
		local tmpCurTask = TaskData.getCurTask()
		if not tmpCurTask then
			print(CSFun.Utf8ToDefault("还没指定任务!"))
			return
		end
		local tokenList = FindData:getInstance():getTokenList()
		local tokenIndex = selTable[1] or -1
		local token = tokenList[tokenIndex]
		TaskStart.doRequest(tmpCurTask:getTop(), token, tokenIndex, false)
	else
		print(CSFun.Utf8ToDefault("没选中任何一个CK!"))
	end
end

return TaskStart