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
		local task_list = TaskData.getCurTask():getTop()
		task_list:setUserData(index)
		task_list:addHeader(topToken)
		task_list:start(TaskStart.onResponseCallBack)
	end
end

function TaskStart.onResponseCallBack(httpRes, task_cur)
	httpRes = StringUtils.nullOrEmpty(httpRes) and " empty" or httpRes
	print("hcc>> index>> " .. task_cur:getUserData() .. "  ,name>> " .. task_cur:getTaskName() .. "   ,ret>> ".. tostring(httpRes));

	--第一个任务执行次数到了，执行 下一个任务
	if task_cur:getCurCount() >= task_cur:getReqCount() then
		local all_task_list = TaskData.getCurTask():getTaskList()
		local task_curName = task_cur:getTaskName()
		local isFindNextTask = false
		for key, task_next in pairs(all_task_list) do
			local next_preTaskName = task_next:getPreTaskName()
			if task_curName ~= "" and next_preTaskName ~= "" and next_preTaskName == task_curName then
				isFindNextTask = true
				task_next:setUserData(task_cur:getUserData())
				task_next:addHeader(task_cur:getHeader())
				TaskData.getCurTask():onNextTask(task_next, task_cur)
				task_next:start(TaskStart.onResponseCallBack)--开始执行下一个任务
				break
			end
		end

		--如果没找到下一个任务，就换一个token执行任务
		if not isFindNextTask then
			local tokenList = FindData:getInstance():getTokenList()
			local nextIndex = tonumber(task_cur:getUserData()) + 1
			local nextToken = tokenList[nextIndex]
			if nextToken then
				local task_list = TaskData.getCurTask():getTop()
				task_list:setUserData(nextIndex)
				task_list:addHeader(nextToken)
				TaskData.getCurTask():onNextTask(task_list, task_cur)
				task_list:start(TaskStart.onResponseCallBack)
				--切换下一个token执行任务
			end
		end
	end
end

return TaskStart