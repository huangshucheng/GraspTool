--[[模板脚本]] 

local TaskBase 		= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 		= class("TaskTMP", TaskBase)
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local CSFun 		= require("resources.luaScript.util.CSFun")
local StringUtils 	= require("resources.luaScript.util.StringUtils")
local GET 			= TaskBase.GET
local POST 			= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "www.baidu.com" --域名，方便查找token, 如：hbz.qrmkt.cn
TaskTMP.IS_USE_FULL_REQDATA 	= false       -- 是否保存当前完整的请求数据,下次用当前数据去请求，此时需要在DATA_TO_FIND_ARRAY配置要查找的Url,会用ReqUrl去做对比，一致则保存
TaskTMP.IS_REPEAT_FOREVER 		= false       -- 是否永久做此任务，停不下来(切换任务对象可以停下来)
TaskTMP.IS_AUTO_DO_ACTION 		= false 	  -- 是否自动做任务,是的话会默认把UI选中
TaskTMP.DEFAULT_KABAO_COUNT 	= 50 	      -- 默认卡包次数，需要设置isKabao后才生效
TaskTMP.DEFAULT_INPUT_TEXT 	    = "" 		  -- 输入框默认值

-- 需要查找的Header里面的值
-- IS_USE_FULL_REQDATA == true 查找的是连接或连接的子串
TaskTMP.DATA_TO_FIND_ARRAY 		= {
	"open.ixiaomayun.com/api/Active/Misc/Question"
}

-- 额外的请求头,会单独配置到请求头进去,如：{["Refer"]="www.baidu.com"}
TaskTMP.ERQ_HEADER_EXT = {
	["Content-Type"] = "",
	["Referer"] = "",
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "答题~", 
		url = "",
		method = POST, 
		reqCount = 1,
		urlBody = "", 
		postBody = "",
		delay = 0,
		isKabao = true,
	},
	{
		curTaskName = "抽奖~", 
		url = "",
		method = POST, 
		reqCount = 1,
		urlBody = "", 
		postBody = "",
		delay = 0,
		isKabao = true,
	},
}

--客户端抓到token后保存到本地之前,预留接口以便修改保存数据
--[[
requestInfo ={
    "Headers" = {
     	"Cookies" = "reqid=123;uid=456;",
        "token"= "12345",
    },
    "Method"  = "",
    "ReqBody" = "",
    "ReqHost" = "",
    "ReqUrl"  = "",
    "UrlBody" = "",
}
]]
function TaskTMP:onBeforeSaveToLocal(requestInfo)
	local tmpTokenTable = clone(requestInfo)
	local retTable = {}
	local reqUrl = tmpTokenTable["ReqUrl"]
	 
	 -- IS_USE_FULL_REQDATA == true 才能用连接来判断，否则只有Header的数据
	 -- 如果抓到这个子串，可以用这条请求信息制造成目标请求信息，保存在本地，方便用来请求
	 -- 可以制造多条本地记录,添加到retTable就行了

	if CSFun.IsSubString(reqUrl, "open.ixiaomayun.com/api/Active/Misc/Question") then
		tmpTokenTable["ReqUrl"] = "http://fdgh202001.open.ixiaomayun.com/api/Active/Misc/Question/submit?activeid=1542"
		tmpTokenTable["Method"] = "POST"
		tmpTokenTable["ReqBody"] = "openid=123"
		tmpTokenTable["UrlBody"] = "openid=123&sex=boy&name=hcc"
		tmpTokenTable["Headers"] = {["Cookies"] = "", ["token"] = ""}
		table.insert(retTable,tmpTokenTable)
	end

	if CSFun.IsSubString(reqUrl, "") then

	end
	return retTable
end

--请求服务之前,预留接口以便修改请求参数
function TaskTMP:onBeforeRequest(httpTaskObj)
	local reqUrl 	= httpTaskObj:getUrl()
	local urlBody 	= httpTaskObj:getUrlBody()
	local postBody 	= httpTaskObj:getPostBody()
	local headers 	= httpTaskObj:getHeader()
	local allInfo 	= httpTaskObj:getRequestInfo()
	dump(allInfo,"allInfo")
end

return TaskTMP