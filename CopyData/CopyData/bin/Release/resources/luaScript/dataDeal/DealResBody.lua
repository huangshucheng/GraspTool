--[[处理返回体数据]]
local DealDataBase = require("resources.luaScript.dataDeal.DealDataBase")
local DealReqBody = class("DealReqBody", DealDataBase)

local StringUtils = require("resources.luaScript.util.StringUtils")
local FindData = require("resources.luaScript.data.FindData")
local TaskData = require("resources.luaScript.data.TaskData")
local Define = require("resources.luaScript.config.Define")


function DealReqBody:getInstance()
	if not DealReqBody._instance then
		DealReqBody._instance = DealReqBody.new()
	end
	return DealReqBody._instance
end

function DealReqBody:dealData(data, splitData)
end

return DealReqBody