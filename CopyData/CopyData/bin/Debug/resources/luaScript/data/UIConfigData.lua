--[[UI设置配置]]
local UIConfigData  = {}

local _isOpenTipSound 	= true -- 是否开启音效
local _isAutoGraspCK 	= true -- 是否自动抓CK
local _isAutoDoAction 	= false -- 是否抓到CK后自动执行任务
local _isShowOutLog 	= true -- 是否显示输出日志
local _reqDelayTime 	= 0  -- 所有请求延时时间
local _isShowNetLog 	= false -- 是否显示网络日志
local _proxyIPTable 	= {} --代理IP

function UIConfigData.init()
	local LuaCallCShapUI = require("resources.luaScript.uiLogic.LuaCallCShapUI")
	local Define = require("resources.luaScript.config.Define")
	local StringUtils = require("resources.luaScript.util.StringUtils")
	_isOpenTipSound 	= LuaCallCShapUI.IsOpenTipSound()
	_isAutoGraspCK 		= LuaCallCShapUI.IsAutoGraspCK()
	_isAutoDoAction 	= LuaCallCShapUI.IsAutoDoAction()
	_isShowOutLog 		= LuaCallCShapUI.IsShowOutLog()
	_reqDelayTime 		= LuaCallCShapUI.GetReqDelayTime()
	--[[
	print("-----" .. LuaCallCShapUI.Utf8ToDefault("默认设置") .. "-----")
	print(LuaCallCShapUI.Utf8ToDefault("提示音效: ") .. tostring(_isOpenTipSound))
	print(LuaCallCShapUI.Utf8ToDefault("自动抓CK: ") .. tostring(_isAutoGraspCK))
	print(LuaCallCShapUI.Utf8ToDefault("自动执行: ") .. tostring(_isAutoDoAction))
	print(LuaCallCShapUI.Utf8ToDefault("显示日志: ") .. tostring(_isShowOutLog))
	-- print(LuaCallCShapUI.Utf8ToDefault("延迟时间: ") .. tostring(_reqDelayTime))
	-- print(LuaCallCShapUI.Utf8ToDefault("网络日志: ") .. tostring(_isShowNetLog))
	print("-----" .. LuaCallCShapUI.Utf8ToDefault("默认设置") .. "-----\n")
	]]
	LuaCallCShapUI.httpReqAsync(Define.IP_ADDRESS_URL,function(ret)
		-- print(LuaCallCShapUI.Utf8ToDefault("外网IP信息: ") .. tostring(ret))
		local localIP = LuaCallCShapUI.GetLocalIP()
		local localIpInfo = "\n" .. LuaCallCShapUI.Utf8ToDefault("内网IP:") .. tostring(localIP)
		local addressInfo = LuaCallCShapUI.Utf8ToDefault("外网IP:")
		local ok,decode_msg = pcall(function()
			local splitData = StringUtils.splitString(ret, "=")
			if splitData and next(splitData) then
				return json.decode(splitData[2])
			end
		end)
		if ok then
			decode_msg = decode_msg or {}
			addressInfo = addressInfo .. (decode_msg.cip or "null") .. " " .. (decode_msg.cname or "null")
		end
		addressInfo = addressInfo .. localIpInfo
		LuaCallCShapUI.SetIPText(addressInfo) --显示IP信息
	end)
	LuaCallCShapUI.SetLogLineCountLimie(Define.LOG_LINE_COUNT_LIMIE) --日志行数限制设置
	LuaCallCShapUI.SetProxyLinkUrl(Define.PROXY_LOG_URL) --点击跳转日志显示页面
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

function UIConfigData.setIsShowNetLog(flag)
	_isShowNetLog = flag
end

function UIConfigData.getIsShowNetLog()
	return _isShowNetLog
end

--设置代理IP
function UIConfigData.setProxyIpConfig(ip_table)
	_proxyIPTable = ip_table
	local LuaCallCShapUI = require("resources.luaScript.uiLogic.LuaCallCShapUI")
	dump(_proxyIPTable,LuaCallCShapUI.Utf8ToDefault("使用中~"))
end

function UIConfigData.getProxyIpConfig()
	return _proxyIPTable
end

return UIConfigData