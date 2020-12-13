local Define = require("luaScript.config.Define")
local HttpTask = require("luaScript.task.HttpTask")
local FindData = require("luaScript.data.FindData")

--test
local dic = {
	["Accept"] = "application/json, text/plain, */*",
	["Proxy-Connection"] = "keep-alive",
	["X-Requested-With"] = "XMLHttpRequest",
	["Accept-Encoding"] = "gzip, deflate",
	["Accept-Language"] = "keep-alive",
	["token"] = "keep-alive",
	["Content-Type"] = "application/x-www-form-urlencoded",
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

local function doOneTaskHttpReq(index, task_table, head_token_ex, callback)
	if not task_table then return end
	local task = HttpTask.new()
	task:setUrl(task_table.url)
	:setTaskName(task_table.taskName)
	:setMethod(task_table.method)
	:setReqCount(task_table.reqCount)
	:setPreTaskName(task_table.preTaskName)
	:setUrlBody(task_table.urlBody)
	:setPostBody(task_table.postBody)
	:setUserData(index)
	:addHeader(head_token_ex)
	:start(callback)
end

local function onResponseCallBack(httpRes, task)
	-- print("hcc>>ret: " .. tostring(ret))
	httpRes = (httpRes == nil or httpRes == "") and " empty" or httpRes
	LogOut("hcc>> index>> " .. task:getUserData() .. "  ,name>> " .. task:getTaskName() .. "   ,ret>> ".. tostring(httpRes));
	-- LogOut("hcc>> index: " .. task:getUserData());
	-- LogOut("ret:" .. task:getUserData() .. " >>" .. httpRes)
	----[[
	for key, t in pairs(Define.NEXT_TASK_LIST_URL) do
		local curTaskName = task:getTaskName() or ""
		local preTaskName =	t.preTaskName or ""

		if curTaskName ~= "" and preTaskName ~= "" then
			if string.find(curTaskName, preTaskName) or string.find(preTaskName, curTaskName) then
				doOneTaskHttpReq(task:getUserData(), t, task:getHeader(), onResponseCallBack)
				break
			end
		end
	end
	--]]
end

function testCall()
	----[[
	local tokenList = FindData:getInstance():getTokenList()

	local reqHttpByTaskList = function(idx, token_tb)
		for key, t in pairs(Define.TASK_LIST_URL) do
			doOneTaskHttpReq(idx, t, token_tb, onResponseCallBack)
		end
	end

	for idx, token_tb in pairs(tokenList) do
		reqHttpByTaskList(idx, token_tb)
	end
	----]]

	--[[
	for i = 1 , 2 do
		httpRequestAsync("www.baidu.com",1, dic,"urlbody=body","postbody=body",function(ret)
			-- onResponseCallBack(ret)
			LogOut("test call \n\n");
		end)
	end
	--]]

end