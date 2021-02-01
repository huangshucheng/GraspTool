--[[处理Http请求数据]]

local DealHttpReqData = class("DealHttpReqData")

local StringUtils 	= require("resources.luaScript.util.StringUtils")
local FindData 		= require("resources.luaScript.data.FindData")
local TaskData 		= require("resources.luaScript.data.TaskData")
local UIConfigData  = require("resources.luaScript.data.UIConfigData")
local TaskStart 	= require("resources.luaScript.task.base.TaskStart")
local CSFun         = require("resources.luaScript.util.CSFun")
local TaskStartManager 	= require("resources.luaScript.task.base.TaskStartManager")

function DealHttpReqData:getInstance()
	if not DealHttpReqData._instance then
		DealHttpReqData._instance = DealHttpReqData.new()
	end
	return DealHttpReqData._instance
end

--处理请求头数据
--参数：string
function DealHttpReqData:dealHeaderData(strData)
	if not UIConfigData.getIsAutoGraspCK() then
		return
	end
	self:recordHeaderData(StringUtils.parseHttpHeader(strData))
end

--记录请求头数据
--参数：header_table: 请求头， all_msg_data: 请求的所有数据包括请求头
function DealHttpReqData:recordHeaderData(header_table, all_msg_data)
	local curTaskObj = TaskData.getCurTask()
	if not curTaskObj then
		return
	end

	if not header_table or not next(header_table) then
		return
	end

	if curTaskObj:isUseFullReqData() then
		self:dealHeaderWithAllReqData(all_msg_data)
	else
		self:dealHeaderReqData(header_table)
	end
end

--保存全部请求信息
function DealHttpReqData:dealHeaderWithAllReqData(all_msg_data)
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
		-- print("---------------------------")
		-- print(reqUrl)
		-- print(url)
		-- print("usSubStr: " .. tostring(isSubStr))
		-- print("---------------------------")
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

--只保存请求头的信息
function DealHttpReqData:dealHeaderReqData(header_table)
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

	local findCount = table.nums(findTable)
	if findCount > 0 and findCount == #dataToFind then --必要的token必须要全部找到
		if not FindData:getInstance():isInFindList(findTable) then
			FindData:getInstance():addFindToken(findTable, true)
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