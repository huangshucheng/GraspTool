--[[处理Fidder发送头数据]]
local DealDataBase = require("luaScript.dataDeal.DealDataBase")
local DealReqHeader = class("DealReqHeader", DealDataBase)

local StringUtils = require("luaScript.util.StringUtils")
local FindData = require("luaScript.data.FindData")
local TaskData = require("luaScript.data.TaskData")
local Define = require("luaScript.config.Define")

function DealReqHeader:getInstance()
	if not DealReqHeader._instance then
		DealReqHeader._instance = DealReqHeader.new()
	end
	return DealReqHeader._instance
end

function DealReqHeader:dealData(data, splitData)
	local retTable = StringUtils.parseHttpHeader(data)
	if not retTable or not next(retTable) then
		return
	end

	local findTable = {}
	local dataToFind = TaskData.getCurTask():getDataToFind()
	if next(dataToFind) then
		for _, token in ipairs(dataToFind) do
			if retTable[token] and retTable[token] ~= "" then
				findTable[token] = retTable[token]
			end
		end
	end

	if table.nums(findTable) > 0 then
		if not FindData:getInstance():isInFindList(findTable) then
			FindData:getInstance():addFindToken(findTable)
		end
	end
end

return DealReqHeader