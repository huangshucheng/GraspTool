--[[处理Http请求数据]]

local DealHttpReqData = class("DealHttpReqData")

local StringUtils 	= require("resources.luaScript.util.StringUtils")
local FindData 		= require("resources.luaScript.data.FindData")
local TaskData 		= require("resources.luaScript.data.TaskData")
local UIConfigData  = require("resources.luaScript.data.UIConfigData")
local TaskStart 	= require("resources.luaScript.task.base.TaskStart")

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
--参数：table
function DealHttpReqData:recordHeaderData(header_table)
	-- dump(header_table,"hcc>>header_table")
	if not header_table or not next(header_table) then
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

	local findCount = table.nums(findTable)
	if findCount > 0 and findCount == #dataToFind then --必要的token必须要全部找到
		if not FindData:getInstance():isInFindList(findTable) then
			FindData:getInstance():addFindToken(findTable)
			--是否自动开始执行任务
			if UIConfigData.getIsAutoDoAction() then
				TaskStart.startEnd()
			end
		end
	end
end

--处理请求body数据
--参数:table
function DealHttpReqData:dealReqBody(out_msg_table)
	out_msg_table = out_msg_table or {}
	local reqBody = out_msg_table.ReqBody
	if reqBody and reqBody ~= "" then
		local curTask = TaskData.getCurTask()
		if curTask then
			curTask:onReqBodyFind(reqBody)
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