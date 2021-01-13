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

local CSWebSocket = require("resources.luaScript.util.CSWebSocket")
local StringUtils = require("resources.luaScript.util.StringUtils")
local DealReqHeader = require("resources.luaScript.dataDeal.DealReqHeader")

local FindData = require("resources.luaScript.data.FindData")
local TaskData = require("resources.luaScript.data.TaskData")
local UIConfigData = require("resources.luaScript.data.UIConfigData")
UIConfigData.init() --读取默认UI配置参数
TaskData.loadTaskList() --读取本地任务列表,显示在任务列表UI
CSWebSocket.init()

print(CSFun.Utf8ToDefault("hello! 请手动选择活动!!!"))

--[[
local string = require("string")
local math = require("math")
local debugFunc = function()
	local breakInfoFun, xpcallFun = require("resources.luaScript.LuaDebug")("localhost", 7003)
	print("breakInfoFun>> " .. tostring(breakInfoFun) .. " ,xpCallFun>> " .. tostring(breakInfoFun))
	CSFun.SetInterval(0.3, breakInfoFun)
end
]]
-- debugFunc()
--[[
local function __G__TRACKBACK__(msg)
	local traceback = debug.traceback()
	print(msg, traceback)
end
local status, msg = pcall(debugFunc, __G__TRACKBACK__)
print(">>>> " .. tostring(status) .. " >>" .. tostring(msg))
]]

--[[
local count = 0
local timerID = -1
timerID = CSFun.SetInterval(0.3, function()
	count = count + 1
	print("count>> " .. count .. " ,id:" .. timerID)
	if count == 10 then
		CSFun.StopTimer(timerID);
	end
end)
]]


--收到FD 传过来的数据
function Fidder_OnRecvData()
	local tmpCurTask = TaskData.getCurTask()
	if not tmpCurTask then
		return
	end
	local strData = CSFun.GetFidderString()
	-- print("strData>>" .. strData)
	if strData and strData ~= "" then
		local splitData = StringUtils.splitString(strData, "\n", 6)
		for index, str in ipairs(splitData) do
			if string.find(str, tmpCurTask:getReqHeadString()) then --请求头
				DealReqHeader:getInstance():dealData(strData, splitData)
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

function WebSocket_OnSocketData()
	print("wsData________________________start")
	local wsData = CSWebSocket.WebSocket_GetSocketData()
	print(wsData)
	local decode_json_obj = nil
	local ok, msg = pcall(function()
		decode_json_obj = json.decode(wsData)
	end)
	if ok then
		 -- dump(decode_json_obj,"decode_json_obj>>",10)
		 for k , v in pairs(decode_json_obj) do
		 	if k == "websocket" then
		 		if v == "socket_opend" then
		 			print("socket_opend>>>>>>>>>>>>>>>>>")
		 			break
		 		elseif v == "socket_error" then
		 			print("socket_error>>>>>>>>>>>>>>>>>")
					break
		 		elseif v == "socket_closed" then
		 			print("socket_closed>>>>>>>>>>>>>>>>>")
					break
		 		end
		 	end
		 end
	else
		print("decode_json_obj error>>>>>>>>>>>>>>>  " .. tostring(msg))
	end
	print("wsData________________________end")
end