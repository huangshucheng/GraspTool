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
@brief 将文字控制在可视范围区域
]]--
function ToolUtils.nameToShort(nickName,count)
    local bFlag,ret = pcall(function()
        local VaildUtils = app.util.VaildUtils
        local len = string.utf8len(nickName)
        local maxLen = count or 8
        local tmpLen = 0
        local lastIndex = 0
           
        for i=1,len do
            local tmpChar = string.utf8sub(nickName, i, i)
            --中文和W视觉宽度是其他的2倍
            if VaildUtils.isChinese(tmpChar) or tmpChar=="W" then
                tmpLen = tmpLen + 2
                --大写字母宽度是其他的1.5倍
            elseif VaildUtils.isUpper(tmpChar) then
                tmpLen = tmpLen + 1.5
            else
                tmpLen = tmpLen + 1
            end
            
            if tmpLen < maxLen+2 then
                lastIndex = i
            end
            
            if tmpLen <= maxLen+2 and i == len then
                return nickName
            end
        end       
        if tmpLen > maxLen then
            return string.utf8sub(nickName,1,lastIndex) .. ".."
        else
            return nickName
        end
        
    end)
    if bFlag then
        return ret
    else
        return nickName
    end
end

--[[
@brief 获取两个gps的距离
]]--
function ToolUtils.getGPSDistance(gps1,gps2)
    local EARTH_RADIUS = 6378137--赤道半径(单位m)  

    local function rad(d)
        return d * math.pi / 180.0
    end
    local radLat1 = rad(gps1.lat) 
    local radLat2 = rad(gps2.lat)

    local radLon1 = rad(gps1.lon)  
    local radLon2 = rad(gps2.lon) 

    if (radLat1 < 0)  then
        radLat1 = math.pi / 2 + math.abs(radLat1)
    end  -- south  
    if (radLat1 > 0)  then
        radLat1 = math.pi / 2 - math.abs(radLat1)
    end-- north  
    if (radLon1 < 0) then 
        radLon1 = math.pi * 2 - math.abs(radLon1)
    end-- west  
    if (radLat2 < 0) then 
        radLat2 = math.pi / 2 + math.abs(radLat2)
    end-- south  
    if (radLat2 > 0) then 
        radLat2 = math.pi / 2 - math.abs(radLat2)
    end-- north  
    if (radLon2 < 0) then 
        radLon2 = math.pi * 2 - math.abs(radLon2)
    end-- west  

    local x1 = EARTH_RADIUS * math.cos(radLon1) * math.sin(radLat1);  
    local y1 = EARTH_RADIUS * math.sin(radLon1) * math.sin(radLat1);  
    local z1 = EARTH_RADIUS * math.cos(radLat1);  

    local x2 = EARTH_RADIUS * math.cos(radLon2) * math.sin(radLat2);  
    local y2 = EARTH_RADIUS * math.sin(radLon2) * math.sin(radLat2);  
    local z2 = EARTH_RADIUS * math.cos(radLat2);  

    local d = math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)+ (z1 - z2) * (z1 - z2));  
    local theta = math.acos((EARTH_RADIUS * EARTH_RADIUS + EARTH_RADIUS * EARTH_RADIUS - d * d) / (2 * EARTH_RADIUS * EARTH_RADIUS));  
    local dist = theta * EARTH_RADIUS;  
    return d
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