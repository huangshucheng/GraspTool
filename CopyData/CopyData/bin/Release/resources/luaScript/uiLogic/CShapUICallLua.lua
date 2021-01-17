--[[ui调用Lua脚本]]
local UIConfigData = require("resources.luaScript.data.UIConfigData")
local TaskStart = require("resources.luaScript.task.base.TaskStart")
local Define = require("resources.luaScript.config.Define")
local StringUtils = require("resources.luaScript.util.StringUtils")

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

--点击是否显示日志
function onSelectShowOutLog(isShow)
	print("onSelectShowOutLog>> " .. tostring(isShow))
	UIConfigData.setIsShowOutLog(isShow)
end

--点击生成二维码图片
function onClickGenQRCode()
	local LuaCallCShapUI = require("resources.luaScript.uiLogic.LuaCallCShapUI")
	local qrCodeStr = LuaCallCShapUI.GetQRCodeString() or ""
	local qrCodeUrl = qrCodeStr
	if not StringUtils.checkWithHttp(qrCodeStr) then
		qrCodeUrl = Define.QR_CODE_STR .. qrCodeStr
	end
	LuaCallCShapUI.ShowQRCode(qrCodeUrl, "GET", function(retStr)
		if retStr ~= "SUCCESS" then
			print(tostring(retStr))
		end
	end)
end

--点击选择下拉列表的活动
function onClickDoSelAction()
	TaskStart.doSelectAction()
end

--点击ListView表头
local SELECT_COLUM_FLAG = true
function ListView_on_colum_click(columIndex)
	if 0 == tonumber(columIndex) then --点中了第一个表头
		local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
		CShapListView.ListView_set_all_checked(SELECT_COLUM_FLAG)
		SELECT_COLUM_FLAG = not SELECT_COLUM_FLAG
	end
end

--点击了是否显示网络日志
function onCheckNetLog(bShowLog)
	local isShow = 1 == tonumber(bShowLog)
	UIConfigData.setIsShowNetLog(isShow)
	print("showNetLog>> " .. tostring(isShow))
end

--获取字符串里面的地理位置信息
-- var returnCitySN = {"cip": "115.205.71.148", "cid": "330100", "cname": "浙江省杭州市"};
local function getRealAddress(retInfo)
	local ok,decode_msg = pcall(function()
		local splitData = StringUtils.splitString(retInfo, "=")
		if splitData and next(splitData) then
			return json.decode(splitData[2])
		end
	end)
	if ok then
		 return (decode_msg.cname or "")
	end
	return ""
end

--点击使用代理
function onClickUseProxy(bUseProxy)
	-- print(type(bUseProxy) .. "  " .. tostring(bUseProxy))
	local LuaCallCShapUI = require("resources.luaScript.uiLogic.LuaCallCShapUI")
	if not bUseProxy then
		UIConfigData.setProxyIpConfig({})
		print(LuaCallCShapUI.Utf8ToDefault("已禁用代理~"))
	else
		local proxyString = StringUtils.trim(LuaCallCShapUI.GetProxyString())
		if not proxyString or proxyString == "" then
			print(LuaCallCShapUI.Utf8ToDefault("输入代理IP信息为空~"))
			return
		end

		local splitData = StringUtils.splitString(proxyString,"\n")
		-- dump(splitData,LuaCallCShapUI.Utf8ToDefault("测试代理IP:"))
		local showLogData = {} --打印用
		local useProxyData = {} --实际使用
		for _ , proxy_url in ipairs(splitData) do
			LuaCallCShapUI.IsProxyCanUse(proxy_url,function(ret_proxy_url, canUse, proxy_address_info)
				local canUseTip = LuaCallCShapUI.Utf8ToDefault(canUse and "可用~" or "不可用~")
				local addressTip = getRealAddress(proxy_address_info)
				showLogData[ret_proxy_url] = canUseTip .. "  ," .. tostring(addressTip)
				if canUse then
					table.insert(useProxyData,ret_proxy_url)
				end
				if table.nums(showLogData) == #splitData then
					-- dump(showLogData,LuaCallCShapUI.Utf8ToDefault("结果"))
					UIConfigData.setProxyIpConfig(useProxyData)
					if #useProxyData > 0 then
						print(LuaCallCShapUI.Utf8ToDefault("已开启代理~"))
					else
						print(LuaCallCShapUI.Utf8ToDefault("已开启代理~但是没有代理IP可用~"))
					end
				end
			end)
		end
	end		
end

--点击验证代理
function onClickCheckProxy()
	local LuaCallCShapUI = require("resources.luaScript.uiLogic.LuaCallCShapUI")
	local proxyString = StringUtils.trim(LuaCallCShapUI.GetProxyString())
	if proxyString == "" then
		print(LuaCallCShapUI.Utf8ToDefault("输入代理IP信息为空~"))
	end
	if proxyString and proxyString ~= "" then
		local splitData = StringUtils.splitString(proxyString,"\n")
		dump(splitData,LuaCallCShapUI.Utf8ToDefault("测试代理IP:"))
		local showLogData = {}
		for _ , proxy_url in ipairs(splitData) do
			LuaCallCShapUI.IsProxyCanUse(proxy_url,function(ret_proxy_url, canUse, proxy_address_info)
				local canUseTip = LuaCallCShapUI.Utf8ToDefault(canUse and "可用~" or "不可用~")
				local addressTip = getRealAddress(proxy_address_info)
				showLogData[ret_proxy_url] = canUseTip .. "  ," .. tostring(addressTip)
				if table.nums(showLogData) == #splitData then
					dump(showLogData,LuaCallCShapUI.Utf8ToDefault("结果"))
				end
			end)
		end
	end
end
