require("resources.luaScript.util.functions")
require("resources.luaScript.util.json")
require("resources.luaScript.test.init")
require("resources.luaScript.uiLogic.init")

local CSFun = require("resources.luaScript.util.CSFun")
--打印在屏幕上
print = function(param)
	CSFun.LogOut(CSFun.Unicode2String(param))
	-- CSFun.LogLua(param)
end

local CSWebSocket 	= require("resources.luaScript.util.CSWebSocket")
local StringUtils 	= require("resources.luaScript.util.StringUtils")
local DealHttpReqData = require("resources.luaScript.dataDeal.DealHttpReqData")
local FindData 		= require("resources.luaScript.data.FindData")
local TaskData 		= require("resources.luaScript.data.TaskData")
local UIConfigData 	= require("resources.luaScript.data.UIConfigData")
UIConfigData.init() --读取默认UI配置参数
TaskData.loadTaskList() --读取本地任务列表,显示在任务列表UI
CSWebSocket.init()

print(CSFun.Utf8ToDefault("hello! 请在活动列表选择活动!!!"))

--处理FD或WS网络数据
local function Handle_RecvData(recv_msg)
	for k , v in pairs(recv_msg) do
	 	if k == "cc_websocket" then --是websocket的连接事件: open, error, closed
	 		if v == "socket_opend" then
	 			print(CSFun.Utf8ToDefault("网络已连接~"))
	 			break
	 		elseif v == "socket_error" then
	 			print(CSFun.Utf8ToDefault("网络连接错误~"))

				break
	 		elseif v == "socket_closed" then
	 			print(CSFun.Utf8ToDefault("网络连接已关闭~"))
				break
	 		end
	 		break
	 	elseif k == "Headers" then --是http请求
			local tmpCurTask = TaskData.getCurTask()
			if tmpCurTask then
				local host_to_find = tmpCurTask:getHost()
				local host_req = recv_msg["ReqHost"]
				-- print("host_to_find: " .. tostring(host_to_find) .. " ,req_hose: " .. host_req)
				if host_req and host_to_find and host_to_find ~= "" then
					if CSFun.IsSubString(host_req, host_to_find) then --是否当前查找的域名
						DealHttpReqData:getInstance():dealReqData(recv_msg)
						DealHttpReqData:getInstance():saveToLocalFile(websocket_data)
					end
				end
			end
	 		break
	 	end
	 end
end

--收到FD消息
function Fidder_OnRecvData()
	local fd_data = CSFun.GetFidderString()
	-- print("fd_data: " .. fd_data)
	local ok, recv_msg = pcall(function()
		local decode_table = json.decode(fd_data)
		if decode_table then
			return decode_table
		end
	end)
	if ok and recv_msg and next(recv_msg) then
		Handle_RecvData(recv_msg)
	else
		-- print("decode_json error111>>  " .. tostring(recv_msg))
	end

	if UIConfigData.getIsShowNetLog() then
		dump(recv_msg, "FD_DATA:" .. os.date("%H:%M:%S"))
		print("\n")
	end
end

--接收proxy网络消息
function WebSocket_OnSocketData()
	local websocket_data = CSWebSocket.WebSocket_GetSocketData()
	local ok, recv_msg = pcall(function()
		local decode_table = json.decode(websocket_data)
		if decode_table then
			return decode_table
		end
	end)
	if ok and recv_msg and next(recv_msg) then
		 Handle_RecvData(recv_msg)
	else
		print("decode_json error222>>  " .. tostring(recv_msg))
	end

	if UIConfigData.getIsShowNetLog() then
		dump(recv_msg, "WS_DATA:" .. os.date("%H:%M:%S"))
		print("\n")
	end
end