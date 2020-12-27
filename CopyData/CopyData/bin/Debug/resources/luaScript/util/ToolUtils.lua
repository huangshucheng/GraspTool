local ToolUtils = {}
--[[
@brief 获取Lua串中int值
]]--
function ToolUtils.getLuaIntValue(luaString,variable)
    local value = 0
    local vs = {}
    vs = string.split(luaString, ";")
    for i = 1,#vs do
        local vss = {}
        vss = string.split(vs[i], "=")
        if (#vss >= 2 and vss[1] == variable)then
            value = tonumber(vss[2])
            return value
        end
    end
    return value
end

--[[
@brief 获取Lua串中Str值
]]--
function ToolUtils.getLuaStrValue(luaString,  variable)
    local value = ""
    local vs = {}
    vs = string.split(luaString, ";")
    for i = 1,#vs do
        local vss = {}
        vss = string.split(vs[i], "=")
        if (#vss >= 2 and vss[1] == variable)then
            value = vss[2]
            if (string.len(value) >= 2)then
                if (string.sub(value,1,1) == "\'" and string.sub(value,#value,#value)  == "\'")then
                    value = string.sub(value,2,string.len(value) - 1)
                end
            end
            return value
        end
    end
    return value
end

--[[
@brief 序列化字符串
]]--
function ToolUtils.serialize(obj)  
    local lua = ""  
    local t = type(obj)  
    if t == "number" then  
        lua = lua .. obj  
    elseif t == "boolean" then  
        lua = lua .. tostring(obj)  
    elseif t == "string" then  
        lua = lua .. string.format("%q", obj)  
    elseif t == "table" then  
        lua = lua .. "{"  
        for k, v in pairs(obj) do  
            lua = lua .. "[" .. ToolUtils.serialize(k) .. "]=" .. ToolUtils.serialize(v) .. ","  
        end  
        local metatable = getmetatable(obj)  
        if metatable ~= nil and type(metatable.__index) == "table" then  
            for k, v in pairs(metatable.__index) do  
                lua = lua .. "[" .. ToolUtils.serialize(k) .. "]=" .. ToolUtils.serialize(v) .. ","  
            end  
        end  
        lua = lua .. "}"  
    elseif t == "nil" then  
        return nil  
    else  
        error("can not serialize a " .. t .. " type.")  
    end  
    return lua  
end

--[[
@brief 反序列化字符串
]]--
function ToolUtils.unserialize(lua)  
    local t = type(lua)  
    if t == "nil" or lua == "" then  
        return nil  
    elseif t == "number" or t == "string" or t == "boolean" then  
        lua = tostring(lua)  
    else  
        error("can not unserialize a " .. t .. " type.")  
    end  
    lua = "return " .. lua  
    local func = loadstring(lua)  
    if func == nil then  
        return nil  
    end  
    return func()  
end

--[[
@brief 获取文件的大小
]]--
function ToolUtils.getFileSize(filePath)
    local file = io.open(filePath,"r+")
    if not file then
        return 0
    end
    local size = file:seek("end")
    file:close()
    return size
end

--[[
    @brief 时间
    paramStr = "2017-07-26 00:00:00"
]]
function ToolUtils.strToTime(paramStr)
	local begin_list = string.split(paramStr, " ")
	local begin_date_str = string.format("%s", begin_list[1])
	local begin_time_str = string.format("%s", begin_list[2])
	local begin_date_list = string.split(begin_date_str, "-")
	local being_time_list = string.split(begin_time_str, ":")
	local t1 = {
		year = begin_date_list[1],
		month = begin_date_list[2],
		day = begin_date_list[3],
		hour = being_time_list[1],
		min = being_time_list[2],
		sec = being_time_list[3],
	}
	return os.time(t1)
end

--字符串转为16进制输出
function ToolUtils.bin2hex(s)
    s = string.gsub(s,"(.)",function (x) return string.format("%02X ",string.byte(x)) end)
    return s
end

--16进制转字节数组
function ToolUtils.hex2bin(hexstr)
    local h2b = {
        ["0"] = 0,
        ["1"] = 1,
        ["2"] = 2,
        ["3"] = 3,
        ["4"] = 4,
        ["5"] = 5,
        ["6"] = 6,
        ["7"] = 7,
        ["8"] = 8,
        ["9"] = 9,
        ["A"] = 10,
        ["B"] = 11,
        ["C"] = 12,
        ["D"] = 13,
        ["E"] = 14,
        ["F"] = 15
    }
    local s = string.gsub(hexstr, "(.)(.)", function ( h, l )
         return string.char(h2b[h]*16+h2b[l])
    end)
    return s
end

return ToolUtils