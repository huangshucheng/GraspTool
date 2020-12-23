require("resources.luaScript.util.functions")
require("resources.luaScript.util.json")
require("resources.luaScript.test.init")

local CSFun = require("resources.luaScript.util.CSFun")

--打印在屏幕上
print = function(param)
	CSFun.LogOut(param)
	CSFun.LogLua(param)
end

print("hello!")

local StringUtils = require("resources.luaScript.util.StringUtils")
local DealReqHeader = require("resources.luaScript.dataDeal.DealReqHeader")
local DealReqBody = require("resources.luaScript.dataDeal.DealReqBody")
local DealResBody = require("resources.luaScript.dataDeal.DealResBody")

local FindData = require("resources.luaScript.data.FindData")
local TaskData = require("resources.luaScript.data.TaskData")

--当前正在跑的任务
local CurTask = require("resources.luaScript.task.TaskDiamond")
-- local CurTask = require("resources.luaScript.task.TaskWeiXinAuth")
-- local CurTask = require("resources.luaScript.task.TaskAllRecord")
-- local CurTask = require("resources.luaScript.task.TaskRun")
local taskObj = CurTask.new()
TaskData.setCurTask(taskObj) --设置当前执行的任务对象

--加载本地token缓存
FindData:getInstance():readLocalFile()

function receiveFidderData()
	local strData = CSFun.GetFidderString()
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
