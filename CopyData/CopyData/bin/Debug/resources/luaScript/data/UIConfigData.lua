--[[UI设置配置]]
local UIConfigData  = {}
local LuaCallCShapUI = require("resources.luaScript.uiLogic.LuaCallCShapUI")

local _isOpenTipSound 	= true -- 是否开启音效
local _isAutoGraspCK 	= true -- 是否自动抓CK
local _isAutoDoAction 	= false -- 是否抓到CK后自动执行任务
local _reqDelayTime 	= 0  -- 所有请求延时时间
local _reqPktCount 		= 1  -- 卡包次数

function UIConfigData.init()
	_isOpenTipSound 	= LuaCallCShapUI.IsOpenTipSound()
	_isAutoGraspCK 		= LuaCallCShapUI.IsAutoGraspCK()
	_isAutoDoAction 	= LuaCallCShapUI.IsAutoDoAction()
	_reqDelayTime 		= LuaCallCShapUI.GetReqDelayTime()
	_reqPktCount 		= LuaCallCShapUI.GetReqPktTime()
	print("-----" .. LuaCallCShapUI.Utf8ToDefault("默认设置") .. "-----")
	print(LuaCallCShapUI.Utf8ToDefault("提示音效: ") .. tostring(_isOpenTipSound))
	print(LuaCallCShapUI.Utf8ToDefault("自动抓CK: ") .. tostring(_isAutoGraspCK))
	print(LuaCallCShapUI.Utf8ToDefault("自动执行: ") .. tostring(_isAutoDoAction))
	print(LuaCallCShapUI.Utf8ToDefault("延迟时间: ") .. tostring(_reqDelayTime))
	print(LuaCallCShapUI.Utf8ToDefault("卡包次数: ") .. tostring(_reqPktCount))
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

function UIConfigData.setReqDelayTime(time)
	_reqDelayTime = time
end

function UIConfigData.getReqDelayTime()
	return _reqDelayTime
end

function UIConfigData.setReqPktCount(count)
	_reqPktCount = count
end

function UIConfigData.getReqPktCount()
	return _reqPktCount
end

return UIConfigData