
--test
local dic = {
	["Accept"] = "application/json, text/plain, */*",
	["Proxy-Connection"] = "keep-alive",
	["X-Requested-With"] = "XMLHttpRequest",
	["Accept-Encoding"] = "gzip, deflate",
	["Accept-Language"] = "keep-alive",
	["token"] = "keep-alive",
	["Content-Type"] = "application/x-www-form-urlencoded",
	-- ["Content-Length"] = "0",
	["Connection"] = "keep-alive",
	["User-Agent"] = "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13G34 MicroMessenger/7.0.9(0x17000929) NetType/WIFI Language/zh_CN",
}

-- local ret = httpRequest("www.baidu.com",0, dic, "","")
-- httpRequestAsync("www.baidu.com",0, nil, nil, nil, function(ret)
-- 	print("hcc>>ret: " .. tostring(ret))
-- end)

-- print("hcc>>ret: " .. tostring(ret))

-- httpRequestAsync("www.baidu.com", 0, nil, nil, nil)
-- httpRequestAsync("www.baidu.com",0, dic,"hcc=fuck","postbody=body",function(ret)
-- 	print("hcc>>ret: " .. tostring(ret))
-- end)

-- local ret = httpRequestAsync("www.baidu.com",0, dic,"hcc=fuck","postbody=body")

function testCall()
	httpRequestAsync("www.baidu.com",0, dic,"hcc=fuck","postbody=body",function(ret)
		print("hcc>>ret: " .. tostring(ret))
		LogOut(ret)
	end)
	LogOut("test call \n\n");
end