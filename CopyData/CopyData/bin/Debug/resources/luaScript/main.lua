require("resources.luaScript.util.functions")
require("resources.luaScript.util.json")
require("resources.luaScript.test.init")
require("resources.luaScript.uiLogic.init")

local CSFun = require("resources.luaScript.util.CSFun")
--打印在屏幕上
print = function(param)
	CSFun.LogOut(param)
	CSFun.LogLua(param)
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

--收到FD消息
function Fidder_OnRecvData()
	local strData = CSFun.GetFidderString()
	if UIConfigData.getIsShowNetLog() then
		print(strData)
	end
	local tmpCurTask = TaskData.getCurTask()
	if not tmpCurTask then
		return
	end
	if strData and strData ~= "" then
		local splitData = StringUtils.splitString(strData, "\n", 6)
		for index, str in ipairs(splitData) do
			if string.find(str, tmpCurTask:getReqHeadString()) then --请求头
				DealHttpReqData:getInstance():dealHeaderData(strData, splitData)
				-- print("Header>>\n" .. strData)
				break
			elseif string.find(str, tmpCurTask:getReqBodyString()) then --请求体
				break
			elseif string.find(str, tmpCurTask:getResHeadString()) then --返回头
				break
			elseif string.find(str, tmpCurTask:getResBodyString()) then --返回体
				break
			elseif string.find(str, tmpCurTask:getRecordString()) then --记录抓取
				FindData:getInstance():saveGraspData(strData)
				break
			end
		end
	end
end

--接收proxy网络消息
function WebSocket_OnSocketData()
	local websocket_data = CSWebSocket.WebSocket_GetSocketData()
	local ok, out_msg = pcall(function()
		local decode_table = json.decode(websocket_data)
		if decode_table then
			return decode_table
		end
	end)
	if ok and out_msg and next(out_msg) then
		 for k , v in pairs(out_msg) do
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
					local host_req = out_msg["ReqHost"]
					-- print("host_to_find: " .. tostring(host_to_find) .. " ,req_hose: " .. host_req)
					if host_req and host_to_find and host_to_find ~= "" then
						if CSFun.IsSubString(host_req, host_to_find) then --是否当前查找的域名
							DealHttpReqData:getInstance():recordHeaderData(v, out_msg)
							DealHttpReqData:getInstance():saveToLocalFile(websocket_data)
						end
					end
				end
		 		break
		 	end
		 end
	else
		print("decode_json error>>  " .. tostring(out_msg))
	end
	if UIConfigData.getIsShowNetLog() then
		dump(out_msg, os.date("%H:%M:%S"))
		print("\n")
	end
end