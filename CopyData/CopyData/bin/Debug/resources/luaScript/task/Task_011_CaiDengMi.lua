--[[一汽丰田抽奖]]
--帐号被封了
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)
local CSFun 		= require("resources.luaScript.util.CSFun")
local StringUtils 		= require("resources.luaScript.util.StringUtils")

local GET 		= TaskBase.GET
local POST 		= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "hd.faisco.cn"
TaskTMP.DEFAULT_KABAO_COUNT 	= 50
TaskTMP.IS_USE_FULL_REQDATA 	= true
TaskTMP.IS_AUTO_DO_ACTION 		= false
TaskTMP.DATA_TO_FIND_ARRAY 		= 
{
	"ajax/hdgameOther_h.jsp?cmd=getGroupPlayerJoin",
}

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8",
	["Accept"]  = "application/json, text/javascript, */*; q=0.01",
	["Referer"] = "https://14391677-118.hd.faisco.cn/14391677/NqK0G-JmlpbxNRkLlRnaVA/nldtz.html?_source=1"
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "答题抽奖~",
		-- url = "https://14391677-118.hd.faisco.cn/api/result?aid=14391677&openId=oosnVwnDB7GUkAf7n0UY0nJ0jesc&achieveToken=MjExMzU3MjI3NjYw&playerOrigin=3&_openId=oosnVwnDB7GUkAf7n0UY0nJ0jesc",
		url = "https://14391677-118.hd.faisco.cn/api/result",
		method = POST,
		reqCount = 1,
		urlBody = "",
		-- postBody = "gameId=118&style=85&userName=C%E5%B0%8FC&isPub=&headImg=https%3A%2F%2Fthirdwx.qlogo.cn%2Fmmopen%2Fvi_32%2FQ0j4TwGTfTLOM1vrz1GmkWppA3Sjqh0EQleoibWHN2Af3pfPkn5icNmZet9vibdibicUErrrdsOKwiar3vuO99XicQO0A%2F132&ip=121.41.0.245&provice_gps=&city_gps=&district_gps=&canal=-1&playerOrigin=3&uid=",
		postBody = "",
		delay = 0,
		isKabao = true,
	},
}

function TaskTMP:onBeforeSaveToLocal(tokenTable)
	local tmpTokenTable = clone(tokenTable)
	local retTable = {}
	local reqUrl = tmpTokenTable["ReqUrl"]
	if CSFun.IsSubString(reqUrl, "ajax/hdgameOther_h.jsp?cmd=getGroupPlayerJoin") then
		tmpTokenTable["ReqUrl"] = "https://14391677-118.hd.faisco.cn/api/result"
		tmpTokenTable["Method"] = "POST"
		local rulParamTable = StringUtils.getUrlParamTable(reqUrl)
		local openID = rulParamTable["_openId"]
		tmpTokenTable["UrlBody"] = "aid=14391677&achieveToken=MjExMzU3MjI3NjYw&playerOrigin=3&openId=" .. tostring(openID) .. "&_openId=" .. tostring(openID)

		-- local ipStr = "121.41.0.245"
		local ipStr = "121.41.0." .. math.random(100)
		tmpTokenTable["ReqBody"] = "gameId=118&style=85&userName=C%E5%B0%8FC&isPub=&headImg=https%3A%2F%2Fthirdwx.qlogo.cn%2Fmmopen%2Fvi_32%2FQ0j4TwGTfTLOM1vrz1GmkWppA3Sjqh0EQleoibWHN2Af3pfPkn5icNmZet9vibdibicUErrrdsOKwiar3vuO99XicQO0A%2F132&provice_gps=&city_gps=&district_gps=&canal=-1&playerOrigin=3&&" .. "ip=" .. ipStr .. "&uid="
		table.insert(retTable,tmpTokenTable)
	end
	return retTable
end

--请求服务之前,预留接口以便修改请求参数
function TaskTMP:onBeforeRequest(httpTaskObj)
	local allInfo = httpTaskObj:getRequestInfo()
	dump(allInfo,"allInfo")
end

return TaskTMP