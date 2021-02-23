--[[抖音抓CK]]
local TaskBase 	= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 	= class("TaskTMP", TaskBase)
local GET 		= TaskBase.GET
local POST 		= TaskBase.POST
local CSFun 		= require("resources.luaScript.util.CSFun")

TaskTMP.FIND_STRING_HOST 		= "normal-c-"
TaskTMP.DEFAULT_KABAO_COUNT 	= 1
TaskTMP.IS_USE_FULL_REQDATA 	= true       --是否保存当前完整的请求数据,下次用当前数据去请求
TaskTMP.DATA_TO_FIND_ARRAY 		= 
{
	-- "aweme/v1/user/profile/self/",
	-- "https://api5-normal-c-lf.amemv.com/passport/device/one_login/?version_code=14.7.1&js_sdk_version=1.99.0.13&tma_jssdk_version=1.99.0.13&app_name=aweme&app_version=14.7.1&vendor_id=72951BF4-DD04-45B2-B38F-CC20C6433FF4&vid=72951BF4-DD04-45B2-B38F-CC20C6433FF4&device_id=71088382888&channel=App%20Store&mcc_mnc=46001&resolution=1242%2A2208&aid=1128&app_id=1128&minor_status=0&screen_width=1242&install_id=3888294334588429&openudid=479a258ad2a820d9976009bf86cf29bfe858f13a&cdid=BDC1FAE7-59C0-4226-8E66-5E7C7912437C&os_api=18&idfv=72951BF4-DD04-45B2-B38F-CC20C6433FF4&ac=WIFI&os_version=14.4&ssmix=a&appTheme=dark&device_platform=iphone&build_number=147104&is_vcd=1&device_type=iPhone9%2C2&iid=3888294334588429&idfa=05FAE70B-785A-4FF5-B8CA-95B6C3E25D63"
	"/passport/device/one_login"
}

--额外的请求头,也可以不用配置
TaskTMP.ERQ_HEADER_EXT = {
}

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "CK",
		url = "TEST_CK",
		method = POST,
		reqCount = 1,
		urlBody = "",
		postBody = "",
		delay = 0,
		isKabao = false,
	},
}

--找到token后保存在本地前，预留接口以便修改请求内容
function TaskTMP:onBeforeSaveToLocal(tokenTable)
	local tmpTokenTable = clone(tokenTable)
	local retTable = {}
	local reqUrl = tmpTokenTable["ReqUrl"]
	-- print("11111")
	local tmpTokenTable_2 = {["Headers"] = {["Cookie"]= ""},["ReqUrl"] = "TEST_CK"}
	if CSFun.IsSubString(reqUrl, "/passport/device/one_login") then
		-- print("22222")
		tmpTokenTable_2["Headers"]["Cookie"] = tmpTokenTable["Headers"]["Cookie"]
		table.insert(retTable,tmpTokenTable_2)
		-- print("333333333333333")
	end
	return retTable
end

return TaskTMP