--[[当前任务对象]]
local TaskData = class("TaskData")
local curTask = nil

function TaskData.setCurTask(task)
	curTask = task
end

function TaskData.getCurTask()
	return clone(curTask)
end

return TaskData