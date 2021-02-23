--[[抢元宵-游戏刷分活动]]

local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)
local CSFun 			= require("resources.luaScript.util.CSFun")
local StringUtils 		= require("resources.luaScript.util.StringUtils")
local LuaCallCShapUI 	= require("resources.luaScript.uiLogic.LuaCallCShapUI")
local GET 		= TaskBase.GET
local POST 		= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "22132418-68.hd.faisco.cn"
TaskTMP.DEFAULT_KABAO_COUNT 	= 1
TaskTMP.IS_USE_FULL_REQDATA 	= true       --是否保存当前完整的请求数据,下次用当前数据去请求
TaskTMP.DEFAULT_INPUT_TEXT 		= "420"

--需要查找的任务URL
TaskTMP.DATA_TO_FIND_ARRAY 		= 
{
	-- https://22132418-68.hd.faisco.cn/api/playerJoinGame/setAchieve?aid=22132418&playerId=0&gameScore=410&playerOrigin=3&_openId=oosnVwnDB7GUkAf7n0UY0nJ0jesc
	"https://22132418-68.hd.faisco.cn/api/playerJoinGame/setAchieve", --设置分数
}

TaskTMP.ERQ_HEADER_EXT = {
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "设置分数~",
		url = "https://22132418-68.hd.faisco.cn/api/playerJoinGame/setAchieve",
		method = POST,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 0,
		isKabao = true,
	},
}

--找到token后保存在本地前，预留接口以便修改请求内容
function TaskTMP:onBeforeSaveToLocal(tokenTable)
	local tmpTokenTable = clone(tokenTable)
	local retTable = {}
	local reqUrl = tmpTokenTable["ReqUrl"]
	if CSFun.IsSubString(reqUrl, "https://22132418-68.hd.faisco.cn/api/playerJoinGame/setAchieve") then
		local inputStr = LuaCallCShapUI.GetUserInputText()
		local retUrl = StringUtils.changeUrlParamByTable(reqUrl, {["gameScore"] = inputStr})
		tmpTokenTable["ReqUrl"] = retUrl
		table.insert(retTable,tmpTokenTable)
	end
	return retTable
end

--请求服务之前,预留接口以便修改请求参数
function TaskTMP:onBeforeRequest(httpTaskObj)
	local reqUrl = httpTaskObj:getUrl()
	local urlBody = httpTaskObj:getUrlBody()
	local postBody = httpTaskObj:getPostBody()
	if CSFun.IsSubString(reqUrl,"https://22132418-68.hd.faisco.cn/api/playerJoinGame/setAchieve") then
		local inputStr = LuaCallCShapUI.GetUserInputText()
		local retUrl = StringUtils.changeUrlParamByTable(reqUrl,{["gameScore"] = inputStr})
		httpTaskObj:setUrl(retUrl)
	end
end

return TaskTMP



