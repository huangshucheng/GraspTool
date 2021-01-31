local Define = require("resources.luaScript.config.Define")
local HttpTask = require("resources.luaScript.task.base.HttpTask")
local FindData = require("resources.luaScript.data.FindData")
local CSFun = require("resources.luaScript.util.CSFun")
local StringUtils = require("resources.luaScript.util.StringUtils")
local TaskData = require("resources.luaScript.data.TaskData")
local TaskStart = require("resources.luaScript.task.base.TaskStart")
local Sound = require("resources.luaScript.util.Sound")
local LuaCallCShapUI = require("resources.luaScript.uiLogic.LuaCallCShapUI")
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")

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

local test_index = 0
function testCall()
	--[[
	local cookies = "cookies_a=avlue1;cookies_b=cvalue2"
	for i = 1 , 1 do
		-- CSFun.httpReqAsync("www.baidu.com",nil,nil,nil,nil,nil, function(ret)
		local ret = CSFun.httpReqAsync("www.baidu.com",1, dic,"urlbody=body","postbody=body", cookies, function(ret)
			print("ret:" .. ret);
		end)
	end
	--]]
	-- local TaskData = require("resources.luaScript.data.TaskData")
	-- local fileName = TaskData.getCurTask():getSaveFileName()

	-- CSFun.WriteFile(fileName, "zhonklsdjfksjkdlfjklasdjfkakdsfjklaf" .. "众人就撒考虑到房价快乐阿斯加德开了房经理快递费拉水电费啦ad讲课费垃圾啊凉快圣诞节拉开")
	-- CSFun.WriteFile(fileName, "zhonklsdjfksjkdlfjklasdjfkakdsfjklaf")
	-- local path = CSFun.GetCurDir() .. [[\resources\sound\ui_click.wav]]
	-- CSFun.PlayWAVSound(path)
	-- Sound.playTokenSound()
	-- Sound.playFinishTaskSound()
	-- print("中国人")
	-- local fileName = CSFun.GetCurDir() .. [[\resources\luaScript\token\token.lua]]
	--[[
	local readStr = CSFun.ReadFile(fileName)
	print(readStr)
	print(CSFun.Utf8ToDefault("读取文字"))
	local ret = CSFun.StringCompare("中国人", "中国人")
	print("ret>>>>" .. tostring(ret))
	]]

	--[[
	local HttpTask = require("resources.luaScript.task.base.HttpTask")
	local task = HttpTask.new()
	task:setUrl("www.bianfeng.com")
	task:addCallback(function(ret, t)
		print("ret>>>>>>>>>>" .. t:getUrl() .. "  >>>>>>>>" .. t:getResPonseData())
	end)
	task:start()
	--]]

	-- local actTable = {"钻石活动", "活动2", "局欧东就删掉快疯了3"}
	-- local fileName = CSFun.GetCurDir() .. [[\resources\luaScript\config\TaskList.lua]]
	-- local readStr = CSFun.ReadFile(fileName)
	-- -- print("hcc>>>>>>add readStr" .. tostring(readStr))
	-- local actTable = json.decode(readStr)
	-- LuaCallCShapUI.AddActivityToList(actTable)
	-- print("hcc>>>>>>add actTable" .. tostring(actTable))
	--[[
	local act = {
		["钻石活动码a"] = "aaa", 
		["活动2"] = "bbb", 
		["活动3"] = "ccc",
	}
	print(CSFun.Utf8ToDefault(json.encode(act)))
	]]
	-- dump(act, "act..........")
	-- print("test----")
	local header = {
		["Accept"] = "application/json,text/javascript,text/html,text/plain,application/xhtml+xml,application/xml, */*; q=0.01",
		-- ["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
		-- ["Accept"] = "application/json,application/xml;q=0.9,*/*;q=0.8",
		["X-Requested-With"] = "",
		["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8",
		-- ["User-Agent"] = "Mozilla/5.0 (iPhone; CPU iPhone OS 11_2_1 like Mac OS X) AppleWebKit/604.4.7 (KHTML, like Gecko) Version/11.0 Mobile/15C153 Safari/604.1",
		["User-Agent"] = "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13G34 MicroMessenger/7.0.9(0x17000929) NetType/WIFI Language/zh_CN",
		-- ["Connection"] = "keep-alive",
		["token"] = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ7XCJvcmdJZFwiOlwiaGViZWl6aG9uZ3lhblwiLFwiYXBwaWRcIjpcInd4YWU4YmFhZTU2NmFhODc1OFwiLFwib3BlbmlkXCI6XCJvMVVjTTZCbjRVeTdmZzRXNWI1alBGa1JWdXcwXCIsXCJ1bmlvbmlkXCI6XCJvMEhKVjBuMDg4SjRINGhTc1VrQWhLb0pRclpzXCIsXCJsb2dpblRpbWVcIjoxNjA5MDY5NDY5MDkxLFwidGFnXCI6XCIxNjA5MDY5NDY5MDkxSVQxM1RZTkRORDdYTk5QXCIsXCJ1c2VySWRcIjoxMDY3MDkyMDM5fSIsImV4cCI6MTYwOTA3MzA2OX0.WFlz9Rrx62dKbYkqbqG4mwXsBeZhKULxna4zh3C7ez8",
	}
	-- local url = "https://open.weixin.qq.com/qr/code?username=hbzhongyan"
	-- url = "https://tb1.bdstatic.com/tb/r/image/2019-05-22/a5e3c00f38b64d9ff86b2015746e5584.jpg"
	--[[
	local task = HttpTask.new()
	task:setUrlBody("username=hbzhongyan")
	task:setUrl(url)
	-- task:addHeader(header)
	task:addCallback(function(ret, t)
		print("ret>>>>>>>>>>" .. t:getUrl() .. "  >>>>>>>>" .. t:getResPonseData())
	end)
	task:start()
	]]
	-- ShowQRCode(url);
	--[[
	local url = "hbz.qrmkt.cn/hbact/hyr/home/queryActCode"
	local cookies = "token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ7XCJvcmdJZFwiOlwiaGViZWl6aG9uZ3lhblwiLFwiYXBwaWRcIjpcInd4YWU4YmFhZTU2NmFhODc1OFwiLFwib3BlbmlkXCI6XCJvMVVjTTZCbjRVeTdmZzRXNWI1alBGa1JWdXcwXCIsXCJ1bmlvbmlkXCI6XCJvMEhKVjBuMDg4SjRINGhTc1VrQWhLb0pRclpzXCIsXCJsb2dpblRpbWVcIjoxNjA5MDY5NDY5MDkxLFwidGFnXCI6XCIxNjA5MDY5NDY5MDkxSVQxM1RZTkRORDdYTk5QXCIsXCJ1c2VySWRcIjoxMDY3MDkyMDM5fSIsImV4cCI6MTYwOTA3MzA2OX0.WFlz9Rrx62dKbYkqbqG4mwXsBeZhKULxna4zh3C7ez8"
	-- CSFun.httpReqAsync(url, 1 ,header,nil,nil,nil,function(ret) 
	CSFun.ReqHttpByJetyduAsync(url, 0 ,header,nil,nil,nil,function(ret) 
		print("hcc>>>>>>>>>>>>>>" .. ret)
	end)
	local proxy_url = "http://hccfun.com:8001"
	-- local proxy_url = "http://127.0.0.1:8001"
	-- local proxy_url = "127.0.0.1:8001"
	CSFun.IsProxyCanUse(proxy_url,function(ret)
		print("canUse: " .. tostring(ret))
	end)
	]]
	--[[
	print(CSFun.Utf8ToDefault("测试~"))
	local testUrl = "https://zhrs.ijoynet.com/zhrs/game/end?openid=oylYNs10lSSr3CXk38wQkzm_cGc0&points=10&uid=123456"
	local retUrl = StringUtils.changeUrlParamByTable(testUrl,{points = 100,uuuuuid = "chccccccc"})
	print(retUrl)
	]]
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