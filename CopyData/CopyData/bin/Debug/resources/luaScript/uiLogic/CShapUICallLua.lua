--[[ui调用Lua脚本]]
local UIConfigData = require("resources.luaScript.data.UIConfigData")
local TaskStart = require("resources.luaScript.task.base.TaskStart")

--点击选择活动
function onSelectActivityFromList(index)
	local TaskList = require("resources.luaScript.config.TaskList")
	local TaskData = require("resources.luaScript.data.TaskData")
	local LuaCallCShapUI = require("resources.luaScript.uiLogic.LuaCallCShapUI")

	local ActMapTable = TaskList.ActMapTable or {}

	if ActMapTable and ActMapTable[index] then
		local actName = ActMapTable[index].name or ""
		local script = ActMapTable[index].script or ""
		-- print("index>> " .. tostring(index) .. " ,name>> " .. tostring(LuaCallCShapUI.Utf8ToDefault(actName)) .. "  ,script: " .. tostring(script))
		local curTaskObj = nil
		local changeTaskFunc = function()
			local CurTask = require(script)
			if CurTask then
				curTaskObj = CurTask.new()
			end
		end

		local ok, msg = pcall(changeTaskFunc)
		if ok then
			local printStr = LuaCallCShapUI.Utf8ToDefault("加载任务成功! ,[" .. actName .."] ,脚本: ") .. tostring(script)
			print(printStr)
			if curTaskObj then
				TaskData.setCurTask(curTaskObj) --设置当前执行的任务对象
			end
		else
			print(tostring(LuaCallCShapUI.Utf8ToDefault("加载任务失败! ,[" .. actName .. "]  \n")) .. tostring(msg))
		end
	end
end

--点击开始做任务
function onClickStartDoAct()
	print("onClickStartDoAct")
	TaskStart.start()
end

--停止做任务
function onClickStopDoAct()
	print("onClickStopDoAct")
	TaskStart.stop()
end

--修改了延迟时间
function onDelayTimeChanged(time)
	print("onDelayTimeChanged  " .. tostring(time))
	UIConfigData.setReqDelayTime(tonumber(time))
end

--修改了卡包次数
function onReqTimeChanged(count)
	print("onReqTimeChanged  " .. tostring(count))
	UIConfigData.setReqPktCount(tonumber(count))
end

--修改了自动抓CK
function onSelectAutoGraspCk(isAutoGrasp)
	print("onSelectAutoGraspCk  " .. tostring(isAutoGrasp))
	UIConfigData.setIsAutoGraspCK(isAutoGrasp)
end

--修改了自动做任务
function onSelectAutoDoAct(isAutoDoAct)
	print("onSelectAutoDoAct  " .. tostring(isAutoDoAct))
	UIConfigData.setIsAutoDoAction(isAutoDoAct)
end

--修改了是否播放声音
function onSelectPlayCound(isPlay)
	print("onSelectPlayCound  " .. tostring(isPlay))
	UIConfigData.setIsOpenTipSound(isPlay)
end