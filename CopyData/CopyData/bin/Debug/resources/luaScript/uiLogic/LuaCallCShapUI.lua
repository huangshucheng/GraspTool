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

-- 获取卡包次数
function LuaCallCShapUI.GetReqPktTime()
	if GetReqPktTime then
		return GetReqPktTime()
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

--清理二维码图片
function LuaCallCShapUI.ClearQRCode()
	if ClearQRCode then
		ClearQRCode()
	end
end

return LuaCallCShapUI