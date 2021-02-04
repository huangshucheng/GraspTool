local CSWebSocket = class("CSWebSocket")
local Define = require("resources.luaScript.config.Define")

local timerID = nil

function CSWebSocket.init()
	local ret_str = CSWebSocket.WebSocket_CreateSocket(Define.ANYPROXY_SELF_WS_URL) --anyproxy 我自己的ws端口
	-- local ret_str = CSWebSocket.WebSocket_CreateSocket("ws://127.0.0.1:8005") --本地调试
	print(tostring(ret_str))
	local CSFun = require("resources.luaScript.util.CSFun")
	local interval = 3
	timerID = CSFun.SetInterval(3, function()
		local isConnected = CSWebSocket.WebSocket_IsConnected()
		if not isConnected then
			CSWebSocket.WebSocket_DoReConnect()
			print(CSFun.Utf8ToDefault("网络正在重连..."))
		end
	end)
	local TimerManager = require("resources.luaScript.manager.TimerManager")
	TimerManager.addNotStopTimerID(timerID)
end

function CSWebSocket.WebSocket_GetTimerID()
	return timerID
end

--返回提示：是否成功，string
function CSWebSocket.WebSocket_CreateSocket(wsUrl)
	if WebSocket_CreateSocket then
		return WebSocket_CreateSocket(wsUrl)
	end
end

function CSWebSocket.WebSocket_SendMessage(data)
	if WebSocket_SendMessage then
		WebSocket_SendMessage(data)
	end
end

function CSWebSocket.WebSocket_GetSocketData()
	if WebSocket_GetSocketData then
		return WebSocket_GetSocketData()
	end
end

function CSWebSocket.WebSocket_IsConnected()
	if WebSocket_IsConnected then
		return WebSocket_IsConnected()
	end
end

function CSWebSocket.WebSocket_DoReConnect()
	if WebSocket_DoReConnect then
		WebSocket_DoReConnect()
	end
end

function CSWebSocket.WebSocket_Close()
	if WebSocket_Close then
		WebSocket_Close()
	end
end

return CSWebSocket