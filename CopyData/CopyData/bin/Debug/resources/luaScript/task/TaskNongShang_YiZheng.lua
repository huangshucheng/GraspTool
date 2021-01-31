--[[农商银行-仪征]] 
local TaskBase 		= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 		= class("TaskTMP", TaskBase)
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local CSFun 		= require("resources.luaScript.util.CSFun")

local GET = TaskBase.GET
local POST = TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "wxs.yzbank.com"
TaskTMP.DATA_TO_FIND_ARRAY 		= {"XAuthToken","Cookie"}
TaskTMP.IS_OPEN_RECORD 			= false
TaskTMP.DEFAULT_KABAO_COUNT 	= 100 	-- 默认卡包次数，需要设置isKabao后才生效

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["Referer"] = "http://wxs.yzbank.com/win/WxyhServer_YZV5/Areas/VideoRedPacket/Pages/opening.html?mpId=rcb&typeCode=KML",
	["Accept"] = "*/*",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "看视频~", 
		url = "http://wxs.yzbank.com/win/WxyhServer_YZV5/api/VideoRedPacket/VideoRedPacketApi/WatchVideo",
		method = POST, 
		reqCount = 10,
		urlBody = "", 
		postBody = [[{"TypeCode":"KML","VideoId":2}]],
		delay = 0,
		isKabao = false,
	},
	{
		curTaskName = "抽奖~", 
		url = "http://wxs.yzbank.com/win/WxyhServer_YZV5/api/LottApi/Run",
		method = POST, 
		reqCount = 100,
		urlBody = "", 
		postBody = [[{"typeCode":"KML","wxLatitude":30.276674270629883,"wxLongitude":120.09964752197266,"locName":null}]],
		delay = 1,
		isKabao = true,
	},
	{
		--需要抽一次奖品后分享才有用
		curTaskName = "分享~", 
		url = "http://wxs.yzbank.com/win/WxyhServer_YZV5/api/LottApi/Share",
		method = POST, 
		reqCount = 10,
		urlBody = "", 
		postBody = [[{"typeCode":"KML","shareType":"appmessage","url":"http://wxs.yzbank.com/win/WxyhServer_YZV5/Areas/VideoRedPacket/Pages/opening.html?mpId=rcb&typeCode=KML"}]],
		delay = 1,
		isKabao = false,
	},
	{
		curTaskName = "再次抽奖~", 
		url = "http://wxs.yzbank.com/win/WxyhServer_YZV5/api/LottApi/Run",
		method = POST, 
		reqCount = 100,
		urlBody = "", 
		postBody = [[{"typeCode":"KML","wxLatitude":30.276674270629883,"wxLongitude":120.09964752197266,"locName":null}]],
		delay = 1,
		isKabao = true,
	},
}

return TaskTMP