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

--删除内存和本地token
function FindData:deleteToken(tokenIndexTable)
	if tokenIndexTable and next(tokenIndexTable) then
		for _,idx in ipairs(tokenIndexTable) do
			table.remove(self._findTokenList, idx)
		end
	end
	local fileName = self:getSaveFileName()
	if not fileName then
		print("deleteToken error, fileName is not exist" )
		return
	end
	CSFun.WriteFile(fileName,"");
	for _, tokenTable in ipairs(self._findTokenList) do
		self:writeOneTokenToLocalFile(tokenTable)
	end
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
	-- --dump(splitData,"hcc>>splitData")
	if splitData and next(splitData) then
		for _, token_str in ipairs(splitData) do
			token_str = StringUtils.trim(token_str)
			if token_str ~= "" then
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
	CShapListView.ListView_clear()
	for index, tokenTable in ipairs(self._findTokenList) do
		self:dumpTokenOne(index, tokenTable, true)
	end	
end

function FindData:dumpTokenOne(index, tokenTable, isShort)
	local tmpCurTask = TaskData.getCurTask()
	if not tmpCurTask then
		print(CSFun.Utf8ToDefault("还没指定任务!"))
		return
	end

	local getTokenStrFunc = nil
	if tmpCurTask:isUseFullReqData() then
		getTokenStrFunc = function()
			local localSaveUrl = tokenTable["ReqUrl"]
			local curTask = FindData:getInstance():findTaskConfigByReqUrl(localSaveUrl)
			if curTask then
				local curTaskName = curTask:getTaskName() or ""
				local str = CSFun.Utf8ToDefault(curTaskName) .. " "
				for k,v in pairs(tokenTable) do
					str = str .. tostring(k) .. "=" .. tostring(v) .. " ,"
				end
				return str
			end
		end
	else
		getTokenStrFunc = function()
			local str = ""
			for k,v in pairs(tokenTable) do
				str = str .. tostring(k) .. "=" .. tostring(v) .. " ,"
			end
			return str
		end
	end

	local ok, msg = pcall(getTokenStrFunc)
	if ok and msg then
		local finalStr = "(" .. tostring(index) .. ")" .. msg
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
	local time_str =os.date("%Y-%m-%d %H:%M:%S");
	local fileName = self:getGraspFileName()
	CSFun.AppendLine(fileName, time_str)
	CSFun.AppendLine(fileName, data)
end

-- 根据任务的Url，找到任务配置（以保存的请求数据为主导，找任务的配置）
function FindData:findTaskConfigByReqUrl(localSaveUrl)
	if not localSaveUrl or localSaveUrl == "" then
		print("findTaskConfigByReqUrl>>error, localSaveUrl is null")
		return
	end
	local tmpCurTask = TaskData.getCurTask()
	if not tmpCurTask then
		print(CSFun.Utf8ToDefault("还没指定任务!"))
		return
	end
	local taskList = tmpCurTask:getTaskList()
	for _, task in ipairs(taskList) do
		local taskUrl = task:getUrl()
		if taskUrl and taskUrl ~= "" and CSFun.IsSubString(localSaveUrl, taskUrl) then
			return clone(task)
		end
	end
end

return FindData