require("luaScript.util.functions")
require("luaScript.util.json")
require("luaScript.test.init")

local CSFun = require("luaScript.util.CSFun")

-- 注意：打印不能使用逗号分开，否则会报错
print = function(param)
	CSFun.LogOut(param)
	CSFun.LogLua(param)
end

local StringUtils = require("luaScript.util.StringUtils")
local Define = require("luaScript.config.Define")
local DealRecvHeaderData = require("luaScript.dataDeal.DealRecvHeaderData")
local FindData = require("luaScript.data.FindData")

FindData:getInstance():readLocalFile()

-- print("trace>> " .. debug.traceback())

print("hello~")

function receiveFidderData()
	local strData = nil
	local ok, msg = pcall(function()
		strData = CSFun.GetFidderString()
	end)

	if not ok then
		print("GetFidderString>>error " .. tostring(msg))
		return
	end
	
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
