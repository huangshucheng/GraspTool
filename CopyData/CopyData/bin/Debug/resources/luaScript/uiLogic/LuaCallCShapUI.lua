--[[lua调用UI]]
local CSFun = require("resources.luaScript.util.CSFun")
local LuaCallCShapUI = class("LuaCallCShapUI", CSFun)

--增加活动列表的元素
function LuaCallCShapUI.AddActivityToList(actTable)
	if not actTable or not next(actTable) then
		return
	end
	if AddActivityToList then 
		AddActivityToList(actTable)
	 end
end

--设置选中某个列表的下标
function LuaCallCShapUI.SetActivitySelIndex(index)
	index = tonumber(index) or 0
	if index >= 0 then
		if SetActivitySelIndex then
			SetActivitySelIndex(index)
		end
	end
end

-- 是否有提示音
function LuaCallCShapUI.IsOpenTipSound()
	if IsOpenTipSound then
		return IsOpenTipSound()
	end
end

-- 是否自动抓取CK
function LuaCallCShapUI.IsAutoGraspCK()
	if IsAutoGraspCK then
		return IsAutoGraspCK()
	end
end

-- 是否自动做任务
function LuaCallCShapUI.IsAutoDoAction()
	if IsAutoDoAction then
		return IsAutoDoAction()
	end
end

--设置是否自动做任务
function LuaCallCShapUI.SetAutoDoAction(bIsAuto)
	if bIsAuto == nil then
		bIsAuto = false
	end
	if SetAutoDoAction then
		SetAutoDoAction(bIsAuto)
	end
end

--是否显示输出（下面的）
function LuaCallCShapUI.IsShowOutLog()
	if IsShowOutLog then
		return IsShowOutLog()
	end
end

-- 获取延迟时间
function LuaCallCShapUI.GetReqDelayTime()
	if GetReqDelayTime then
		return GetReqDelayTime()
	end
end

--显示二维码图片
--method: "GEt" or "POST"
function LuaCallCShapUI.ShowQRCode(url, method, callfuck)
	if ShowQRCode then
		method = method or "GET"
		ShowQRCode(url, method, callfuck)
	end
end


-- 获取UI中二维码字符串
function LuaCallCShapUI.GetQRCodeString()
	if GetQRCodeString then
		return GetQRCodeString()
	end
end

--设置二维码字符串
function LuaCallCShapUI.SetQRCodeString(str)
	if SetQRCodeString then
		SetQRCodeString(str)
	end
end

--清理二维码图片
function LuaCallCShapUI.ClearQRCode()
	if ClearQRCode then
		ClearQRCode()
	end
end

--获取本机IP
function LuaCallCShapUI.GetLocalIP()
	if GetLocalIP then
		return GetLocalIP()
	end
end

--设置IP文本
function LuaCallCShapUI.SetIPText(str)
	if SetIPText then
		SetIPText(str)
	end
end

--设置日志行数限制
function LuaCallCShapUI.SetLogLineCountLimie(lineCount)
	if SetLogLineCountLimie then
		return SetLogLineCountLimie(lineCount)
	end
end

--获取代理IP文本内容
function LuaCallCShapUI.GetProxyString()
	if GetProxyString then
		return GetProxyString()
	end
end

--设置日志显示页面的URL,通过点击跳转到此连接
function LuaCallCShapUI.SetProxyLinkUrl(urlStr)
	if not urlStr or urlStr == "" then
		return
	end
	if SetProxyLinkUrl then
		SetProxyLinkUrl(urlStr)
	end
end

--设置卡包次数
function LuaCallCShapUI.SetKaBaoCount(count)
	if SetKaBaoCount then
		SetKaBaoCount(count)
	end
end

--获取卡包次数
function LuaCallCShapUI.GetKaBaoCount()
	if GetKaBaoCount then
		return GetKaBaoCount()
	end
end

return LuaCallCShapUI