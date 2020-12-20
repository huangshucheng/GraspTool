local Define = require("luaScript.config.Define")
local HttpTask = require("luaScript.task.base.HttpTask")
local FindData = require("luaScript.data.FindData")
local CSFun = require("luaScript.util.CSFun")
local StringUtils = require("luaScript.util.StringUtils")
local TaskData = require("luaScript.data.TaskData")
local TaskStart = require("luaScript.task.base.TaskStart")

--test
local dic = {
	["Accept"] = "application/json, text/plain, */*",
	["Proxy-Connection"] = "keep-alive",
	["X-Requested-With"] = "XMLHttpRequest",
	["Accept-Encoding"] = "gzip, deflate",
	["Accept-Language"] = "keep-alive",
	["token"] = "this is token",
	["Content-Type"] = "application/x-www-form-urlencoded",
	["Connection"] = "keep-alive",
	["User-Agent"] = "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13G34 MicroMessenger/7.0.9(0x17000929) NetType/WIFI Language/zh_CN",
}

-- local ret = HttpRequest("www.baidu.com",0, dic, "","")
-- HttpRequestAsync("www.baidu.com",0, nil, nil, nil, function(ret)
-- 	print("hcc>>ret: " .. tostring(ret))
-- end)

-- print("hcc>>ret: " .. tostring(ret))

-- HttpRequestAsync("www.baidu.com", 0, nil, nil, nil)
-- HttpRequestAsync("www.baidu.com",0, dic,"hcc=fuck","postbody=body",function(ret)
-- 	print("hcc>>ret: " .. tostring(ret))
-- end)

-- local ret = HttpRequestAsync("www.baidu.com",0, dic,"hcc=fuck","postbody=body")


function testCall()
	TaskStart.start()
	--[[
	local cookies = "cookies_a=avlue1;cookies_b=cvalue2"
	for i = 1 , 1 do
		-- CSFun.httpReqAsync("www.baidu.com",nil,nil,nil,nil,nil, function(ret)
		local ret = CSFun.httpReqAsync("www.baidu.com",1, dic,"urlbody=body","postbody=body", cookies, function(ret)
			print("ret:" .. ret);
		end)
	end
	--]]
	-- local TaskData = require("luaScript.data.TaskData")
	-- local fileName = TaskData.getCurTask():getSaveFileName()

	-- CSFun.WriteFile(fileName, "zhonklsdjfksjkdlfjklasdjfkakdsfjklaf" .. "众人就撒考虑到房价快乐阿斯加德开了房经理快递费拉水电费啦ad讲课费垃圾啊凉快圣诞节拉开")
	-- CSFun.WriteFile(fileName, "zhonklsdjfksjkdlfjklasdjfkakdsfjklaf")
end
--[[
[reqHeader<www.baidu.com>] 
GET https://www.baidu.com/?urlbody=body HTTP/1.1
Content-Type: application/x-www-form-urlencoded
Accept: application/json, text/plain, */*
token: this is token
User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13G34 MicroMessenger/7.0.9(0x17000929) NetType/WIFI Language/zh_CN
Accept-Language: keep-alive
Accept-Encoding: gzip, deflate
X-Requested-With: XMLHttpRequest
Host: www.baidu.com
Cookie: token=tokenqqqq; sscookie=bbbbb; cccookie=ccccc; cccc=456789
Connection: Keep-Alive
]]