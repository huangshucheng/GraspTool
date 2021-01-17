--[[处理请求体数据]]
local DealDataBase = require("resources.luaScript.dataDeal.DealDataBase")
local DealResBody = class("DealResBody", DealDataBase)

local StringUtils = require("resources.luaScript.util.StringUtils")
local FindData = require("resources.luaScript.data.FindData")
local Define = require("resources.luaScript.config.Define")


function DealResBody:getInstance()
	if not DealResBody._instance then
		DealResBody._instance = DealResBody.new()
	end
	return DealResBody._instance
end

function DealResBody:dealData(data, splitData)
end

return DealResBody