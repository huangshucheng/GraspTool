--[[当前任务对象]]
local TaskData = class("TaskData")
local curTaskObj = nil --当前任务对象

--设置当前任务对象
function TaskData.setCurTask(taskObj)
	curTaskObj = taskObj
	TaskData.onChangeTaskData()
end

--获取当前任务对象
function TaskData.getCurTask()
	return curTaskObj
end

--切换了任务对象
function TaskData.onChangeTaskData()
	local FindData = require("resources.luaScript.data.FindData")
	local CSFun = require("resources.luaScript.util.CSFun")
	CSFun.ClearTokenLog()
	FindData:getInstance():readLocalFileToken()--加载本地token缓存
end

--加载本地所有活动列表, 到下拉列表UI中
function TaskData.loadTaskList()
	local TaskList = require("resources.luaScript.config.TaskList")
	local LuaCallCShapUI = require("resources.luaScript.uiLogic.LuaCallCShapUI")
	local ActMapTable = TaskList.ActMapTable or {}
	local tmpActTable = {}
	for i,v in ipairs(ActMapTable) do
		table.insert(tmpActTable, LuaCallCShapUI.Utf8ToDefault(v.name))
	end
	-- dump(tmpActTable)
	if next(tmpActTable) then
		LuaCallCShapUI.AddActivityToList(tmpActTable)
	end
end

return TaskData