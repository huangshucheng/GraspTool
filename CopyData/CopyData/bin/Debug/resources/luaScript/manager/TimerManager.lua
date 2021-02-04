-- 定时器ID管理
local TimerManager = class("TimerManager")

local NOT_STOP_TIMER_ID = {} --不用删除的timerID

function TimerManager.addNotStopTimerID(timerID)
	if not table.indexof(NOT_STOP_TIMER_ID, timerID) then
		table.insert(NOT_STOP_TIMER_ID, timerID)
	end
end

function TimerManager.getNotStopTimerID()
	return NOT_STOP_TIMER_ID
end

function TimerManager.stopAllTimer()
	local CSFun = require("resources.luaScript.util.CSFun")
	CSFun.StopAllTimer(NOT_STOP_TIMER_ID)
end

return TimerManager