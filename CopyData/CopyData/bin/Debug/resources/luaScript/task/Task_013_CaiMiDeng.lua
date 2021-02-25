--[[
一口芝士公众号-猜谜灯
]]
local TaskBase 		= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 		= class("TaskTMP", TaskBase)
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local CSFun 		= require("resources.luaScript.util.CSFun")
local StringUtils 	= require("resources.luaScript.util.StringUtils")
local GET 			= TaskBase.GET
local POST 			= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "res2.rrxiu.net" --域名，方便查找token, 如：hbz.qrmkt.cn
TaskTMP.IS_USE_FULL_REQDATA 	= true        -- 是否保存当前完整的请求数据,下次用当前数据去请求，此时需要在DATA_TO_FIND_ARRAY配置要查找的Url,会用ReqUrl去做对比，一致则保存
TaskTMP.IS_REPEAT_FOREVER 		= false       -- 是否永久做此任务，停不下来(切换任务对象可以停下来)
TaskTMP.IS_AUTO_DO_ACTION 		= false 	  -- 是否自动做任务,是的话会默认把UI选中
TaskTMP.DEFAULT_KABAO_COUNT 	= 1 	      -- 默认卡包次数，需要设置isKabao后才生效
TaskTMP.DEFAULT_INPUT_TEXT 	    = "" 		  -- 输入框默认值

-- IS_USE_FULL_REQDATA == true 查找的是URL链接或链接的子串, 否则就是查找的Header里面的token或CK
TaskTMP.DATA_TO_FIND_ARRAY 		= {
	"https://res2.rrxiu.net/pluginAnswer/v2/answerView/checkActive"
}

-- 额外的请求头,会单独配置到请求头进去,如：{["Refer"]="www.baidu.com"}
TaskTMP.ERQ_HEADER_EXT = {
	["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8",
	["Referer"] = "https://cc.rrxiu.cc/",
	["Accept"]  = "application/json, text/javascript, */*; q=0.01",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "开始答题~", 
		url = "https://res2.rrxiu.net/pluginAnswer/v2/answerView/startAnswer",
		method = GET, 
		reqCount = 1,
		urlBody = "", 
		postBody = "",
		delay = 0,
		isKabao = true,
	},
	{
		curTaskName = "提交成绩~", 
		url = "https://res2.rrxiu.net/pluginAnswer/v2/answerView/endAnswer",
		method = POST, 
		reqCount = 1,
		urlBody = "", 
		postBody = "",
		delay = 0,
		isKabao = true,
	},
	{
		curTaskName = "抽奖~", 
		url = "https://res2.rrxiu.net/pluginAnswer/v2/answerView/grab",
		method = POST, 
		reqCount = 1,
		urlBody = "", 
		postBody = "",
		delay = 0,
		isKabao = true,
	},
}

--客户端抓到token后保存到本地之前,预留接口以便修改保存数据
--[[
requestInfo ={
    "Headers" = {
     	"Cookies" = "reqid=123;uid=456;",
        "token"= "12345",
    },
    "Method"  = "",
    "ReqBody" = "",
    "ReqHost" = "",
    "ReqUrl"  = "",
    "UrlBody" = "",
}
StringUtils方法:
StringUtils.splitUrlWithHost(fullUrl)
StringUtils.splitUrlParam(urlParam)
StringUtils.getUrlParam(fullUrl)
StringUtils.getUrlParamTable(fullUrl)
StringUtils.makeUpUrlByParam(urlParamTable, host)
StringUtils.changeUrlParamByTable(fullUrl, changeTable)
StringUtils.splitCookiesParam(cookiesStr)
]]

