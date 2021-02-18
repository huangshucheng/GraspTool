--[[太平洋抽奖活动]]

local TaskBase 		= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 		= class("TaskTMP", TaskBase)
local GET 			= TaskBase.GET
local POST 			= TaskBase.POST

TaskTMP.FIND_STRING_HOST 	= "wx.cpic.com.cn"
TaskTMP.DATA_TO_FIND_ARRAY 	= {"jwt"}      
TaskTMP.DEFAULT_KABAO_COUNT = 100
TaskTMP.IS_AUTO_DO_ACTION 	= false

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["Content-Type"] = "application/x-www-form-urlencoded",
	["Accept"] = "*/*",
	["account"] = "JKGL",
	["Referer"] = "https://servicewechat.com/wxbde72c050d3988e3/36/page-frame.html",
}

-- 
--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "抽奖~", 
		url = "https://wx.cpic.com.cn/sxwxclub/ihealth/redpacket/openRedPacket",
		method = POST, 
		reqCount = 100,
		urlBody = "", 
		postBody = "src=2&token=undefined", 
		delay = 0,
		isKabao = true,
	},
}

return TaskTMP