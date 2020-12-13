local DealDataBase = require("luaScript.dataDeal.DealDataBase")
local DealRecvHeaderData = class("DealRecvHeaderData", DealDataBase)

local StringUtils = require("luaScript.util.StringUtils")
local Define = require("luaScript.config.Define")
local FindData = require("luaScript.data.FindData")

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
	if next(Define.DATA_TO_FIND_ARRAY) then
		for _, token in ipairs(Define.DATA_TO_FIND_ARRAY) do
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