function TaskTMP:onBeforeSaveToLocal(requestInfo)
	local tmpTokenTable = clone(requestInfo)
	local retTable = {}
	local reqUrl = tmpTokenTable["ReqUrl"]
	 
	 -- IS_USE_FULL_REQDATA == true 才能用连接来判断，否则只有Header的数据
	 -- 如果抓到这个子串，可以用这条请求信息制造成目标请求信息，保存在本地，方便用来请求
	 -- 可以制造多条本地记录,添加到retTable就行了
     -- wsiteGuid=gerqy5&activeGuid=12bbd0036a5ec3fe74821856c3763eab&wxOpenId=519b76ed0dc405bb4559e29b10bc1e92&identify=519b76ed0dc405bb4559e29b10bc1e92&fg=64118ec1bcae24b20b4ad207eb30c28f

	--开始答题
	local tmpTokenTable_1 = clone(requestInfo)
	if CSFun.IsSubString(reqUrl, "https://res2.rrxiu.net/pluginAnswer/v2/answerView/checkActive") then
		-- "https://res2.rrxiu.net/pluginAnswer/v2/answerView/startAnswer?wsiteGuid=gerqy5&activeGuid=12bbd0036a5ec3fe74821856c3763eab&wxOpenId=b05c0fb3c8a172b8f271ec42ab7cd237&fg=6df13dacc40e4878bd4f2df6ccb662d4&qrc=&qrcty="
		tmpTokenTable_1["ReqUrl"] = "https://res2.rrxiu.net/pluginAnswer/v2/answerView/startAnswer"
		tmpTokenTable_1["Method"] = "GET"
		local tmpReqBody = tmpTokenTable_1["ReqBody"]
		tmpTokenTable_1["UrlBody"] = tmpReqBody
		table.insert(retTable,tmpTokenTable_1)
	end

	--提交成绩
	local tmpTokenTable_3 = clone(requestInfo)
	if CSFun.IsSubString(reqUrl, "https://res2.rrxiu.net/pluginAnswer/v2/answerView/checkActive") then
		tmpTokenTable_3["ReqUrl"] = "https://res2.rrxiu.net/pluginAnswer/v2/answerView/endAnswer"
		tmpTokenTable_3["Method"] = "POST"
		local tmpReqBody = tmpTokenTable_3["ReqBody"]
		local tmpBody = "answerResult=%5B%7B%22score%22%3A%2220%22%2C%22questionType%22%3A%221%22%2C%22question%22%3A%22%E5%A4%AA%E7%9B%91%E5%BC%80%E4%BC%9A%E2%80%94%E2%80%94%EF%BC%88%E6%89%93%E4%B8%80%E5%9B%9B%E5%AD%97%E6%88%90%E8%AF%AD%EF%BC%89%22%2C%22guid%22%3A%228de515fdd9b6e2a4b6ea4a4eb483901f%22%2C%22isRight%22%3Atrue%2C%22codeIndexs%22%3A%5B%22B%22%5D%7D%2C%7B%22score%22%3A%2220%22%2C%22questionType%22%3A%221%22%2C%22question%22%3A%22%E4%B8%80%E4%B8%9D%E4%B8%8D%E6%8C%82%E2%80%94%E2%80%94%EF%BC%88%E6%89%93%E4%B8%80%E5%A4%A9%E6%96%87%E5%90%8D%E7%A7%B0%EF%BC%89%22%2C%22guid%22%3A%22388ecf73ec2b8e7b46691a040f1096f7%22%2C%22isRight%22%3Atrue%2C%22codeIndexs%22%3A%5B%22D%22%5D%7D%2C%7B%22score%22%3A%2220%22%2C%22questionType%22%3A%221%22%2C%22question%22%3A%22%E8%BF%9C%E7%9C%8B%E4%B8%80%E5%A4%B4%E7%89%9B%EF%BC%8C%E8%BF%91%E7%9C%8B%E6%B2%A1%E6%9C%89%E5%A4%B4%E2%80%94%E2%80%94%EF%BC%88%E6%89%93%E4%B8%80%E5%AD%97%EF%BC%89%22%2C%22guid%22%3A%2203124a8ff7ad872c8a0576d3ea5808f0%22%2C%22isRight%22%3Atrue%2C%22codeIndexs%22%3A%5B%22C%22%5D%7D%2C%7B%22score%22%3A%2220%22%2C%22questionType%22%3A%221%22%2C%22question%22%3A%22%E9%A3%9E%E8%A1%8C%E5%91%98%E2%80%94%E2%80%94(%E6%89%93%E4%B8%80%E6%88%90%E8%AF%AD)%22%2C%22guid%22%3A%22f56904effc673141cefe3b0a1899d1e6%22%2C%22isRight%22%3Atrue%2C%22codeIndexs%22%3A%5B%22C%22%5D%7D%2C%7B%22score%22%3A%2220%22%2C%22questionType%22%3A%221%22%2C%22question%22%3A%22%E6%97%A5%E8%BF%91%E9%BB%84%E6%98%8F%E2%80%94%E2%80%94%EF%BC%88%E6%89%93%E4%B8%AD%E5%9B%BD%E4%B8%80%E5%9C%B0%E5%8C%BA%E5%90%8D%EF%BC%89%22%2C%22guid%22%3A%22d4b530e85aad49942c085f9f3bd17cf0%22%2C%22isRight%22%3Afalse%2C%22codeIndexs%22%3A%5B%22A%22%5D%7D%5D&connect=&"
		tmpTokenTable_3["ReqBody"] = tmpBody .. tmpReqBody
		table.insert(retTable,tmpTokenTable_3)
	end

	local tmpTokenTable_2 = clone(requestInfo)
	--抽奖
	if CSFun.IsSubString(reqUrl, "https://res2.rrxiu.net/pluginAnswer/v2/answerView/checkActive") then
		tmpTokenTable_2["ReqUrl"] = "https://res2.rrxiu.net/pluginAnswer/v2/answerView/grab"
		tmpTokenTable_2["Method"] = "POST"
		tmpTokenTable_2["ReqBody"] =  tmpTokenTable_2["ReqBody"]
		table.insert(retTable,tmpTokenTable_2)
	end
	return retTable
