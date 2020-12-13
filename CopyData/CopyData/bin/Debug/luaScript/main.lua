print = LogLua -- 注意：打印不能使用逗号分开，否则会报错
require("luaScript.util.functions")
require("luaScript.util.json")
require("luaScript.test.test_call")

local StringUtils = require("luaScript.util.StringUtils")
local Define = require("luaScript.config.Define")
local DealRecvHeaderData = require("luaScript.dataDeal.DealRecvHeaderData")
local FindData = require("luaScript.data.FindData")

FindData:getInstance():readLocalFile()

function receiveFidderData()
	if not getFidderString then return end
	local strData = getFidderString()
	if strData and strData ~= "" then
		local splitData = StringUtils.splitString(strData, "\n", 6)
		for index, str in ipairs(splitData) do
			if string.find(str, Define.REQ_HEAD_STRING) then
				DealRecvHeaderData:getInstance():dealData(strData)
				break
			elseif string.find(str, Define.REQ_BODY_STRING) then
				break
			elseif string.find(str, Define.RES_HEAD_STRING) then
				break
			elseif string.find(str, Define.RES_BODY_STRING) then
				break
			end
		end
	end
end