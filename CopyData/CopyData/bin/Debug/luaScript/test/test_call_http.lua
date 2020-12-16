local Define = require("luaScript.config.Define")
local HttpTask = require("luaScript.task.HttpTask")
local FindData = require("luaScript.data.FindData")
local CSFun = require("luaScript.util.CSFun")

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

local function doOneTaskHttpReq(userData, t_list, token_tb, callback)
	if not t_list then return end
	local task = HttpTask.new()
	task:setUrl(t_list.url)
	:setTaskName(t_list.taskName)
	:setMethod(t_list.method)
	:setReqCount(t_list.reqCount)
	:setPreTaskName(t_list.preTaskName)
	:setUrlBody(t_list.urlBody)
	:setPostBody(t_list.postBody)
	:setDelay(t_list.delay)
	:setUserData(userData)
	:addHeader(token_tb)
	:setCookies(token_tb[Define.COOKIE_NAME])
	:start(callback)
end

local function onResponseCallBack(httpRes, task)
	-- print("hcc>>ret: " .. tostring(ret))
	httpRes = (httpRes == nil or httpRes == "") and " empty" or httpRes
	print("hcc>> index>> " .. task:getUserData() .. "  ,name>> " .. task:getTaskName() .. "   ,ret>> ".. tostring(httpRes));
	-- print("hcc>> index: " .. task:getUserData());
	-- print("ret:" .. task:getUserData() .. " >>" .. httpRes)
	--[[
	for key, t_list_next in pairs(Define.NEXT_TASK_LIST_URL) do
		local curTaskName = task:getTaskName() or ""
		local preTaskName =	t_list_next.preTaskName or ""

		if curTaskName ~= "" and preTaskName ~= "" then
			if string.find(curTaskName, preTaskName) or string.find(preTaskName, curTaskName) then
				doOneTaskHttpReq(task:getUserData(), t_list_next, task:getHeader(), onResponseCallBack) -- 主要修改t_list_next 的参数来请求 来进行下一个请求
				break
			end
		end
	end
	--]]
end

function testCall()
	----[[
	local tokenList = FindData:getInstance():getTokenList()
	local topToken = FindData:getInstance():getTop()

	local reqHttpByTaskList = function(idx, token_tb)
		for key, t_list in pairs(Define.TASK_LIST_URL) do
			doOneTaskHttpReq(idx, t_list, token_tb, onResponseCallBack)
		end
	end

	-- for idx, token_tb in pairs(tokenList) do
	-- 	reqHttpByTaskList(idx, token_tb)
	-- end

	if topToken then
		reqHttpByTaskList(1, topToken)
	end

	--]]

	--[[
	local cookies = "cookies_a=avlue1;cookies_b=cvalue2"
	for i = 1 , 1 do
		-- local ret = CSFun.httpReq("www.baidu.com",0, dic,"urlbody=body","postbody=body", nil)
		CSFun.httpReqAsync("www.baidu.com",nil,nil,nil,nil,nil, function(ret)
			print("ret:" .. ret);
		end)
	end
	--]]

	-- CSFun.SetTimeOut(1.5, function()
	-- 	print("hcc>>timeout>>>>>>>>>>>>>>>>>>>>>");
	-- end)

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