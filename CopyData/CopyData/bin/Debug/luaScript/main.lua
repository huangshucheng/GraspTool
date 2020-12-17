require("luaScript.util.functions")
require("luaScript.util.json")
require("luaScript.test.init")

local CSFun = require("luaScript.util.CSFun")

--打印在屏幕上
print = function(param)
	CSFun.LogOut(param)
	CSFun.LogLua(param)
end

local StringUtils = require("luaScript.util.StringUtils")
local DealRecvHeaderData = require("luaScript.dataDeal.DealRecvHeaderData")

local FindData = require("luaScript.data.FindData")
local TaskData = require("luaScript.data.TaskData")

--当前正在跑的任务
local CurTask = require("luaScript.task.TaskDiamond")
TaskData.setCurTask(CurTask.new()) --设置当前执行的任务对象

--加载本地token缓存
FindData:getInstance():readLocalFile()

function receiveFidderData()
	local strData = nil
	local ok, msg = pcall(function()
		strData = CSFun.GetFidderString()
	end)

	if not ok then
		return
	end

	-- CSFun.LogOut(strData)
	if strData and strData ~= "" then
		local splitData = StringUtils.splitString(strData, "\n", 6)
		for index, str in ipairs(splitData) do
			if string.find(str, TaskData.getCurTask():getReqHeadString()) then
				DealRecvHeaderData:getInstance():dealData(strData)
				break
			end
		end
	end
end
