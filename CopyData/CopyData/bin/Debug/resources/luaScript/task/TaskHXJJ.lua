--[[华夏基金]] 
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)

local GET = TaskBase.GET
local POST = TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "wx.hoyatod.cn"  --域名，方便查找token
TaskTMP.DATA_TO_FIND_ARRAY 		= {"Cookie","Referer",}      --需要查找的taken 或者cookie
TaskTMP.IS_OPEN_RECORD 			= false

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["User-Agent"] = "Mozilla/5.0 (iPhone; CPU iPhone OS 11_2_1 like Mac OS X) AppleWebKit/604.4.7 (KHTML, like Gecko) Mobile/15C153 MicroMessenger/7.0.12(0x17000c33) NetType/WIFI Language/zh_CN",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "抽奖", 
		url = "http://wx.hoyatod.cn/wxh5/hx/hongbao/20210114/WLSUEcodHy8check",
		method = POST, 
		reqCount = 200,
		urlBody = "", 
		postBody = "openid=oePCMuK9NrVSZTa_TEo9BMfZcU4M", 
		delay = 0,
	},
}

--[[
if(data=="0"){
	alert('非法操作！');
}else if(data=="-1"){
	alert('请在微信客户端运行！');
}else if(data=="1"){//活动结束
	showTips($(".hint_common"),'抱歉 <br> 活动结束');
}else if(data=="2"){//超时
	alert('操作时间过长,请重新进入活动！');
}else if(data=="3"){//已中奖
	showTips($(".hint_common"),'您已中过奖了留点机会给 <br> 其他人吧~');
}else if(data=="4"){//机会用完
	showTips($(".hint_common"),'今日抽奖机会已用完 <br> 明天再来吧~');
}else if(data=="5"){//未中奖
	showTips($(".hint2"));
}else{
]]

return TaskTMP