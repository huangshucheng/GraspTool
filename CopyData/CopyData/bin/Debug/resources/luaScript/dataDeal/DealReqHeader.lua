--[[处理Fidder发送头数据]]
local DealReqHeader = class("DealReqHeader")

local StringUtils = require("resources.luaScript.util.StringUtils")
local FindData = require("resources.luaScript.data.FindData")
local TaskData = require("resources.luaScript.data.TaskData")
local UIConfigData = require("resources.luaScript.data.UIConfigData")
local TaskStart = require("resources.luaScript.task.base.TaskStart")

function DealReqHeader:getInstance()
	if not DealReqHeader._instance then
		DealReqHeader._instance = DealReqHeader.new()
	end
	return DealReqHeader._instance
end

function DealReqHeader:dealData(strData, splitData)
	if not UIConfigData.getIsAutoGraspCK() then
		return
	end
	self:recordData(StringUtils.parseHttpHeader(strData))
end

function DealReqHeader:recordData(header_table)
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

return DealReqHeader