--[[
模板脚本
每次新活动可以直接在这里改，改好后还原	
]]
local TaskBase 		= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 		= class("TaskTMP", TaskBase)
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local CSFun 		= require("resources.luaScript.util.CSFun")
local StringUtils 	= require("resources.luaScript.util.StringUtils")
local LuaCallCShapUI = require("resources.luaScript.uiLogic.LuaCallCShapUI")
local GET 			= TaskBase.GET
local POST 			= TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "mp.weixin.qq.com" --域名，方便查找token, 如：hbz.qrmkt.cn
TaskTMP.IS_USE_FULL_REQDATA 	= true        -- 是否保存当前完整的请求数据,下次用当前数据去请求，此时需要在DATA_TO_FIND_ARRAY配置要查找的Url,会用ReqUrl去做对比，一致则保存
TaskTMP.IS_REPEAT_FOREVER 		= false       -- 是否永久做此任务，停不下来(切换任务对象可以停下来)
TaskTMP.IS_AUTO_DO_ACTION 		= false 	  -- 是否自动做任务,是的话会默认把UI选中
TaskTMP.DEFAULT_KABAO_COUNT 	= 1 	      -- 默认卡包次数，需要设置isKabao后才生效
TaskTMP.DEFAULT_INPUT_TEXT 	    = "25" 		  -- 输入框默认值

-- IS_USE_FULL_REQDATA == true 查找的是URL链接或链接的子串, 否则就是查找的Header里面的token或CK
TaskTMP.DATA_TO_FIND_ARRAY 		= {
	"https://mp.weixin.qq.com/wxagame/wxagame_bottlereport"
}

-- 额外的请求头,会单独配置到请求头进去,如：{["Refer"]="www.baidu.com"}
TaskTMP.ERQ_HEADER_EXT = {
	["Content-Type"] = "application/json",
	-- ["Referer"] = "",
	["Accept"]  = "*/*",
	["Accept-Encoding"] = "br, gzip, deflate"
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "提交分数~", 
		url = "https://mp.weixin.qq.com/wxagame/wxagame_bottlereport",
		method = POST,
		reqCount = 1,
		urlBody = "", 
		-- postBody = [[{"base_req":{"session_id":"330DCGIlXYrp6NpJ3UI/b9KTlzOrspNDSVLPzIhhE+OjnOvaJSuXqmo9h8fQdajkuHNnZGd1pABTCnouepznVT+d7fxQqCE9eqNeCsAIbV1Kzs9FoUG65OQomAv3LGQ8wbjerDL3mjKYqeS56Ilzzw==","fast":1,"client_info":{"platform":"ios","brand":"iPhone","model":"iPhone 8 (GSM)<iPhone10,4>","system":"iOS 11.2.1"}},"report_list":[{"ts":1614693682,"type":35},{"ts":1614693682,"type":10},{"ts":1614693684,"type":2,"score":0,"best_score":20,"break_record":0,"duration":2,"times":8,"using_prop":1}]}]],
		postBody = "",
		delay = 0,
		isKabao = true,
	},
}

function TaskTMP:onBeforeSaveToLocal(requestInfo)
	local tmpTokenTable = clone(requestInfo)
	local retTable = {}
	local reqUrl = tmpTokenTable["ReqUrl"]
	 --第一个任务
	local tmpTokenTable_1 = clone(requestInfo)
	if CSFun.IsSubString(reqUrl, "https://mp.weixin.qq.com/wxagame/wxagame_bottlereport") then
		table.insert(retTable,tmpTokenTable_1)
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
	-- dump(allInfo,"allInfo",10)
	print("1111")
	if CSFun.IsSubString(reqUrl, "https://mp.weixin.qq.com/wxagame/wxagame_bottlereport") then
		print("2222")
		print("postBody:" .. tostring(postBody))
		local postBodyTable = postBody
		print("33333333")
		local tmpScore = tonumber(LuaCallCShapUI.GetUserInputText()) 
		print("3333, tmpScore>> " .. tostring(tmpScore))

		local report_list = postBodyTable["report_list"]
		local best_score = 0
		local play_times = 0
		local os_time = os.time()
		if report_list then
			for i,v in ipairs(report_list) do
				if next(v) then
					if v["best_score"] then
						best_score = tonumber(v["best_score"]) or 0
					end
					if v["times"] then
						play_times = tonumber(v["times"]) or 0
					end
				end
			end
		end

		postBodyTable["report_list"] = 
		{
			{
				["ts"] = os.time(),
				["type"] = 2,
				["score"] = tmpScore,
				["best_score"] = best_score,
				["break_record"] = 1,
				["duration"] = tmpScore + 5,
				["times"] = play_times + 1,
				["using_prop"] = 1,
			}
		}
		print("4444")
		local tmpPostBodyStr = json.encode(postBodyTable)
		httpTaskObj:setPostBody(tmpPostBodyStr)
		print("postBody: " .. tostring(tmpPostBodyStr))
		dump(httpTaskObj:getRequestInfo(), "after_allInfo")
	end
end

return TaskTMP