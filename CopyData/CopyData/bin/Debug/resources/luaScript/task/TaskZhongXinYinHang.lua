local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)

local GET = TaskBase.GET
local POST = TaskBase.POST

--ecitic-activity3.socialmind.cn
TaskTMP.FIND_STRING_HOST 		= "huaxia.mktzr.com"
TaskTMP.DATA_TO_FIND_ARRAY 		= {"Cookie"}
TaskTMP.IS_OPEN_RECORD 			= false
-- TaskTMP.DEFAULT_KABAO_COUNT 	= 100

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["Referer"] = "http://huaxia.mktzr.com/huaxia/huaxia-dashuju.html?content=s8arxHxPs1XEyZq6c4ofjJX0%2BICB1kHLXBbKQ2ff%2FHGGBwrQsS60tEbUQK6txQYI2Xt3%2B81jggc1d93KfUAITe4WunUItLHpZ4jCx5BXVRIgaCbcsQNBMu6RosTi2Yp%2F&sign=5dfe3024e6c31ecd50cb61627802a9a5",
	["User-Agent"] = "Mozilla/5.0 (iPhone; CPU iPhone OS 12_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/16G77 MicroMessenger/8.0.1(0x18000125) NetType/WIFI Language/zh_CN",
	["Accept"] = "*/*",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "抽奖~",
		url = "http://huaxia.mktzr.com/api/lottery/lottery",
		method = GET,
		reqCount = 1,
		urlBody = "activityId=108&userId=16118534520179674659960227717692",
		postBody = "",
		delay = 0,
	},
}

return TaskTMP