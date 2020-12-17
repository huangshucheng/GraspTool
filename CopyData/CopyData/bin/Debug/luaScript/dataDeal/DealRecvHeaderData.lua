--[[处理Fidder发送头数据]]
local DealDataBase = require("luaScript.dataDeal.DealDataBase")
local DealRecvHeaderData = class("DealRecvHeaderData", DealDataBase)

local StringUtils = require("luaScript.util.StringUtils")
local FindData = require("luaScript.data.FindData")
local TaskData = require("luaScript.data.TaskData")

function DealRecvHeaderData:getInstance()
	if not DealRecvHeaderData._instance then
		DealRecvHeaderData._instance = DealRecvHeaderData.new()
	end
	return DealRecvHeaderData._instance
end

function DealRecvHeaderData:dealData(data)
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

return DealRecvHeaderData