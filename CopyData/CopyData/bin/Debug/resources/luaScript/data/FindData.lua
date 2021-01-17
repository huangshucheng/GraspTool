--[[token 查找列表]]
local FindData = class("FindData")
local Define = require("resources.luaScript.config.Define")
local CSFun = require("resources.luaScript.util.CSFun")
local TaskData = require("resources.luaScript.data.TaskData")
local Sound = require("resources.luaScript.util.Sound")
local StringUtils = require("resources.luaScript.util.StringUtils")
local ToolUtils = require("resources.luaScript.util.ToolUtils")
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")

function FindData:getInstance()
	if not FindData._instance then
		FindData._instance = FindData.new()
	end
	return FindData._instance
end

function FindData:ctor()
	self._findTokenList = {}
end

function FindData:getTokenList()
	return self._findTokenList
end

function FindData:getTop()
	return self._findTokenList[1]
end

function FindData:getEnd()
	return self._findTokenList[#self._findTokenList]
end

function FindData:popTop()
	if #self._findTokenList > 0 then
		table.remove(self._findTokenList,1)
	end
end

function FindData:popEnd()
	if #self._findTokenList > 0 then
		table.remove(self._findTokenList)
	end
end

function FindData:getTokenCount()
	return #self._findTokenList
end

--获取所有Cookie
function FindData:getCookiesList()
	local cookieList = {}
	for i,v in ipairs(self._findTokenList) do
		if string.find(v, Define.COOKIE_NAME) then
			table.insert(cookieList,v)
		end
	end
	return cookieList
end

--增加一个token
function FindData:addFindToken(tokenTable)
	if tokenTable and next(tokenTable) then
		table.insert(self._findTokenList, tokenTable)
		self:dumpTokenOne(#self._findTokenList, tokenTable, true)
		self:writeOneTokenToLocalFile(tokenTable)
		Sound.playTokenSound()
		return true
	end
	return false
end

--是否在查找列表中
function FindData:isInFindList(tokenTable)
	for idx,tb in ipairs(self._findTokenList) do
		if table.like(tb, tokenTable) then
			return true
		end
	end
	return false
end

--重新写一遍本地文件，资源消耗很大
function FindData:writeToLocalFile()
	local fileName = self:getSaveFileName()
	if not fileName then
		print("writeToLocalFile error, fileName is not exist" )
		return
	end

	local jsonString = nil
	local ok,msg = pcall(function()
		jsonString = json.encode(self._findTokenList)
	end)

	if not ok then
		print(tostring(msg))
		return
	end
	if jsonString then
		CSFun.WriteFile(fileName, jsonString)
	end
end

--只同步修改部分，到本地文件
function FindData:writeOneTokenToLocalFile(tokenTable)
	local fileName = self:getSaveFileName()
	if not fileName then
		print("writeOneTokenToLocalFile error, fileName is not exist" )
		return
	end

	local jsonString = nil
	local ok,msg = pcall(function()
		jsonString = json.encode(tokenTable)
	end)

	if not ok then
		print(tostring(msg))
		return
	end
	if jsonString then
		CSFun.AppendLine(fileName, jsonString)
	end
end

function FindData:readLocalFileToken()
	self._findTokenList = {}
	local tmpCurTask = TaskData.getCurTask()
	if not tmpCurTask then
		print(CSFun.Utf8ToDefault("还没指定任务!"))
		return
	end
	local fileName = self:getSaveFileName()
	if not fileName or fileName == "" then
		print("readLocalFileToken error, fileName is not exist" )
		return
	end
	local readStr = CSFun.ReadFile(fileName)
	if not readStr or readStr == "" then return end
	local splitData = StringUtils.splitString(readStr, "\n")
	if splitData and next(splitData) then
		for _, token_str in ipairs(splitData) do
			local tokenTable = nil
			local ok, msg = pcall(function() 
				return json.decode(token_str)
			end)
			if ok and msg then
				table.insert(self._findTokenList, msg)
			else
				print("readLocalFileToken failed >>" .. tostring(msg))
			end
		end
	end
	self:dumpToken()
end

--保存token路径
function FindData:getSaveFileName()
	local tmpCurTask = TaskData.getCurTask()
	if not tmpCurTask then
		print(CSFun.Utf8ToDefault("还没指定任务!"))
		return
	end
	local fileName = tmpCurTask:getSaveFileName()
	return fileName
end

--保存抓取列表路径
function FindData:getGraspFileName()
	local tmpCurTask = TaskData.getCurTask()
	if not tmpCurTask then
		print(CSFun.Utf8ToDefault("还没指定任务!"))
		return
	end
	local fileName = tmpCurTask:getRecordGraspFileName()
	return fileName
end

function FindData:dumpToken()
	for index, tokenTable in ipairs(self._findTokenList) do
		self:dumpTokenOne(index, tokenTable, true)
	end	
end

function FindData:dumpTokenOne(index, tokenTable, isShort)
	local showTokenStr = nil
	local func = function()
		local str = ""
		for k,v in pairs(tokenTable) do
			str = str .. tostring(k) .. "=" .. tostring(v) .. " ,"
		end
		showTokenStr = str
	end
	local ok, msg = pcall(func)
	if ok and showTokenStr then
		local finalStr = "(" .. tostring(index) .. ")" .. showTokenStr
		local wCount = isShort and 100 or nil
		finalStr = StringUtils.stringToShort(finalStr, wCount)
		-- CSFun.LogOut(finalStr)
		--加入显示列表
		CShapListView.ListView_add_item({index, finalStr, "", 0, CSFun.Utf8ToDefault("未开始~")})
	end
end

-----------------------------
function FindData:saveGraspData(data)
	local tmpCurTask = TaskData.getCurTask()
	if not tmpCurTask then
		print(CSFun.Utf8ToDefault("还没指定任务!"))
		return
	end

	if not tmpCurTask:getIsRecord() then
		return
	end
	local fileName = self:getGraspFileName()
	CSFun.AppendLine(fileName, data);
	CSFun.AppendLine(fileName, "--------------------------------------------\n");
end

return FindData