
local ok , msg = pcall(function()
	if aaa.msg then
		return "SUCCESS"
	else
		return "FAILED"
	end
end)

print(ok)
print(msg)