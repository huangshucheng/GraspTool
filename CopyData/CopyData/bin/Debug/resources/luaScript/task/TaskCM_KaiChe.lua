--[[中荷人寿-开车]]
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)
local CSFun 		= require("resources.luaScript.util.CSFun")
local StringUtils 	= require("resources.luaScript.util.StringUtils")
local GET 		= TaskBase.GET
local POST 		= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "zhrs.ijoynet.com"
TaskTMP.DEFAULT_KABAO_COUNT 	= 100
TaskTMP.IS_USE_FULL_REQDATA 	= true       --是否保存当前完整的请求数据,下次用当前数据去请求

--需要查找的任务URL
TaskTMP.DATA_TO_FIND_ARRAY 		= 
{
	"https://zhrs.ijoynet.com/zhrs/game/start", --开车开始
	"https://zhrs.ijoynet.com/zhrs/game/end", --开车结束
	"https://zhrs.ijoynet.com/zhrs/prize/upgradePick", --开车后抽奖
	"https://zhrs.ijoynet.com/zhrs/prize/oclockPick", --晚8点抽奖
}

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["Referer"] = "https://zhrs.ijoynet.com/game/index.html",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "开车开始~",
		url = "https://zhrs.ijoynet.com/zhrs/game/start",
		method = GET,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 0,
		isKabao = false,
	},
	{
		curTaskName = "开车结束~",
		url = "https://zhrs.ijoynet.com/zhrs/game/end",
		method = GET,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 5,
		isKabao = false,
	},
	{
		curTaskName = "开车后抽奖~",
		url = "https://zhrs.ijoynet.com/zhrs/prize/upgradePick",
		method = GET,
		reqCount = 100,
		urlBody = "",
		postBody = "",
		delay = 0,
		isKabao = true,
	},
	{
		curTaskName = "晚八点抽奖~",
		url = "https://zhrs.ijoynet.com/zhrs/prize/oclockPick",
		method = GET,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 0,
		isKabao = true,
	},
}

--找到token后，预留接口以便修改请求内容
function TaskTMP:onBeforeSaveToLocal(tokenTable)
	local tmpTokenTable = clone(tokenTable)
	local retTable = {}
	local reqUrl = tmpTokenTable["ReqUrl"]
	if CSFun.IsSubString(reqUrl, "https://zhrs.ijoynet.com/zhrs/game/end") then
		--替换Url里面的参数
		local tmpUrl = StringUtils.changeUrlParamByTable(reqUrl,{["points"] = 100})
		tmpTokenTable["ReqUrl"] = tmpUrl
		table.insert(retTable,tmpTokenTable)
	elseif CSFun.IsSubString(reqUrl, "https://zhrs.ijoynet.com/zhrs/prize/upgradePick") then  --抽奖的四个接口，通过一个接口修改而来
		local tmpUrl_1 = StringUtils.changeUrlParamByTable(reqUrl,{["carNo"] = 2})
		local tmpUrl_2 = StringUtils.changeUrlParamByTable(reqUrl,{["carNo"] = 3})
		local tmpUrl_3 = StringUtils.changeUrlParamByTable(reqUrl,{["carNo"] = 4})
		local tmpUrl_4 = StringUtils.changeUrlParamByTable(reqUrl,{["carNo"] = 5})
		local tmp_1 = clone(tmpTokenTable)
		local tmp_2 = clone(tmpTokenTable)
		local tmp_3 = clone(tmpTokenTable)
		local tmp_4 = clone(tmpTokenTable)
		tmp_1["ReqUrl"] = tmpUrl_1
		tmp_2["ReqUrl"] = tmpUrl_2
		tmp_3["ReqUrl"] = tmpUrl_3
		tmp_4["ReqUrl"] = tmpUrl_4
		table.insert(retTable, tmp_1)
		table.insert(retTable, tmp_2)
		table.insert(retTable, tmp_3)
		table.insert(retTable, tmp_4)
	elseif CSFun.IsSubString(reqUrl, "https://zhrs.ijoynet.com/zhrs/prize/oclockPick") then
	end
	return retTable
end

return TaskTMP