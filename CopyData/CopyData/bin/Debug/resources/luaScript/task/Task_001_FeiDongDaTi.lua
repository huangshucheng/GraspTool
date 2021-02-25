--[[肥东工会 - 答题]] 
local TaskBase 		= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 		= class("TaskTMP", TaskBase)
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local CSFun 		= require("resources.luaScript.util.CSFun")
local GET 			= TaskBase.GET
local POST 			= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "open.ixiaomayun.com"
TaskTMP.IS_USE_FULL_REQDATA 	= true
TaskTMP.DEFAULT_KABAO_COUNT 	= 50 	-- 默认卡包次数，需要设置isKabao后才生效
TaskTMP.IS_REPEAT_FOREVER 		= false

TaskTMP.DATA_TO_FIND_ARRAY 		= {
	"open.ixiaomayun.com/api/Active/Misc/Question"
}


--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8",
	["Referer"] = "http://fdgh202001.open.ixiaomayun.com/api/userActives/218/question/1542/index.html?"
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "抽奖~", 
		url = "open.ixiaomayun.com/api/Active/Misc/Question/submit?activeid=1542",
		method = POST, 
		reqCount = 1,
		urlBody = "", 
		postBody = "",
		delay = 0,
		isKabao = true,
	},
}

--找到token后，预留接口以便修改本地保存的内容
function TaskTMP:onBeforeSaveToLocal(tokenTable)
	local tmpTokenTable = clone(tokenTable)
	local retTable = {}
	local reqUrl = tmpTokenTable["ReqUrl"]
	if CSFun.IsSubString(reqUrl, "open.ixiaomayun.com/api/Active/Misc/Question") then
		tmpTokenTable["ReqUrl"] = "http://fdgh202001.open.ixiaomayun.com/api/Active/Misc/Question/submit?activeid=1542"
		tmpTokenTable["Method"] = "POST"
		tmpTokenTable["ReqBody"] = [[result%5B0%5D%5Bid%5D=1517&result%5B0%5D%5Bappid%5D=218&result%5B0%5D%5Bcontent%5D=%E4%B9%94%E8%A3%85%E5%A8%87%E5%97%94%E6%8A%8A%E5%8F%A3%E5%BC%80%EF%BC%88%E4%BA%8C%E5%AD%97%E5%8F%A4%E4%BB%A3%E6%B0%91%E6%97%8F)&result%5B0%5D%5Bpos%5D=&result%5B0%5D%5Banswer%5D=A&result%5B0%5D%5Bactiveid%5D=1542&result%5B0%5D%5Bchoices%5D%5B0%5D%5Bid%5D=4952&result%5B0%5D%5Bchoices%5D%5B0%5D%5Bindexname%5D=A&result%5B0%5D%5Bchoices%5D%5B0%5D%5Bquestionid%5D=1517&result%5B0%5D%5Bcreatetime%5D=2021-02-23+10%3A27%3A54&result%5B0%5D%5Bstatus%5D=1&result%5B0%5D%5Btype%5D=2&result%5B0%5D%5Bdefault%5D=0&result%5B0%5D%5Bchoice%5D=%E5%A5%B3%E7%9C%9F&result%5B1%5D%5Bid%5D=1482&result%5B1%5D%5Bappid%5D=218&result%5B1%5D%5Bcontent%5D=%E6%AF%95%E5%85%B6%E4%B8%80%E7%94%9F%E4%B8%BA%E6%94%B9%E9%9D%A9%EF%BC%88%E5%95%86%E4%BB%A3%E4%BA%BA%EF%BC%89&result%5B1%5D%5Bpos%5D=&result%5B1%5D%5Banswer%5D=A&result%5B1%5D%5Bactiveid%5D=1542&result%5B1%5D%5Bchoices%5D%5B0%5D%5Bid%5D=4917&result%5B1%5D%5Bchoices%5D%5B0%5D%5Bindexname%5D=A&result%5B1%5D%5Bchoices%5D%5B0%5D%5Bquestionid%5D=1482&result%5B1%5D%5Bcreatetime%5D=2021-02-23+10%3A15%3A21&result%5B1%5D%5Bstatus%5D=1&result%5B1%5D%5Btype%5D=2&result%5B1%5D%5Bdefault%5D=0&result%5B1%5D%5Bchoice%5D=%E6%AF%94%E5%B9%B2&result%5B2%5D%5Bid%5D=1471&result%5B2%5D%5Bappid%5D=218&result%5B2%5D%5Bcontent%5D=%E5%B0%8A%E5%B4%87%E5%9B%AD%E4%B8%81%E9%87%8D%E6%A1%83%E6%9D%8E++%EF%BC%88%E3%80%8A%E8%AF%B4%E5%94%90%E6%BC%94%E4%B9%89%E3%80%8B%E4%BA%BA%E7%89%A9%EF%BC%89&result%5B2%5D%5Bpos%5D=&result%5B2%5D%5Banswer%5D=A&result%5B2%5D%5Bactiveid%5D=1542&result%5B2%5D%5Bchoices%5D%5B0%5D%5Bid%5D=4906&result%5B2%5D%5Bchoices%5D%5B0%5D%5Bindexname%5D=A&result%5B2%5D%5Bchoices%5D%5B0%5D%5Bquestionid%5D=1471&result%5B2%5D%5Bcreatetime%5D=2021-02-23+10%3A11%3A22&result%5B2%5D%5Bstatus%5D=1&result%5B2%5D%5Btype%5D=2&result%5B2%5D%5Bdefault%5D=0&result%5B2%5D%5Bchoice%5D=%E9%99%B6%E6%B8%8A%E6%98%8E&id=1486659&score=0]]
		table.insert(retTable,tmpTokenTable)
	end
	return retTable
end

--请求服务之前,预留接口以便修改请求参数
function TaskTMP:onBeforeRequest(httpTaskObj)
	local allInfo = httpTaskObj:getRequestInfo()
end

return TaskTMP