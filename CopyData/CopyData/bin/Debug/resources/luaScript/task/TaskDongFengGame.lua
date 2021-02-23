--[[东风游戏-做任务]]
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)
local CSFun 			= require("resources.luaScript.util.CSFun")
local StringUtils 		= require("resources.luaScript.util.StringUtils")
local LuaCallCShapUI 	= require("resources.luaScript.uiLogic.LuaCallCShapUI")
local GET 		= TaskBase.GET
local POST 		= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "7stars.dffengguang.com.cn"
TaskTMP.DEFAULT_KABAO_COUNT 	= 10
TaskTMP.IS_USE_FULL_REQDATA 	= true       --是否保存当前完整的请求数据,下次用当前数据去请求
TaskTMP.DEFAULT_INPUT_TEXT 		= ""

--需要查找的任务URL
TaskTMP.DATA_TO_FIND_ARRAY 		= 
{
	"https://7stars.dffengguang.com.cn/api/Sf20Task/doTask",
	-- "https://7stars.dffengguang.com.cn/api/Sf20Prize/luckDraw",
}

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["Referer"] = "https://7stars.dffengguang.com.cn/new-year/",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "签到~",
		url = "https://7stars.dffengguang.com.cn/api/Sf20Task/doTask",
		method = POST,
		reqCount = 1,
		urlBody = "",
		postBody = "tid=1&sign=2a9bf5f2ed14b549e063bb14f86531e0",
		-- postBody = "",
		delay = 0,
		isKabao = true,
	},
	{
		curTaskName = "做跑车任务~",
		url = "https://7stars.dffengguang.com.cn/api/Sf20Task/doTask?tid=2",
		method = POST,
		reqCount = 1,
		urlBody = "",
		postBody = "tid=2",
		delay = 0,
		isKabao = true,
	},
	{
		curTaskName = "跑车刷榜~",
		url = "https://7stars.dffengguang.com.cn/api/pao/rank_race",
		method = POST,
		reqCount = 1,
		urlBody = "",
		postBody = "user=58998&map_car=city_500&result=234347&serverTime=1614096888&startTime=084ec778973967c77aae421671659161&race1Time=60dcacf0184473d665d059c34c53ab32&game_infos=%7B%22500%22%3A%7B%22level%22%3A1%2C%22parts%22%3A%7B%22part3%22%3A1%2C%22part4%22%3A1%7D%7D%2C%22580redstar%22%3A%7B%22level%22%3A1%2C%22parts%22%3A%7B%7D%7D%7D&token=4a2285d732c782ce4faa5bfa2f2ba8db&session=58998_1614096648_d03474af72e4872225c016bd5d9e5a55",
		delay = 0,
		isKabao = true,
	},
	{
		curTaskName = "抽奖~",
		url = "https://7stars.dffengguang.com.cn/api/Sf20Prize/luckDraw",
		method = POST,
		reqCount = 1,
		urlBody = "",
		postBody = "sign=d41d8cd98f00b204e9800998ecf8427e", --每次抽奖都用用一个sign
		delay = 0,
		isKabao = true,
	},
}

--找到token后保存在本地前，预留接口以便修改请求内容
function TaskTMP:onBeforeSaveToLocal(tokenTable)
	local tmpTokenTable = clone(tokenTable)
	local retTable = {}
	local reqUrl = tmpTokenTable["ReqUrl"]
	--点击签到 保存签到token
	if CSFun.IsSubString(reqUrl, "https://7stars.dffengguang.com.cn/api/Sf20Task/doTask") then
		table.insert(retTable,tmpTokenTable)
	end

	local tmpTokenTable_2 = clone(tokenTable)
	--点击签到，保存跑车任务token
	if CSFun.IsSubString(reqUrl, "https://7stars.dffengguang.com.cn/api/Sf20Task/doTask") then
		tmpTokenTable_2["ReqUrl"] = "https://7stars.dffengguang.com.cn/api/Sf20Task/doTask?tid=2"
		tmpTokenTable_2["Method"] = "POST"
		tmpTokenTable_2["ReqBody"] = "tid=2"
		table.insert(retTable,tmpTokenTable_2)
	end

	-- if CSFun.IsSubString(reqUrl,"https://7stars.dffengguang.com.cn/api/pao/rank_race") then

	-- end

	return retTable
end

--请求服务之前,预留接口以便修改请求参数
--[[
function TaskTMP:onBeforeRequest(httpTaskObj)
	local reqUrl = httpTaskObj:getUrl()
	local urlBody = httpTaskObj:getUrlBody()
	local postBody = httpTaskObj:getPostBody()
	-- print("reqUrl: " .. reqUrl)
	-- print("urlBody: " .. urlBody)
	-- print("postBody11: " .. postBody)
	if CSFun.IsSubString(reqUrl,"http://bright-dairy.tb21.cn/bright-dairy-h5-2021/game/gameOver") then
		local reqBodyTable = StringUtils.splitUrlParam(postBody)
		local inputStr = LuaCallCShapUI.GetUserInputText()
		reqBodyTable["score"] = inputStr
		local tmpPostBodyStr = StringUtils.makeUpUrlByParam(reqBodyTable)
		-- print("postBody22: " .. tmpPostBodyStr)
		httpTaskObj:setPostBody(tmpPostBodyStr)
	end
end
]]

return TaskTMP

