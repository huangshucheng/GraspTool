
local ok , msg = pcall(function()
	if aaa.msg then
		return "SUCCESS"
	else
		return "FAILED"
	end
end)

-- print(ok)
-- print(msg)
math.randomseed(os.time())
local ranNum = math.random(1000)
print("ranNum" , ranNum)