end

--请求服务之前,预留接口以便修改请求参数
function TaskTMP:onBeforeRequest(httpTaskObj)
	local reqUrl 	= httpTaskObj:getUrl()
	local urlBody 	= httpTaskObj:getUrlBody()
	local postBody 	= httpTaskObj:getPostBody()
	local headers 	= httpTaskObj:getHeader()
	local allInfo 	= httpTaskObj:getRequestInfo()
-- 	dump(allInfo,"allInfo")
-- end

return TaskTMP

--[[
--提交成绩
General
Method:
POST
URL:
https://res2.rrxiu.net/pluginAnswer/v2/answerView/endAnswer
Protocol:
HTTP/1.1
CURL:
copy as CURL
Header
Host :
res2.rrxiu.net
Content-Type :
application/x-www-form-urlencoded; charset=UTF-8
Origin :
https://cc.rrxiu.cc
Accept-Encoding :
gzip, deflate, br
Connection :
keep-alive
Accept :
application/json, text/javascript, */*; q=0.01
User-Agent :
Mozilla/5.0 (iPhone; CPU iPhone OS 14_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.1(0x1800012a) NetType/WIFI Language/zh_CN
Referer :
https://cc.rrxiu.cc/
Accept-Language :
zh-cn
Cookies
No Cookies
Body
activeGuid=12bbd0036a5ec3fe74821856c3763eab&answerResult=%5B%7B%22score%22%3A%2220%22%2C%22questionType%22%3A%221%22%2C%22question%22%3A%22%E5%A4%AA%E7%9B%91%E5%BC%80%E4%BC%9A%E2%80%94%E2%80%94%EF%BC%88%E6%89%93%E4%B8%80%E5%9B%9B%E5%AD%97%E6%88%90%E8%AF%AD%EF%BC%89%22%2C%22guid%22%3A%228de515fdd9b6e2a4b6ea4a4eb483901f%22%2C%22isRight%22%3Atrue%2C%22codeIndexs%22%3A%5B%22B%22%5D%7D%2C%7B%22score%22%3A%2220%22%2C%22questionType%22%3A%221%22%2C%22question%22%3A%22%E4%B8%80%E4%B8%9D%E4%B8%8D%E6%8C%82%E2%80%94%E2%80%94%EF%BC%88%E6%89%93%E4%B8%80%E5%A4%A9%E6%96%87%E5%90%8D%E7%A7%B0%EF%BC%89%22%2C%22guid%22%3A%22388ecf73ec2b8e7b46691a040f1096f7%22%2C%22isRight%22%3Atrue%2C%22codeIndexs%22%3A%5B%22D%22%5D%7D%2C%7B%22score%22%3A%2220%22%2C%22questionType%22%3A%221%22%2C%22question%22%3A%22%E8%BF%9C%E7%9C%8B%E4%B8%80%E5%A4%B4%E7%89%9B%EF%BC%8C%E8%BF%91%E7%9C%8B%E6%B2%A1%E6%9C%89%E5%A4%B4%E2%80%94%E2%80%94%EF%BC%88%E6%89%93%E4%B8%80%E5%AD%97%EF%BC%89%22%2C%22guid%22%3A%2203124a8ff7ad872c8a0576d3ea5808f0%22%2C%22isRight%22%3Atrue%2C%22codeIndexs%22%3A%5B%22C%22%5D%7D%2C%7B%22score%22%3A%2220%22%2C%22questionType%22%3A%221%22%2C%22question%22%3A%22%E9%A3%9E%E8%A1%8C%E5%91%98%E2%80%94%E2%80%94(%E6%89%93%E4%B8%80%E6%88%90%E8%AF%AD)%22%2C%22guid%22%3A%22f56904effc673141cefe3b0a1899d1e6%22%2C%22isRight%22%3Atrue%2C%22codeIndexs%22%3A%5B%22C%22%5D%7D%2C%7B%22score%22%3A%2220%22%2C%22questionType%22%3A%221%22%2C%22question%22%3A%22%E6%97%A5%E8%BF%91%E9%BB%84%E6%98%8F%E2%80%94%E2%80%94%EF%BC%88%E6%89%93%E4%B8%AD%E5%9B%BD%E4%B8%80%E5%9C%B0%E5%8C%BA%E5%90%8D%EF%BC%89%22%2C%22guid%22%3A%22d4b530e85aad49942c085f9f3bd17cf0%22%2C%22isRight%22%3Afalse%2C%22codeIndexs%22%3A%5B%22A%22%5D%7D%5D&connect=&wxOpenId=519b76ed0dc405bb4559e29b10bc1e92&wsiteGuid=gerqy5&fg=64118ec1bcae24b20b4ad207eb30c28f

------------------------------
--抽奖
General
Method:
POST
URL:
https://res2.rrxiu.net/pluginAnswer/v2/answerView/grab
Protocol:
HTTP/1.1
CURL:
copy as CURL
Header
Host :
res2.rrxiu.net
Content-Type :
application/x-www-form-urlencoded; charset=UTF-8
Origin :
https://cc.rrxiu.cc
Accept-Encoding :
gzip, deflate, br
Connection :
keep-alive
Accept :
application/json, text/javascript, */*; q=0.01
User-Agent :
Mozilla/5.0 (iPhone; CPU iPhone OS 14_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.1(0x1800012a) NetType/WIFI Language/zh_CN
Referer :
https://cc.rrxiu.cc/
Accept-Language :
zh-cn
Cookies
No Cookies
Body
wsiteGuid=gerqy5&activeGuid=12bbd0036a5ec3fe74821856c3763eab&wxOpenId=519b76ed0dc405bb4559e29b10bc1e92&identify=519b76ed0dc405bb4559e29b10bc1e92&fg=64118ec1bcae24b20b4ad207eb30c28f&qrc=&qrcty=
]]