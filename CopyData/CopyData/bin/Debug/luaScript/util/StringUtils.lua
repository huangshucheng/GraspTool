local StringUtils = {}
-- 分割字符串, splite_time：分割次数
function StringUtils.splitString(str, delimiter, splite_time)
   local args = {}
   local pattern = '(.-)' .. delimiter
   local last_end = 1
   local s, e, cap = string.find(str, pattern, 1)
   local findCount = 0
   while s do
    findCount = findCount + 1
    if s ~= 1 or cap ~= '' then
		  table.insert(args,cap)
      end
      last_end = e + 1
      s, e, cap = string.find(str, pattern, last_end)
      if splite_time then
          if findCount >= splite_time then
             break
          end          
      end
    end
   if last_end <= #str then
      cap = string.sub(str, last_end)
      table.insert(args, cap)
   end
   return args
end

-- 去除字符串头部和尾部的空格 \t等
function StringUtils.trim(str)
	local tmp = string.gsub(str, "^%s+", "")
	tmp = string.gsub(tmp, "%s+$", "")
	return tmp
end

function StringUtils.splitWithTrim(str, delim)
	local args = {}
	local pattern = '(.-)' .. delim
	local last_end = 1
	local s, e, cap = string.find(str, pattern , 1)
	while s do
		local tmp = StringUtils.trim(cap)
		if tmp ~= '' then
      table.insert(args,tmp)
		end
		last_end = e + 1
		s, e, cap = string.find(str, pattern, last_end)
	end
	if last_end <= #str then
		cap = StringUtils.trim(string.sub(str, last_end))
		if cap ~= "" then
      table.insert(args,cap)
		end
	end
	return args
end

-- 切割字符串，返回数组
function StringUtils.cutString(str, c)
	local arr = {}
	local k = 1
	local i = 1
	local j = 1
	while j <= string.len(str) do
    if string.sub(str, j, j) == c then
			if i <= j - 1 then
				arr[k] = string.sub(str, i, j - 1)
				k = k + 1
			end
			i = j + 1
		elseif j == string.len(str) then
			arr[k] = string.sub(str, i, j)
			break
		end
		j = j + 1
	end
	return arr
end

-- 根据首字节获取UTF8需要的字节数
local function getUTF8CharLength(ch)
    local utf8_look_for_table = 
    {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
        2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
        3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
        4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 1, 1,
    }
    return utf8_look_for_table[ch]
end

-- 根据UTF8流获取字符串长度
function StringUtils.getUTF8Length(str)
    local len = 0
    local ptr = 1
    repeat
        local char = string.byte(str, ptr)
        local char_len = getUTF8CharLength(char)
        len = len + 1
        ptr = ptr + char_len
    until(ptr > #str)
    return len
end

function StringUtils.isChinese(str)
    if str == nil or str == "" then
        return false
    end
    local utfLenth = StringUtils.getUTF8Length(str)
    local length = #str
    if length%utfLenth == 3 then
        return true
    else
        return false
    end
end

-- 截取UTF8字符串
function StringUtils.subUTF8String(str, begin, length)
    begin = begin or 1
    length = length or -1 -- length为-1时代表不限制长度
    local ret = ""
    local len = 0
    local ptr = 1
    repeat
        local char = string.byte(str, ptr)
        local char_len = getUTF8CharLength(char)
        len = len + 1
        if len >= begin and (length == -1 or len < begin + length) then
            for i = 0, char_len - 1 do
                ret = ret .. string.char( string.byte(str, ptr + i) )
            end
        end
        ptr = ptr + char_len
    until(ptr > #str)
    return ret
end

-- 字符串换行
function StringUtils.linefeed(str, lineBytes, blankLines)
  if not str then
    print "str is nil"
    return
  end

  if type(str) ~= "string" or type(lineBytes) ~= "number" then
    print "str is not string of type or lineByte is not number of type"
    return
  end

  local resultStr = ""
  local strLen = StringUtils.getUTF8Length(str)
  local feedLines = math.ceil(strLen / lineBytes)
  for i = 1, feedLines do
      for j = i - 1, (i - 1) do
        local startIndex = (0 == j) and 1 or lineBytes * j + 1
        -- local endIndex = lineBytes * i + j > strLen and strLen or lineBytes * i
  	    local lineString = StringUtils.subUTF8String(str, startIndex, lineBytes)
  	    resultStr = resultStr .. lineString

  	    if (0 ~= string.find(lineString, "\n")) then
          for i = 1, blankLines do
            resultStr = resultStr .. "\n"
          end
  	    end
      end
  end
  return resultStr
end

--解析http头，形成table形式
function StringUtils.parseHttpHeader(httpHeaderStr)
    local splitData = StringUtils.splitString(httpHeaderStr, "\n")
    local retTable = {}
    for i,str in ipairs(splitData) do
        local trimStr = StringUtils.trim(str)
        if trimStr ~= "" then
            local splitstr = StringUtils.splitString(trimStr, ":", 1)
            if #splitstr > 1 then
                retTable[splitstr[1]] = splitstr[2]
            end
        end
    end
    return retTable
end

function StringUtils.nullOrEmpty(data)
   return httpRes == nil or httpRes == "";
end

return StringUtils