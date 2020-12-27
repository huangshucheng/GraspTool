--[[ui调用Lua脚本]]
local UIConfigData = require("resources.luaScript.data.UIConfigData")
local TaskStart = require("resources.luaScript.task.base.TaskStart")
local Define = require("resources.luaScript.config.Define")

--点击选择活动
function onSelectActivityFromList(index)
	TaskStart.onChangeActivity(index)
end

--点击开始做任务
function onClickStartDoAct()
	TaskStart.start()
end

--停止做任务
function onClickStopDoAct()
	TaskStart.stop()
end

--修改了延迟时间
function onDelayTimeChanged(time)
	print("onDelayTimeChanged>> " .. tostring(time))
	UIConfigData.setReqDelayTime(tonumber(time))
end

--修改了卡包次数
function onReqTimeChanged(count)
	print("onReqTimeChanged>> " .. tostring(count))
	UIConfigData.setReqPktCount(tonumber(count))
end

--修改了自动抓CK
function onSelectAutoGraspCk(isAutoGrasp)
	print("onSelectAutoGraspCk>> " .. tostring(isAutoGrasp))
	UIConfigData.setIsAutoGraspCK(isAutoGrasp)
end

--修改了自动做任务
function onSelectAutoDoAct(isAutoDoAct)
	print("onSelectAutoDoAct>> " .. tostring(isAutoDoAct))
	UIConfigData.setIsAutoDoAction(isAutoDoAct)
end

--修改了是否播放声音
function onSelectPlayCound(isPlay)
	print("onSelectPlayCound>> " .. tostring(isPlay))
	UIConfigData.setIsOpenTipSound(isPlay)
end

function onSelectShowOutLog(isShow)
	print("onSelectShowOutLog>> " .. tostring(isShow))
	UIConfigData.setIsShowOutLog(isShow)
end

--点击生成二维码图片
function onClickGenQRCode()
	local LuaCallCShapUI = require("resources.luaScript.uiLogic.LuaCallCShapUI")
	local qrCodeStr = LuaCallCShapUI.GetQRCodeString()
	local qrCodeUrl = Define.QR_CODE_STR .. (qrCodeStr or "")
	LuaCallCShapUI.ShowQRCode(qrCodeUrl, "GET", function(retStr)
		if retStr ~= "SUCCESS" then
			print(tostring(retStr))
		end
	end)
end