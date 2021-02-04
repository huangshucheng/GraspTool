local TaskStartManager = class("TaskStartManager")

local CSFun 		= require("resources.luaScript.util.CSFun")
local TaskData 		= require("resources.luaScript.data.TaskData")
local TaskStart 	= require("resources.luaScript.task.base.TaskStart")
local TaskStartEx 	= require("resources.luaScript.task.base.TaskStartEx")

function TaskStartManager.start()
	local tmpCurTask = TaskData.getCurTask()
	if not tmpCurTask then
		print(CSFun.Utf8ToDefault("还没指定任务!"))
		return
	end
	if tmpCurTask:isUseFullReqData() then
		TaskStartEx.start()
	else
		TaskStart.start()
	end
end

function TaskStartManager.stop()
	TaskStart.stop()
end

function TaskStartManager.startEnd()
	local tmpCurTask = TaskData.getCurTask()
	if not tmpCurTask then
		print(CSFun.Utf8ToDefault("还没指定任务!"))
		return
	end
	if tmpCurTask:isUseFullReqData() then
		TaskStartEx.startEnd()
	else
		TaskStart.startEnd()
	end
end

function TaskStartManager.doSelectTask()
	local tmpCurTask = TaskData.getCurTask()
	if not tmpCurTask then
		print(CSFun.Utf8ToDefault("还没指定任务!"))
		return
	end
	if tmpCurTask:isUseFullReqData() then
		TaskStartEx.doSelectTask()
	else
		TaskStart.doSelectTask()
	end
end

function TaskStartManager.onChangeActivity(index)
	TaskStart.onChangeActivity(index)
end

return TaskStartManager