--[[
General
Method:
POST
URL:
https://22132418-68.hd.faisco.cn/api/playerJoinGame/setAchieve?aid=22132418&playerId=0&gameScore=410&playerOrigin=3&_openId=oosnVwnDB7GUkAf7n0UY0nJ0jesc
Protocol:
HTTP/1.1
CURL:
copy as CURL
Header
Host :
22132418-68.hd.faisco.cn
Accept :
*/*
X-Requested-With :
XMLHttpRequest
Accept-Language :
zh-cn
Accept-Encoding :
gzip, deflate, br
Content-Type :
application/x-www-form-urlencoded; charset=UTF-8
Origin :
https://22132418-68.hd.faisco.cn
User-Agent :
Mozilla/5.0 (iPhone; CPU iPhone OS 14_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.1(0x1800012a) NetType/WIFI Language/zh_CN
Connection :
keep-alive
Referer :
https://22132418-68.hd.faisco.cn/22132418/YKfU8XeJAgQ3D4cRK3mArg/bhmn.html?isOfficialLianjie=false&shareDeep=5&eleUid=&otherplayer=oosnVwsr-n33JUiDnlLOD9JY9o6M&editQrcode=true&_origin=3&flyerfid=&_source=3&canal=-1&notP4Share=false&jumpFlag=true
Cookie :
gps_city=; gps_district=; gps_province=; _AID=22132418; oid_22132418_68=oosnVwnDB7GUkAf7n0UY0nJ0jesc; otherplayer_22132418_68=oosnVwsr-n33JUiDnlLOD9JY9o6M; oppenId_20160112wxa59a3f7d4c9aafcf=ooVT16WLr0U8upMCd90LRagRg1mA; t_wxa59a3f7d4c9aafcf=ooVT16WLr0U8upMCd90LRagRg1mA; faiOpenId=oosnVwnDB7GUkAf7n0UY0nJ0jesc; hdOpenIdSign_22132418=2ff8c180cbda0be593c0162044a875e5; scope=snsapi_base; oid_20914653_23=oosnVwnDB7GUkAf7n0UY0nJ0jesc; oid_12498401_14=oosnVwnDB7GUkAf7n0UY0nJ0jesc; oid_12498401_11=oosnVwnDB7GUkAf7n0UY0nJ0jesc; oid_12498401_13=oosnVwnDB7GUkAf7n0UY0nJ0jesc; oid_12498401_12=oosnVwnDB7GUkAf7n0UY0nJ0jesc; oid_19079850_87=oosnVwnDB7GUkAf7n0UY0nJ0jesc; oid_14758447_78=oosnVwnDB7GUkAf7n0UY0nJ0jesc; oppenId_20160112wx8f5b0d63b4c13a04=octqpuLGyN0F4vpKIEd3hXaYlLzU; t_wx8f5b0d63b4c13a04=octqpuLGyN0F4vpKIEd3hXaYlLzU; oid_21481884_12=oosnVwnDB7GUkAf7n0UY0nJ0jesc; oid_22409439_11=oosnVwnDB7GUkAf7n0UY0nJ0jesc; _cliid=Cv_mgr8pYG8KGBuC
Cookies
Name	Value
gps_city	
gps_district	
gps_province	
_AID	22132418
oid_22132418_68	oosnVwnDB7GUkAf7n0UY0nJ0jesc
otherplayer_22132418_68	oosnVwsr-n33JUiDnlLOD9JY9o6M
oppenId_20160112wxa59a3f7d4c9aafcf	ooVT16WLr0U8upMCd90LRagRg1mA
t_wxa59a3f7d4c9aafcf	ooVT16WLr0U8upMCd90LRagRg1mA
faiOpenId	oosnVwnDB7GUkAf7n0UY0nJ0jesc
hdOpenIdSign_22132418	2ff8c180cbda0be593c0162044a875e5
scope	snsapi_base
oid_20914653_23	oosnVwnDB7GUkAf7n0UY0nJ0jesc
oid_12498401_14	oosnVwnDB7GUkAf7n0UY0nJ0jesc
oid_12498401_11	oosnVwnDB7GUkAf7n0UY0nJ0jesc
oid_12498401_13	oosnVwnDB7GUkAf7n0UY0nJ0jesc
oid_12498401_12	oosnVwnDB7GUkAf7n0UY0nJ0jesc
oid_19079850_87	oosnVwnDB7GUkAf7n0UY0nJ0jesc
oid_14758447_78	oosnVwnDB7GUkAf7n0UY0nJ0jesc
oppenId_20160112wx8f5b0d63b4c13a04	octqpuLGyN0F4vpKIEd3hXaYlLzU
t_wx8f5b0d63b4c13a04	octqpuLGyN0F4vpKIEd3hXaYlLzU
oid_21481884_12	oosnVwnDB7GUkAf7n0UY0nJ0jesc
oid_22409439_11	oosnVwnDB7GUkAf7n0UY0nJ0jesc
_cliid	Cv_mgr8pYG8KGBuC
Body
gameId=68&style=14&achieve=IjQxMCI%3DeGNk5jYm1TY13zMz5WOxdDMmVjNzMWZ&openId=oosnVwnDB7GUkAf7n0UY0nJ0jesc&name=C%E5%B0%8FC&awardInfoB=7e42df4320870969d062403bd39adb29&province_gps=&city_gps=&district_gps=&info=%7B%22headImg%22%3A%22https%3A%2F%2Fthirdwx.qlogo.cn%2Fmmopen%2Fvi_32%2FQ0j4TwGTfTKBCR7IaiaIP5qeJIySmJwiaEdxNiaLHcmcoa5D9YTyfdcUgqWIpzFjAL4D4JtPicJkpibH22MqgbfVpGA%2F132%22%2C%22ip%22%3A%22121.41.0.245%22%7D&fromPlayer=oosnVwsr-n33JUiDnlLOD9JY9o6M&canal=-1&playerOrigin=3&uid=


////返回：
{"success":true,"isSuc":true,"rt":0,"rank":1421,"beat":99,"playerId":70890,"score":"410","drawLimit":120.0,"bestCostTime":9999.0,"achieveToken":"LTIwODg1MDY3Mjg0MTA=","msg":"设置成绩成功"} 
]]