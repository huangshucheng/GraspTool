local Define = {}

Define.Method = {GET = 0, POST = 1, PUT = 2, DELETE= 3}

local GET = Define.Method.GET
local POST = Define.Method.POST
local PUT = Define.Method.PUT
local DELETE = Define.Method.DELETE

Define.COOKIE_NAME = "Cookie" 
Define.FIND_STRING_HOST = "hbz.qrmkt.cn"
Define.DATA_TO_FIND_ARRAY = {"token","Cookie"}

Define.REQ_HEAD_STRING = "reqHeader<" .. Define.FIND_STRING_HOST
Define.REQ_BODY_STRING = "reqBody<" .. Define.FIND_STRING_HOST
Define.RES_HEAD_STRING = "resHeader<" .. Define.FIND_STRING_HOST
Define.RES_BODY_STRING = "resBody<" .. Define.FIND_STRING_HOST

Define.FILE_SAVE_NAME = "token" --保存本地token文件名字: token.json

Define.HTTP_HEADER_TABLE = {
	["Accept"] = "application/json,text/javascript,text/html,text/plain,application/xhtml+xml,application/xml, */*; q=0.01",
	["Proxy-Connection"] = "keep-alive",
	["Connection"] = "keep-alive",
	["X-Requested-With"] = "XMLHttpRequest",
	["Accept-Encoding"] = "br, gzip, deflate",
	["Accept-Language"] = "zh-cn",
	["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8",
	["User-Agent"] = "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13G34 MicroMessenger/7.0.9(0x17000929) NetType/WIFI Language/zh_CN",
}

Define.NEXT_TASK_LIST_URL = {
	{
		taskName = "do_sign>>  ", 
		url = "hbz.qrmkt.cn/hbact/hyr/sign/doit",
		method = POST, 
		preTaskName = "sign_list", 
		reqCount = 1,
		delay = 1,
	},
	{
		taskName = "start_study>>  ", 
		url = "hbz.qrmkt.cn/hbact/school/study/start",
		method = POST, 
		preTaskName = "do_sign", 
		reqCount = 1,
		delay = 1,
	},	
	{
		taskName = "end_study>> ", 
		url = "hbz.qrmkt.cn/hbact/school/study/end",
		method = POST, 
		preTaskName = "start_study", 
		reqCount = 1,
		delay = 3,
	},
	{
		taskName = "my_card", 
		url = "hbz.qrmkt.cn/hbact/commucard/mycard",
		method = POST, 
		preTaskName = "end_study";
		reqCount = 1,
		delay = 0.5,
	},
	{
		taskName = "share_code", 
		url = "hbz.qrmkt.cn/hbact/hyr/home/hasAwd",
		preTaskName = "my_card";
		reqCount = 2,
		delay = 1,
	},
	--[[
	{
		taskName = "req_sutdy_page", url = "hbz.qrmkt.cn/syx/wx/jsapi",
		method = POST,preTaskName = "share_code";
	},
	{
        --{"code":"200","msg":null,"data":{"actCode":"ACT-8K38GWT8552W","id":245}}
		-- taskName = "active_exam",url = "hbz.qrmkt.cn/hbact/hyr/home/queryActCode",
		-- method = POST,preTaskName = "req_sutdy_page";
	},
	{
	    --answerNum考试机会 GET  {"code":"200","msg":null,"data":{"exchangeNum":10,"answerNum":1}}
		-- taskName = "active_exam_chance", url = "hbz.qrmkt.cn/hbact/exam/chance",
		-- preTaskName = "active_exam";
	},
	{
	   --GET  {"code":"200","msg":null,"data":null}
		-- taskName = "考试检测", url = "hbz.qrmkt.cn/hbact/hyr/sign/list",
	},
	{
		-- taskName = "请求题目", url = "hbz.qrmkt.cn/hbact/exam/random",
	},
	{
		-- taskName = "提交答案", url = "hbz.qrmkt.cn/hbact/exam/finish", 
		-- method = POST,
	},
	]]
}

Define.TASK_LIST_URL = 
{
	{
		taskName = "(sign_list)>> ", 
		url = "hbz.qrmkt.cn/hbact/hyr/sign/list",
		method = POST, 
		reqCount = 1, 
		urlBody = "", 
		postBody = "", 
		preTaskName = "",
		delay = 0,
	},
	-- {
	-- 	url = "baidu.com",
	-- },
}




return Define