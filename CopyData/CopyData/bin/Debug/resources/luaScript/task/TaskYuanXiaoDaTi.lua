--[[元宵答题助力]] 
local TaskBase 		= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 		= class("TaskTMP", TaskBase)
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local CSFun 		= require("resources.luaScript.util.CSFun")
local GET 			= TaskBase.GET
local POST 			= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "tx.maimang002.top"
-- TaskTMP.FIND_STRING_HOST 		= "tx.jizhi085.top"
TaskTMP.DATA_TO_FIND_ARRAY 		= {"Cookie","Referer"}
TaskTMP.DEFAULT_KABAO_COUNT 	= 10 	-- 默认卡包次数，需要设置isKabao后才生效
TaskTMP.IS_REPEAT_FOREVER 		= false

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
	["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "分享", 
		-- url = "https://tx.maimang002.top/?UYj7=00a16d0606f3355436d93e8a7eb6dcbc&mzrg=741f48446919db0e826f158f1465b7a4&3tdS=8cf72e6c77cc388830c22744bbb1dcb8&NBEO=a92c45c1868026592aff020dd0964d41&s=%2Fwandazlc%2FAjax%2Fshare_ajax&rw=79c6e9f0dfb22deadaabb02984dbca92",
		url = "https://tx.jizhi085.top/?rw=40c523c86ee8f79fb6a9db149f2e903e&s=%2Fwandazlc%2FAjax%2Fshare_ajax&CGfP=25a95d350d449943a320c3b5bd729aad&ZdA5=a6a568e304869f7010384fc0ca214cca&gUBD=46172cdf549d3a496d82e0fa3e6cdcfe&KkPT=3336e45705e2df487c71edb49c59a5e7",
		method = POST, 
		reqCount = 1,
		urlBody = "", 
		postBody = "share=1",
		delay = 0,
		isKabao = true,
		-- {"status":1,"info":"分享成功","times":1}
	},
	{
		curTaskName = "抽奖~", 
		-- url = "https://tx.maimang002.top/?s=%2Fwandazlc%2FAjax%2Fshake_hb_ajax&YEl2=ebc12b6ca9bfe66b9bec57a272a8f62b&rw=b8afa277385a65ab1b09be1f2a582f29&skGZ=a90228b5c81981a60394d2e11ac21ae1&yFLB=fe39eeec574f572e2a226c2d9c494977&FIva=94d06ac345d30ae449d06f90d566b61a",
		url = "https://tx.jizhi085.top/?UPKl=02e5fe0afdbe341908aec4838f9860e0&s=%2Fwandazlc%2FAjax%2Fshake_hb_ajax&OGMa=a63eb025aa72c71ca10657232eb1d86e&NtRf=e35bad9e6ff7b41a52b58757d67d7b7c&rw=147dc844f3e987a8c41c689cc498b2f2&Jbud=8a36669efd1d6d6e14918317b2067754",
		method = POST, 
		reqCount = 1,
		urlBody = "", 
		postBody = "shake=18582&page_token=rLJQexZnR7IgmldCbBKHpX50yhwz68sa",
		delay = 0,
		isKabao = true,
		-- {"status":0,"info":"很遗憾，没有抢到红包！3","code":"p","times":0}
	},
}

--找到token后，预留接口以便修改本地保存的内容
--[[
function TaskTMP:onBeforeSaveToLocal(tokenTable)
	local tmpTokenTable = clone(tokenTable)
	local retTable = {}
	-- local reqUrl = tmpTokenTable["Headers"]
	tmpTokenTable["ReqBody"] = "id=89"
	table.insert(retTable,tmpTokenTable)
	return retTable
end
]]

--请求服务之前,预留接口以便修改请求参数
function TaskTMP:onBeforeRequest(httpTaskObj)
	local reqUrl = httpTaskObj:getUrl()
	local urlBody = httpTaskObj:getUrlBody()
	local postBody = httpTaskObj:getPostBody()
	local headers = httpTaskObj:getHeader()
	local allInfo = httpTaskObj:getRequestInfo()
	-- dump(allInfo,"allInfo")
	-- print(reqUrl)
	-- dump(headers,"headers")
end

return TaskTMP