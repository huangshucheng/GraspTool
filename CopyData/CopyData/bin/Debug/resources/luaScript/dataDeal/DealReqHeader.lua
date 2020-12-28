--[[处理Fidder发送头数据]]
local DealDataBase = require("resources.luaScript.dataDeal.DealDataBase")
local DealReqHeader = class("DealReqHeader", DealDataBase)

local StringUtils = require("resources.luaScript.util.StringUtils")
local FindData = require("resources.luaScript.data.FindData")
local TaskData = require("resources.luaScript.data.TaskData")
local Define = require("resources.luaScript.config.Define")
local UIConfigData = require("resources.luaScript.data.UIConfigData")
local TaskStart = require("resources.luaScript.task.base.TaskStart")

function DealReqHeader:getInstance()
	if not DealReqHeader._instance then
		DealReqHeader._instance = DealReqHeader.new()
	end
	return DealReqHeader._instance
end

function DealReqHeader:dealData(data, splitData)
	if not UIConfigData.getIsAutoGraspCK() then
		return
	end
	local dataToFind = TaskData.getCurTask():getDataToFind()
	
	if #dataToFind <= 0 then
		return
	end

	local retTable = StringUtils.parseHttpHeader(data)
	local findTable = {}
	
	for _, token in ipairs(dataToFind) do
		if retTable[token] and retTable[token] ~= "" then
			findTable[token] = retTable[token]
		end
	end

	local findCount = table.nums(findTable)
	if findCount > 0 and findCount == #dataToFind then
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