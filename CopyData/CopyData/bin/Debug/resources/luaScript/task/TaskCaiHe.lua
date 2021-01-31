--[[采荷活动]]

local TaskBase 		= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 		= class("TaskTMP", TaskBase)
local GET 			= TaskBase.GET
local POST 			= TaskBase.POST

TaskTMP.FIND_STRING_HOST 	= "hbh.qrmkt.cn"  --域名，方便查找token
TaskTMP.DATA_TO_FIND_ARRAY 	= {"token"}      --需要查找的taken 或者cookie
TaskTMP.DEFAULT_KABAO_COUNT = 100 	-- 默认卡包次数，需要设置isKabao后才生效

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["Content-Type"] = "application/x-www-form-urlencoded",
}

-- 
--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "登录领取~", 
		url = "https://hbh.qrmkt.cn/hbact/zt/ht/main/nqGive",
		method = GET, 
		reqCount = 10,
		urlBody = "", 
		postBody = "", 
		delay = 0,
		isKabao = false,
	},
	{
		curTaskName = "抽奖~", 
		url = "https://hbh.qrmkt.cn/hbact/zt/ht/rt/rtDraw",
		method = POST, 
		reqCount = 100,
		urlBody = "", 
		postBody = "", 
		delay = 0,
		isKabao = true,
	},
}
return TaskTMP