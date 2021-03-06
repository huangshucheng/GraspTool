--[[处理Http请求数据]]

local DealHttpReqData = class("DealHttpReqData")

local StringUtils 	= require("resources.luaScript.util.StringUtils")
local FindData 		= require("resources.luaScript.data.FindData")
local TaskData 		= require("resources.luaScript.data.TaskData")
local UIConfigData  = require("resources.luaScript.data.UIConfigData")
local TaskStart 	= require("resources.luaScript.task.base.TaskStart")
local CSFun         = require("resources.luaScript.util.CSFun")
local TaskStartManager 	= require("resources.luaScript.manager.TaskStartManager")

function DealHttpReqData:getInstance()
	if not DealHttpReqData._instance then
		DealHttpReqData._instance = DealHttpReqData.new()
	end
	return DealHttpReqData._instance
end

-- 处理请求数据
--参数: all_msg_data: 请求的所有数据包括请求头
function DealHttpReqData:dealReqData(all_msg_data)
	local curTaskObj = TaskData.getCurTask()
	if not curTaskObj then
		return
	end
	if curTaskObj:isUseFullReqData() then
		self:dealWithAllReqData(all_msg_data)
	else
		self:dealWithHeaderData(all_msg_data)
	end
end

--处理全部请求信息
function DealHttpReqData:dealWithAllReqData(all_msg_data)
	if not all_msg_data or all_msg_data == "" or type(all_msg_data) ~= "table" then
		return
	end

	if not next(all_msg_data) then
		return
	end
	
	local reqUrl = all_msg_data["ReqUrl"]
	if not reqUrl then
		return
	end

	local dataToFind = TaskData.getCurTask():getDataToFind()
	if not dataToFind or  #dataToFind <= 0 then
		return
	end
	for _, url in ipairs(dataToFind) do
		local isSubStr = CSFun.IsSubString(reqUrl, url)
		print("---------------------------")
		print(CSFun.Utf8ToDefault("当前URL>> ") .. reqUrl)
		print(CSFun.Utf8ToDefault("查找URL>> ") .. url)
		print(CSFun.Utf8ToDefault("查找URL是否为当前URL子串>> ") .. tostring(isSubStr))
		print("---------------------------\n")
		if isSubStr then
			if not FindData:getInstance():isInFindList(all_msg_data) then
				FindData:getInstance():addFindToken(all_msg_data, true)
				if UIConfigData.getIsAutoDoAction() then
					TaskStartManager.startEnd()
				end
			end
			break
		end
	end
end

--只处理请求头的信息
function DealHttpReqData:dealWithHeaderData(all_msg_data)
	if not all_msg_data or all_msg_data == "" or type(all_msg_data) ~= "table" then
		return
	end

	if not next(all_msg_data) then
		return
	end
	
	local header_table = all_msg_data["Headers"]
	if not header_table then
		return
	end

	local dataToFind = TaskData.getCurTask():getDataToFind()
	if not dataToFind or  #dataToFind <= 0 then
		return
	end

	local findTable = {}
	for _, token in ipairs(dataToFind) do
		if header_table[token] and header_table[token] ~= "" then
			findTable[token] = header_table[token]
		end
	end
	--dump(findTable,"findTable")
	local findCount = table.nums(findTable)
	if findCount > 0 and findCount == #dataToFind then --必要的token必须要全部找到
		-- local tmpFindTable = {["Headers"] = findTable, ["Method"] = "", ["ReqBody"] = "",["ReqHost"] = "",["ReqUrl"] = "",}
		local tmpFindTable = {["Headers"] = findTable,}
		if not FindData:getInstance():isInFindList(tmpFindTable) then
			FindData:getInstance():addFindToken(tmpFindTable, true)
			--是否自动开始执行任务
			if UIConfigData.getIsAutoDoAction() then
				TaskStartManager.startEnd()
			end
		end
	end
end

--保存到本地
function DealHttpReqData:saveToLocalFile(websocket_data_str)
	local tmpCurTask = TaskData.getCurTask()
	if not tmpCurTask then
		print(CSFun.Utf8ToDefault("还没指定任务!"))
		return
	end

	if not tmpCurTask:getIsRecord() then
		return
	end

	FindData:getInstance():saveGraspData(websocket_data_str)
end

return DealHttpReqData