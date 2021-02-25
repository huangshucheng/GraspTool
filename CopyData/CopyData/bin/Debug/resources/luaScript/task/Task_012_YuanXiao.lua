--[[
平顶山抽奖活动
]]
local TaskBase 		= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 		= class("TaskTMP", TaskBase)
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local CSFun 		= require("resources.luaScript.util.CSFun")
local StringUtils 	= require("resources.luaScript.util.StringUtils")
local GET 			= TaskBase.GET
local POST 			= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "yx.zksjbank.top" --域名，方便查找token, 如：hbz.qrmkt.cn
TaskTMP.IS_USE_FULL_REQDATA 	= false        -- 是否保存当前完整的请求数据,下次用当前数据去请求，此时需要在DATA_TO_FIND_ARRAY配置要查找的Url,会用ReqUrl去做对比，一致则保存
TaskTMP.IS_REPEAT_FOREVER 		= false       -- 是否永久做此任务，停不下来(切换任务对象可以停下来)
TaskTMP.IS_AUTO_DO_ACTION 		= false 	  -- 是否自动做任务,是的话会默认把UI选中
TaskTMP.DEFAULT_KABAO_COUNT 	= 50 	      -- 默认卡包次数，需要设置isKabao后才生效
TaskTMP.DEFAULT_INPUT_TEXT 	    = "" 		  -- 输入框默认值

TaskTMP.DATA_TO_FIND_ARRAY 		= {
	"Cookie","Authorization"
}

TaskTMP.ERQ_HEADER_EXT = {
	["Referer"] = "http://yx.zksjbank.top/pyyuanxiao/home/1614269342000",
	["Accept"]  = "application/json, text/plain, */*",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "抽奖~", 
		url = "http://yx.zksjbank.top/yx/pyyuanxiao/api/start_raffle?spid=39",
		method = GET, 
		reqCount = 1,
		urlBody = "", 
		postBody = "",
		delay = 0,
		isKabao = true,
	},
}

return TaskTMP