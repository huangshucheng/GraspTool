--[[处理返回体数据]]
local DealDataBase = require("luaScript.dataDeal.DealDataBase")
local DealReqBody = class("DealReqBody", DealDataBase)

local StringUtils = require("luaScript.util.StringUtils")
local FindData = require("luaScript.data.FindData")
local TaskData = require("luaScript.data.TaskData")
local Define = require("luaScript.config.Define")


function DealReqBody:getInstance()
	if not DealReqBody._instance then
		DealReqBody._instance = DealReqBody.new()
	end
	return DealReqBody._instance
end

function DealReqBody:dealData(data, splitData)
end

return DealReqBody