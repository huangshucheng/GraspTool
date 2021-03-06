--[[任务启动脚本： 以保存的请求数据为主导，做请求]] 
local FindData 		= require("resources.luaScript.data.FindData")
local CSFun 		= require("resources.luaScript.util.CSFun")
local StringUtils 	= require("resources.luaScript.util.StringUtils")
local TaskData 		= require("resources.luaScript.data.TaskData")
local Sound 		= require("resources.luaScript.util.Sound")
local TaskList 		= require("resources.luaScript.config.TaskList")
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local TaskStartBase = require("resources.luaScript.task.base.TaskStart")

local TaskStartEx = class("TaskStart",TaskStartBase)
local SELECT_CK_INDEX = {} --选中的CK下标

--[[
执行一个httpTask 请求
httpTask: HttpTask对象
requestInfo: 全部请求信息,包括请求头，请求体，等等
tokenIndex: 当前token下标
isConitnue: 是否是连续token，如果是手动选择的token就不是连续的,否则就是连续的
]]
function TaskStartEx.doRequest(httpTask, requestInfo, tokenIndex, isContinue)
	if not httpTask or not requestInfo or not tokenIndex then return end
	local tmpHttpTask = clone(httpTask)
	tmpHttpTask:initWithLocalSaveData(requestInfo)
	tmpHttpTask:setUserData(tokenIndex)
	tmpHttpTask:setIsContinue(isContinue)
	tmpHttpTask:addCallback(TaskStartEx.onResponseCallBack)
	TaskData.getCurTask():onBeforeRequest(tmpHttpTask) --请求之前预留接口,方便操作请求参数
	tmpHttpTask:start()
end

--从头开始执行任务，一个个执行
function TaskStartEx.start()
	local tmpCurTask = TaskData.getCurTask()
	if not tmpCurTask then
		print(CSFun.Utf8ToDefault("还没指定任务!"))
		return
	end
	local tokenIndex = 1
	local selectToken = FindData:getInstance():getTop()
	if selectToken then
		local localSaveUrl = selectToken["ReqUrl"]
		local curTask = FindData:getInstance():findTaskConfigByReqUrl(localSaveUrl)
		if curTask then
			TaskStartEx.doRequest(curTask, selectToken, tokenIndex, true)
		else
			print(CSFun.Utf8ToDefault("error: 未配置TASK_LIST_URL_CONFIG任务URL!>> \n" .. tostring(localSaveUrl)))
		end
	end
end

--执行最后一个任务
function TaskStartEx.startEnd()
	local tmpCurTask = TaskData.getCurTask()
	if not tmpCurTask then
		print(CSFun.Utf8ToDefault("还没指定任务!"))
		return
	end
	local tokenIndex = FindData:getInstance():getTokenCount()
	local selectToken = FindData:getInstance():getEnd()
	if selectToken then
		local localSaveUrl = selectToken["ReqUrl"]
		local curTask = FindData:getInstance():findTaskConfigByReqUrl(localSaveUrl)
		if curTask then
			TaskStartEx.doRequest(curTask, selectToken, tokenIndex, false)
		else
			print(CSFun.Utf8ToDefault("error: 未配置TASK_LIST_URL_CONFIG任务URL!>> \n" .. tostring(localSaveUrl)))
		end
	end
end

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

	tmpCurTask:onResponse(httpRes, taskCur)
	if taskCur:getCurCount() >= taskCur:getReqCount() then --需要切换任务
		local date = os.date("%H:%M:%S")
		local outLogStr = date .. " [" .. tmpCurTask:getTitle() .. ">>" ..taskCur:getUserData() .. "]>> " .. "完成!!!!!!!!!!!!!!!!!!!!!!!!!"
		CSFun.LogOut(CSFun.Utf8ToDefault(outLogStr))
		Sound.playGetAward()
		taskCur:setState(taskCur.GRASP_STATE.FINISH)
		local tokenList = FindData:getInstance():getTokenList()
        --已设置了当前任务做完后，不再执行下个token任务, 但是可以执行指定token任务
		if taskCur:getIsContinue() then
            --没找到下一个任务，就换一个token执行任务
			local userData = taskCur:getUserData()
			if not userData or userData == "" or not tonumber(userData) then return end
			local nextTokenIndex = tonumber(userData) + 1
			local nextToken = tokenList[nextTokenIndex]
			if nextToken then
				local localSaveUrl = nextToken["ReqUrl"]
				local taskNext = FindData:getInstance():findTaskConfigByReqUrl(localSaveUrl)
				if taskNext then
					TaskStartEx.doRequest(taskNext, nextToken, nextTokenIndex, taskCur:getIsContinue())
					tmpCurTask:onNextTask(taskNext, taskCur)
				else
					print(CSFun.Utf8ToDefault("error: 未配置TASK_LIST_URL_CONFIG任务URL!>> \n" .. tostring(localSaveUrl)))
				end
			else
				if tmpCurTask:isRepeatForever() then
					TaskStartEx.start()
				end
			end
		else
			local curTokenIndex = table.indexof(SELECT_CK_INDEX,taskCur:getUserData())
			if curTokenIndex then
				local nextTokenIndex = curTokenIndex + 1
				local nextToken = tokenList[SELECT_CK_INDEX[nextTokenIndex]]
				if nextToken then
					local localSaveUrl = nextToken["ReqUrl"]
					local taskNext = FindData:getInstance():findTaskConfigByReqUrl(localSaveUrl)
					if taskNext then
						TaskStartEx.doRequest(taskNext, nextToken, SELECT_CK_INDEX[nextTokenIndex], taskCur:getIsContinue())
						tmpCurTask:onNextTask(taskNext, taskCur)
					else
						print(CSFun.Utf8ToDefault("error: 未配置TASK_LIST_URL_CONFIG任务URL!>> \n" .. tostring(localSaveUrl)))
					end
				else
					if tmpCurTask:isRepeatForever() then
						TaskStartEx.doSelectTask()
					end					
				end
			end
		end
	end
end

--选中了当前活动的某一部分CK
function TaskStartEx.doSelectTask()
	local selTable = CShapListView.ListView_get_select_index()
	SELECT_CK_INDEX = clone(selTable)
	if selTable and next(selTable) then
		-- dump(selTable,CSFun.Utf8ToDefault("当前选中: "))
		local tmpCurTask = TaskData.getCurTask()
		if not tmpCurTask then
			print(CSFun.Utf8ToDefault("还没指定任务!"))
			return
		end
		local tokenList = FindData:getInstance():getTokenList()
		local tokenIndex = selTable[1] or -1
		local selectToken = tokenList[tokenIndex]
		if selectToken then
			local localSaveUrl = selectToken["ReqUrl"]
			local curTask = FindData:getInstance():findTaskConfigByReqUrl(localSaveUrl)
			-- print("findUrl: " .. tostring(localSaveUrl))
			if curTask then
				TaskStartEx.doRequest(curTask, selectToken, tokenIndex, false)
			else
				print(CSFun.Utf8ToDefault("error: 未配置TASK_LIST_URL_CONFIG任务URL!>> \n" .. tostring(localSaveUrl)))
			end
		end
	else
		print(CSFun.Utf8ToDefault("没选中任何一个CK!"))
	end
end

return TaskStartEx