--[[
--签到
Method:POST
URL:https://7stars.dffengguang.com.cn/api/Sf20Task/doTask
Header
Host :7stars.dffengguang.com.cn
Accept :application/json, text/plain, */*
Authorization :Af8DwuaccQsVL5v+x6otlQky69AUkerBtjykrHkN0ySN1JHd5prbdqUh73R0WV/u
Accept-Language :zh-cn
Accept-Encoding :br, gzip, deflate
Content-Type :application/x-www-form-urlencoded
Origin :https://7stars.dffengguang.com.cn
User-Agent :Mozilla/5.0 (iPhone; CPU iPhone OS 11_2_1 like Mac OS X) AppleWebKit/604.4.7 (KHTML, like Gecko) Mobile/15C153 MicroMessenger/7.0.12(0x17000c33) NetType/WIFI Language/zh_CN
Connection :keep-alive
Referer :https://7stars.dffengguang.com.cn/new-year/
Cookie :SERVERID=4ba981984d457cccecc58ecfcea384f3|1614095361|1614095161; Hm_lpvt_9031ef22e2be651cd625aa58fe703b06=1614095332; Hm_lvt_9031ef22e2be651cd625aa58fe703b06=1614095163; PHPSESSID=sv7tshufdgqf58vr7em5gfr413
ReqBody tid=1&sign=2a9bf5f2ed14b549e063bb14f86531e0

----抽奖：
Method: POST
URL:
https://7stars.dffengguang.com.cn/api/Sf20Prize/luckDraw
Protocol:
HTTP/1.1
CURL:
copy as CURL
Header
Host :
7stars.dffengguang.com.cn
Accept :
application/json, text/plain, */*
Authorization :
Af8DwuaccQsVL5v+x6otlQky69AUkerBtjykrHkN0ySN1JHd5prbdqUh73R0WV/u
Accept-Language :
zh-cn
Accept-Encoding :
br, gzip, deflate
Content-Type :
application/x-www-form-urlencoded
Origin :
https://7stars.dffengguang.com.cn
User-Agent :
Mozilla/5.0 (iPhone; CPU iPhone OS 11_2_1 like Mac OS X) AppleWebKit/604.4.7 (KHTML, like Gecko) Mobile/15C153 MicroMessenger/7.0.12(0x17000c33) NetType/WIFI Language/zh_CN
Connection :
keep-alive
Referer :
https://7stars.dffengguang.com.cn/new-year/dismred
Cookie :
SERVERID=4ba981984d457cccecc58ecfcea384f3|1614095902|1614095161; Hm_lpvt_9031ef22e2be651cd625aa58fe703b06=1614095332; Hm_lvt_9031ef22e2be651cd625aa58fe703b06=1614095163; PHPSESSID=sv7tshufdgqf58vr7em5gfr413
Cookies
Name	Value
SERVERID	4ba981984d457cccecc58ecfcea384f3|1614095902|1614095161
Hm_lpvt_9031ef22e2be651cd625aa58fe703b06	1614095332
Hm_lvt_9031ef22e2be651cd625aa58fe703b06	1614095163
PHPSESSID	sv7tshufdgqf58vr7em5gfr413
Body
sign=d41d8cd98f00b204e9800998ecf8427e

---跑车刷榜
General
Method:
POST
URL:
https://7stars.dffengguang.com.cn/api/pao/rank_race
Protocol:
HTTP/1.1
CURL:
copy as CURL
Header
Host :
7stars.dffengguang.com.cn
Content-Type :
application/x-www-form-urlencoded
Origin :
https://7stars.dffengguang.com.cn
Accept-Encoding :
br, gzip, deflate
Cookie :
SERVERID=4ba981984d457cccecc58ecfcea384f3|1614096648|1614095161; Hm_lpvt_df8135cf2470a26f8892c6ede9a07849=1614096639; Hm_lvt_df8135cf2470a26f8892c6ede9a07849=1614096191; Hm_lpvt_9031ef22e2be651cd625aa58fe703b06=1614096621; Hm_lvt_9031ef22e2be651cd625aa58fe703b06=1614095163; guid=a23684e451dc44818c0f70577c640d9d; PHPSESSID=sv7tshufdgqf58vr7em5gfr413
Connection :
keep-alive
Accept :
*/*
User-Agent :
Mozilla/5.0 (iPhone; CPU iPhone OS 11_2_1 like Mac OS X) AppleWebKit/604.4.7 (KHTML, like Gecko) Mobile/15C153 MicroMessenger/7.0.12(0x17000c33) NetType/WIFI Language/zh_CN
Referer :
https://7stars.dffengguang.com.cn/pao/?car=500&mapId=city&redirect=https%3A%2F%2F7stars.dffengguang.com.cn%2Fnew-year%2F%23%2F
Accept-Language :
zh-cn
Cookies
Name	Value
SERVERID	4ba981984d457cccecc58ecfcea384f3|1614096648|1614095161
Hm_lpvt_df8135cf2470a26f8892c6ede9a07849	1614096639
Hm_lvt_df8135cf2470a26f8892c6ede9a07849	1614096191
Hm_lpvt_9031ef22e2be651cd625aa58fe703b06	1614096621
Hm_lvt_9031ef22e2be651cd625aa58fe703b06	1614095163
guid	a23684e451dc44818c0f70577c640d9d
PHPSESSID	sv7tshufdgqf58vr7em5gfr413
Body
user=58998&map_car=city_500&result=234347&serverTime=1614096888&startTime=084ec778973967c77aae421671659161&race1Time=60dcacf0184473d665d059c34c53ab32&game_infos=%7B%22500%22%3A%7B%22level%22%3A1%2C%22parts%22%3A%7B%22part3%22%3A1%2C%22part4%22%3A1%7D%7D%2C%22580redstar%22%3A%7B%22level%22%3A1%2C%22parts%22%3A%7B%7D%7D%7D&token=4a2285d732c782ce4faa5bfa2f2ba8db&session=58998_1614096648_d03474af72e4872225c016bd5d9e5a55

]]