function splitString(str, delimiter, splite_time)
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

function table.nums(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

--talble是否相等
function table.like(first, second)
    if type(first) ~= "table" or type(second) ~= "table" then
        return false
    end
    if table.nums(first) ~= table.nums(second) then
        return false
    end

    for k,v in pairs(first) do
        
        if not second[k] then
            return false
        end

        if v ~= second[k] then
            return false
        end

    end

    return true
end


local strToFind = "[reqHeader<hbz.qrmkt.cn>:443"
local oriStr = "[reqHeader<hbz.qrmkt.cn"

-- local pattern = '(.-)reqHeader<hbz.qrmkt.cn'
local pattern = 'reqHeader<hbz.qrmkt.cn'


-- local s, e, cap = string.find(strToFind, pattern,1)

-- print(s , e , cap)


local stringForSplit = "hcc:123:456 : 789"
local stringForSplit = "hcc123456789"

local ret = splitString(stringForSplit,":",1)

-- for k,v in pairs(ret) do
-- 	print(k,v)
-- end

local tb1 = {123}
local tb2 = {121}

local isSame = table.like(tb1, tb2)
print(isSame)

local token_tb = {1,2,3,4}
local token_tb = {
	["Content-Type"] = "application/x-www-form-urlencoded",
	["token"] = "tokenlllll",
}
local conStr = table.concat(token_tb,"") or ""
print(conStr)