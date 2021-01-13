local CSWebSocket = class("CSWebSocket")
local Define = require("resources.luaScript.config.Define")

function CSWebSocket.init()
	CSWebSocket.WebSocket_CreateSocket(Define.ANYPROXY_WEB_SOCKET_URL)
	-- local ret_str =  CSWebSocket.WebSocket_CreateSocket("123")
	print(ret_str)
	local CSFun = require("resources.luaScript.util.CSFun")
	local interval = 3
	local timerID = CSFun.SetInterval(3, function()
		local isConnected = CSWebSocket.WebSocket_IsConnected()
		if not isConnected then
			CSWebSocket.WebSocket_DoReConnect()
			print("hcc>>websocket isConnected: false , reconnect ing...")
		end
	end)
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