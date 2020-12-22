require("luaScript.util.functions")
require("luaScript.util.json")
require("luaScript.test.init")

local CSFun = require("luaScript.util.CSFun")

--打印在屏幕上
print = function(param)
	CSFun.LogOut(param)
	CSFun.LogLua(param)
end

print("hello!")

local StringUtils = require("luaScript.util.StringUtils")
local DealReqHeader = require("luaScript.dataDeal.DealReqHeader")
local DealReqBody = require("luaScript.dataDeal.DealReqBody")
local DealResBody = require("luaScript.dataDeal.DealResBody")

local FindData = require("luaScript.data.FindData")
local TaskData = require("luaScript.data.TaskData")

--当前正在跑的任务
local CurTask = require("luaScript.task.TaskDiamond")
-- local CurTask = require("luaScript.task.TaskWeiXinAuth")
-- local CurTask = require("luaScript.task.TaskAllRecord")
-- local CurTask = require("luaScript.task.TaskRun")
local taskObj = CurTask.new()
TaskData.setCurTask(taskObj) --设置当前执行的任务对象

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

	-- print("strData>>" .. strData)
	if strData and strData ~= "" then
		local splitData = StringUtils.splitString(strData, "\n", 6)
		for index, str in ipairs(splitData) do
			if string.find(str, TaskData.getCurTask():getReqHeadString()) then --请求头
				DealReqHeader:getInstance():dealData(strData, splitData)
				break
			elseif string.find(str, TaskData.getCurTask():getReqBodyString()) then --请求体
				-- DealReqBody:getInstance():dealData(strData, splitData)
				break
			elseif string.find(str, TaskData.getCurTask():getResHeadString()) then --返回头

				break
			elseif string.find(str, TaskData.getCurTask():getResBodyString()) then --返回体
				-- DealResBody:getInstance():dealData(strData, splitData)
				break
			elseif string.find(str, TaskData.getCurTask():getRecordString()) then --记录抓取
				FindData:getInstance():saveGraspData(strData)
				break
			end
		end
	end
end
