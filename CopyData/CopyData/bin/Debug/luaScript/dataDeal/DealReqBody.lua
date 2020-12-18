--[[处理请求体数据]]
local DealDataBase = require("luaScript.dataDeal.DealDataBase")
local DealResBody = class("DealResBody", DealDataBase)

local StringUtils = require("luaScript.util.StringUtils")
local FindData = require("luaScript.data.FindData")
local Define = require("luaScript.config.Define")


function DealResBody:getInstance()
	if not DealResBody._instance then
		DealResBody._instance = DealResBody.new()
	end
	return DealResBody._instance
end

function DealResBody:dealData(data, splitData)
end

return DealResBody