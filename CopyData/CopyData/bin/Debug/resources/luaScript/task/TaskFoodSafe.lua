--[[黄浦食品安全活动]] 
local TaskBase 		= require("resources.luaScript.task.base.TaskBase")
local TaskTMP 		= class("TaskTMP", TaskBase)
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local CSFun 		= require("resources.luaScript.util.CSFun")

local GET = TaskBase.GET
local POST = TaskBase.POST

TaskTMP.FIND_STRING_HOST 		= "xinhua.mofangdata.cn"
TaskTMP.DATA_TO_FIND_ARRAY 		= {"Cookie","Referer"}
TaskTMP.IS_OPEN_RECORD 			= false
TaskTMP.DEFAULT_KABAO_COUNT 	= 30 	-- 默认卡包次数，需要设置isKabao后才生效

--test
local tmpRetData = {
	[1] = [[{"recordid":6314121,"msg":"","data":{"id":557,"actid":88,"name":"红包1.08元~","imgurl":"","grade":null,"seq":2,"maxcount":1000,"prizecount":0,"isprize":0,"intro":"","coins":null,"redpack_sum":null,"sendername":"","wishing":"","remark":"谢谢参与"},"success":true,"record":{"id":6314121,"actid":88,"itemid":557,"name":"谢谢参与","imgurl":"","grade":null,"isprize":0,"intro":"","userid":"402881d9769497620176a9f710220483","username":null,"photourl":null,"addr":null,"coins":null,"prizedate":"2021-01-04 23:57:08","ipaddress":null,"verification":"N121","paymentNo":null,"moneySum":null}}]],
	[2] = [[{"recordid":6314121,"msg":"","data":{"id":557,"actid":88,"name":"红包1.09元~","imgurl":"","grade":null,"seq":2,"maxcount":1000,"prizecount":0,"isprize":0,"intro":"","coins":null,"redpack_sum":null,"sendername":"","wishing":"","remark":"谢谢参与"},"success":true,"record":{"id":6314121,"actid":88,"itemid":557,"name":"谢谢参与","imgurl":"","grade":null,"isprize":0,"intro":"","userid":"402881d9769497620176a9f710220483","username":null,"photourl":null,"addr":null,"coins":null,"prizedate":"2021-01-04 23:57:08","ipaddress":null,"verification":"N121","paymentNo":null,"moneySum":null}}]],
	[3] = [[{"recordid":6314121,"msg":"","data":{"id":557,"actid":88,"name":"无!!","imgurl":"","grade":null,"seq":2,"maxcount":1000,"prizecount":0,"isprize":0,"intro":"","coins":null,"redpack_sum":null,"sendername":"","wishing":"","remark":"谢谢参与"},"success":true,"record":{"id":6314121,"actid":88,"itemid":557,"name":"谢谢参与","imgurl":"","grade":null,"isprize":0,"intro":"","userid":"402881d9769497620176a9f710220483","username":null,"photourl":null,"addr":null,"coins":null,"prizedate":"2021-01-04 23:57:08","ipaddress":null,"verification":"N121","paymentNo":null,"moneySum":null}}]],
}
--返回,各个活动自己去做json解析，显示红包多少
function TaskTMP:onResponse(httpRes, taskCur)
	local index = taskCur:getUserData()
	-- httpRes = tmpRetData[index]
	if string.find(httpRes,"红包") then
		taskCur:setGraspRedPktCount(taskCur:getGraspRedPktCount() + 1)
		local jsonObj = json.decode(httpRes) or ""
		local retName = CSFun.Utf8ToDefault(jsonObj.data.name) or ""
		local redPktCount = taskCur:getGraspRedPktCount()
		CShapListView.ListView_set_item({index, nil, retName, redPktCount, nil})
	end
end

--任务列表
TaskTMP.TASK_LIST_URL_CONFIG = {
	{
		curTaskName = "抽奖", 
		url = "http://xinhua.mofangdata.cn/wx/prize/tryit3.htm",
		method = POST, 
		reqCount = 150,
		urlBody = "", 
		postBody = "id=88", 
		delay = 0,
	},
}


return TaskTMP