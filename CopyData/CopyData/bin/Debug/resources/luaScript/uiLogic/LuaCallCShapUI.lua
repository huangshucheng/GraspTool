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

--设置活动链接
function LuaCallCShapUI.SetActivityLink(linkStr)
	if SetActivityLink then
		SetActivityLink(linkStr)
	end
end

-- 获取活动链接
function LuaCallCShapUI.GetActivityLink()
	if GetActivityLink then
		return GetActivityLink()
	end
end

-- 设置活动简介
function LuaCallCShapUI.SetActivityDesc(descStr)
	if SetActivityDesc then
		SetActivityDesc(descStr)
	end
end

-- 设置用户输入内容
function LuaCallCShapUI.SetUserInputText(inputStr)
	if SetUserInputText then
		SetUserInputText(inputStr)
	end
end

-- 获取用户输入内容
function LuaCallCShapUI.GetUserInputText()
	if GetUserInputText then
		return GetUserInputText()
	end
end

--代理IP是否可用
function LuaCallCShapUI.IsProxyCanUse(proxyUrl,callback)
	if not proxyUrl or proxyUrl == "" then
		if callback then
			callback(proxyUrl,false,nil)
		end
		return
	end
	--默认用http 不用https
	local tmpProxyUrl = proxyUrl
	if not StringUtils.checkWithHttp(proxyUrl) then
		tmpProxyUrl = "http://" .. proxyUrl
	end
	-- print(CSFun.Utf8ToDefault("测试URL: ") .. tostring(proxyUrl))
	local Define = require("resources.luaScript.config.Define")
	CSFun.httpReqAsync(Define.IP_ADDRESS_URL,function(self_address)
		CSFun.httpReqAsync(Define.IP_ADDRESS_URL,function(proxy_address) 
			-- print(CSFun.Utf8ToDefault("本机地址: ") .. self_address)
			-- print(CSFun.Utf8ToDefault("代理地址: ") .. proxy_address)
			local isFindStr = string.find(proxy_address,"returnCitySN")
			local is_proxy_useful = isFindStr and proxy_address and proxy_address ~= "" and (self_address ~= proxy_address)
			is_proxy_useful = is_proxy_useful or false
			-- print(CSFun.Utf8ToDefault("代理是否可用: ") .. proxyUrl .. "   " .. tostring(is_proxy_useful))
			if callback then
				callback(proxyUrl, is_proxy_useful, proxy_address)
			end
		end,nil,nil,nil,nil,nil,tmpProxyUrl)
	end)
end

return LuaCallCShapUI