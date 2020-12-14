local FindData = class("FindData")
local Define = require("luaScript.config.Define")

--c# 传过来的路径
local CUR_DIR_NAME = getCurDir()

function FindData:getInstance()
	if not FindData._instance then
		FindData._instance = FindData.new()
	end
	return FindData._instance
end

function FindData:ctor()
	self._findTokenList = {}
end

--增加一个token
function FindData:addFindToken(tokenTable)
	if tokenTable and next(tokenTable) then
		table.insert(self._findTokenList, tokenTable)
		self:dumpTokenOne(#self._findTokenList, tokenTable)
		self:writeToLocalFile()
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

function FindData:getTokenList()
	return self._findTokenList
end

function FindData:writeToLocalFile()
	local fileName = self:getSaveFileName()
	if not io.exists(fileName) then
		io.createFile(fileName)
	end

	local jsonString = nil
	local ok,msg = pcall(function()
		jsonString = json.encode(self._findTokenList)
	end)

	if not ok then
		LogOut(tostring(msg))
		return
	end
	if jsonString then
		io.writefile(fileName,jsonString)
	end
end

function FindData:readLocalFile()
	local fileName = self:getSaveFileName()
	if not io.exists(fileName) then
		io.createFile(fileName)
	end

	local readStr = io.readfile(fileName)
	if not readStr or readStr == "" then return end

	local decode_table = nil
	local ok, msg = pcall(function() 
		decode_table = json.decode(readStr)
	end)

	-- LogOut("readLocalFile>>>> " .. tostring(ok) .. " " .. tostring(msg))
	-- dump(decode_table,"hcc>>decode_table")
	
	if not ok then
		LogOut(tostring(msg))
		return
	end

	if decode_table and next(decode_table) then
		table.insertto(self._findTokenList, decode_table)
		self:dumpToken()
	end
end

function FindData:getSaveFileName(extStr)
	local ext = extStr or ""
	local fileName = tostring(CUR_DIR_NAME) .. [[\luaScript\token\]] .. Define.FILE_SAVE_NAME .. ext .. ".json"
	return fileName
end

function FindData:dumpToken()
	for index, token_tb in ipairs(self._findTokenList) do
		self:dumpTokenOne(index, token_tb)
	end	
end

function FindData:dumpTokenOne(index, token_tb)
	local conStr = nil
	local func = function()
		local str = ""
		for k,v in pairs(token_tb) do
			str = str .. k .. "=" .. v .. "\n"
		end
		conStr = str
	end
	local ok, msg = pcall(func)
	if ok and conStr then
		local finalStr = "(" .. tostring(index) .. ")" .. conStr .. "\n"
		LogToken(finalStr)
	end
end

return FindData