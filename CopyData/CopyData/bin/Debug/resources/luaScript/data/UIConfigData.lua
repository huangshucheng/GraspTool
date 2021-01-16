--[[UI设置配置]]
local UIConfigData  = {}

local _isOpenTipSound 	= true -- 是否开启音效
local _isAutoGraspCK 	= true -- 是否自动抓CK
local _isAutoDoAction 	= false -- 是否抓到CK后自动执行任务
local _isShowOutLog 	= true -- 是否显示输出日志
local _reqDelayTime 	= 0  -- 所有请求延时时间

function UIConfigData.init()
	local LuaCallCShapUI = require("resources.luaScript.uiLogic.LuaCallCShapUI")
	_isOpenTipSound 	= LuaCallCShapUI.IsOpenTipSound()
	_isAutoGraspCK 		= LuaCallCShapUI.IsAutoGraspCK()
	_isAutoDoAction 	= LuaCallCShapUI.IsAutoDoAction()
	_isShowOutLog 		= LuaCallCShapUI.IsShowOutLog()
	_reqDelayTime 		= LuaCallCShapUI.GetReqDelayTime()
	print("-----" .. LuaCallCShapUI.Utf8ToDefault("默认设置") .. "-----")
	print(LuaCallCShapUI.Utf8ToDefault("提示音效: ") .. tostring(_isOpenTipSound))
	print(LuaCallCShapUI.Utf8ToDefault("自动抓CK: ") .. tostring(_isAutoGraspCK))
	print(LuaCallCShapUI.Utf8ToDefault("自动执行: ") .. tostring(_isAutoDoAction))
	print(LuaCallCShapUI.Utf8ToDefault("显示日志: ") .. tostring(_isShowOutLog))
	print(LuaCallCShapUI.Utf8ToDefault("延迟时间: ") .. tostring(_reqDelayTime))
	print("-----" .. LuaCallCShapUI.Utf8ToDefault("默认设置") .. "-----\n")
end

function UIConfigData.setIsOpenTipSound(flag)
	_isOpenTipSound = flag
end

function UIConfigData.getIsOpenTipSound()
	return _isOpenTipSound
end

function UIConfigData.setIsAutoGraspCK(flag)
	_isAutoGraspCK = flag
end

function UIConfigData.getIsAutoGraspCK()
	return _isAutoGraspCK
end

function UIConfigData.setIsAutoDoAction(flag)
	_isAutoDoAction = flag
end

function UIConfigData.getIsAutoDoAction()
	return _isAutoDoAction
end

function UIConfigData.getIsShowOutLog()
	return _isShowOutLog
end

function UIConfigData.setIsShowOutLog(flag)
	_isShowOutLog = flag
end

function UIConfigData.setReqDelayTime(time)
	_reqDelayTime = time
end

function UIConfigData.getReqDelayTime()
	return _reqDelayTime
end

return UIConfigData