--[[任务启动脚本： 以保存的请求数据为主导，做请求]] 
local FindData 		= require("resources.luaScript.data.FindData")
local CSFun 		= require("resources.luaScript.util.CSFun")
local StringUtils 	= require("resources.luaScript.util.StringUtils")
local TaskData 		= require("resources.luaScript.data.TaskData")
local Sound 		= require("resources.luaScript.util.Sound")
local Define 		= require("resources.luaScript.config.Define")
local TaskList 		= require("resources.luaScript.config.TaskList")
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local TaskStartBase = require("resources.luaScript.task.base.TaskStart")
local LuaCallCShapUI = require("resources.luaScript.uiLogic.LuaCallCShapUI")

local TaskStartEx = class("TaskStart",TaskStartBase)
local SELECT_CK_INDEX = {} --选中的CK下标

-- 根据任务的Url，找到任务配置（以保存的请求数据为主导，找任务的配置）
function TaskStartEx.findTaskConfigByReqUrl(reqUrl)
	local tmpCurTask = TaskData.getCurTask()
	if not tmpCurTask then
		print(CSFun.Utf8ToDefault("还没指定任务!"))
		return
	end
	local taskList = tmpCurTask:getTaskList()
	for _, task in ipairs(taskList) do
		local taskUrl = task:getUrl()
		if taskUrl and taskUrl ~= "" and CSFun.IsSubString(taskUrl, reqUrl) then
			return task
			break
		end
	end
end
--[[
--从头开始执行任务，一个个执行
function TaskStartEx.start()
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
		if tmpCurTask:isUseFullReqData() then
			taskListTop:initWithLocalSaveData(topToken)
		else
			taskListTop:addHeader(topToken)
		end
		taskListTop:addCallback(TaskStartEx.onResponseCallBack)
		taskListTop:start()
	end
end
]]
--执行最后一个任务
--[[
function TaskStartEx.startEnd()
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
		if tmpCurTask:isUseFullReqData() then
			taskListTop:initWithLocalSaveData(lastToken)
		else
			taskListTop:addHeader(lastToken)	
		end
		taskListTop:addCallback(TaskStartEx.onResponseCallBack)
		taskListTop:start()
	end
end
]]

--任务返回
function TaskStartEx.onResponseCallBack(httpRes, taskCur)
	--第一个任务执行次数到了，执行下一个任务
	local tmpCurTask = TaskData.getCurTask()
	if not tmpCurTask then return end
	local date = os.date("%H:%M:%S")
	httpRes = StringUtils.nullOrEmpty(httpRes) and CSFun.Utf8ToDefault("空~") or httpRes
	local tmpLogStr = CSFun.Utf8ToDefault("[" .. tmpCurTask:getTitle() .. ">>" .. taskCur:getUserData() .. "]>> " .. taskCur:getTaskName() .. " ,返回:  ")
	print(date .. " " .. tmpLogStr .. tostring(httpRes))

	if TaskStartEx.isStop then --停止任务
		return
	end

	tmpCurTask = clone(tmpCurTask)
	tmpCurTask:onResponse(httpRes, taskCur)
	if taskCur:getCurCount() >= taskCur:getReqCount() then --需要切换任务
		local allTaskList = tmpCurTask:getTaskList()
		local taskNext = allTaskList[taskCur:getCurTaskIndex()+1]
		if taskNext then 
			--找到了下一个任务，继续用当前用户的token执行下一个任务
			taskNext:setUserData(taskCur:getUserData())
			if tmpCurTask:isUseFullReqData() then
				taskNext:initWithLocalSaveData(taskCur:getHeader())
			else
				taskNext:addHeader(taskCur:getHeader())	
			end
			taskNext:setIsContinue(taskCur:getIsContinue())
			tmpCurTask:onNextTask(taskNext, taskCur)
			taskNext:addCallback(TaskStartEx.onResponseCallBack)
			taskNext:start()
		else --需要切换token
			local date = os.date("%H:%M:%S")
			local outLogStr = date .. " [" .. tmpCurTask:getTitle() .. ">>" ..taskCur:getUserData() .. "]>> " .. "完成!!!!!!!!!!!!!!!!!!!!!!!!!"
			CSFun.LogOut(CSFun.Utf8ToDefault(outLogStr))
			Sound.playGetAward()
			taskCur:setState(taskCur.GRASP_STATE.FINISH)
			local tokenList = FindData:getInstance():getTokenList()
            --已设置了当前任务做完后，不再执行下个token任务, 但是可以执行指定token任务
			if not taskCur:getIsContinue() then 
				local curTokenIndex = table.indexof(SELECT_CK_INDEX,taskCur:getUserData())
				if curTokenIndex then
					local nextTokenIndex = curTokenIndex + 1
					local token = tokenList[SELECT_CK_INDEX[nextTokenIndex]]
					if token then
						local taskListTop = tmpCurTask:getTop()
						taskListTop:setUserData(SELECT_CK_INDEX[nextTokenIndex])
						taskListTop:setIsContinue(taskCur:getIsContinue()) --只执行当前token任务，不再继续执行下一个token任务
						if tmpCurTask:isUseFullReqData() then
							taskListTop:initWithLocalSaveData(token)
						else
							taskListTop:addHeader(token)	
						end
						taskListTop:addCallback(TaskStartEx.onResponseCallBack)
						taskListTop:start()
					end
				end
			else
	            --没找到下一个任务，就换一个token执行任务
				local userData = taskCur:getUserData()
				if not userData or userData == "" or not tonumber(userData) then return end
				local nextTokenIndex = tonumber(userData) + 1
				local nextToken = tokenList[nextTokenIndex]
				if nextToken then
					local taskListTop = tmpCurTask:getTop()
					taskListTop:setUserData(nextTokenIndex)
					taskListTop:setIsContinue(taskCur:getIsContinue())
					if tmpCurTask:isUseFullReqData() then
						taskListTop:initWithLocalSaveData(nextToken)
					else
						taskListTop:addHeader(nextToken)
					end
					tmpCurTask:onNextTask(taskListTop, taskCur)
					taskListTop:addCallback(TaskStartEx.onResponseCallBack)
					taskListTop:start()
				end
			end
		end
	end
end
--[[
--选中了当前活动的某一部分CK
function TaskStartEx.doSelectAction()
	local selTable = CShapListView.ListView_get_select_index()
	SELECT_CK_INDEX = clone(selTable)
	if selTable and next(selTable) then
		dump(selTable,CSFun.Utf8ToDefault("当前选中: "))
		local tmpCurTask = TaskData.getCurTask()
		if not tmpCurTask then
			print(CSFun.Utf8ToDefault("还没指定任务!"))
			return
		end
		tmpCurTask = clone(tmpCurTask)
		local tokenList = FindData:getInstance():getTokenList()
		local tokenIndex = selTable[1] or -1
		local token = tokenList[tokenIndex]
		if token then
			local taskListTop = tmpCurTask:getTop()
			taskListTop:setUserData(tokenIndex)
			taskListTop:setIsContinue(false) --只执行当前token任务，不再继续执行下一个token任务
			if tmpCurTask:isUseFullReqData() then
				taskListTop:initWithLocalSaveData(token)
			else
				taskListTop:addHeader(token)	
			end
			taskListTop:addCallback(TaskStartEx.onResponseCallBack)
			taskListTop:start()
		end
	else
		print(CSFun.Utf8ToDefault("没选中任何一个CK!"))
	end
end
]]

return TaskStartEx