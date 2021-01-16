--[[黄浦食品安全活动]] 
local TaskBase = require("resources.luaScript.task.base.TaskBase")
local TaskFoodSafe = class("TaskFoodSafe", TaskBase)
local CShapListView = require("resources.luaScript.uiLogic.CShapListView")
local CSFun = require("resources.luaScript.util.CSFun")

local GET = TaskBase.GET
local POST = TaskBase.POST

function TaskFoodSafe:ctor()
	self.CUR_TASK_TITLE = "黄浦活动"  --当前任务标题
	self.FIND_STRING_HOST = "xinhua.mofangdata.cn"  --域名，方便查找token
	self.FILE_SAVE_NAME = "task_foodsafe_token.lua" -- 保存本地token文件名字
	self.RECORD_SAVE_FILE_NAME = "task_foodsafe_record.lua" --交互记录文件
	self.DATA_TO_FIND_ARRAY = {"Cookie","Referer"}      --需要查找的taken 或者cookie
	self.IS_OPEN_RECORD = false 	  --是否抓取接口保存到本地
	self._taskList = {}
	self:loadTask()
end

--额外的请求头,也可以不用配置
TaskFoodSafe.ERQ_HEADER_EXT = {
	-- ["token"] = "hcctoken",
}

--test
local tmpRetData = {
	[1] = [[{"recordid":6314121,"msg":"","data":{"id":557,"actid":88,"name":"红包1.08元~","imgurl":"","grade":null,"seq":2,"maxcount":1000,"prizecount":0,"isprize":0,"intro":"","coins":null,"redpack_sum":null,"sendername":"","wishing":"","remark":"谢谢参与"},"success":true,"record":{"id":6314121,"actid":88,"itemid":557,"name":"谢谢参与","imgurl":"","grade":null,"isprize":0,"intro":"","userid":"402881d9769497620176a9f710220483","username":null,"photourl":null,"addr":null,"coins":null,"prizedate":"2021-01-04 23:57:08","ipaddress":null,"verification":"N121","paymentNo":null,"moneySum":null}}]],
	[2] = [[{"recordid":6314121,"msg":"","data":{"id":557,"actid":88,"name":"红包1.09元~","imgurl":"","grade":null,"seq":2,"maxcount":1000,"prizecount":0,"isprize":0,"intro":"","coins":null,"redpack_sum":null,"sendername":"","wishing":"","remark":"谢谢参与"},"success":true,"record":{"id":6314121,"actid":88,"itemid":557,"name":"谢谢参与","imgurl":"","grade":null,"isprize":0,"intro":"","userid":"402881d9769497620176a9f710220483","username":null,"photourl":null,"addr":null,"coins":null,"prizedate":"2021-01-04 23:57:08","ipaddress":null,"verification":"N121","paymentNo":null,"moneySum":null}}]],
	[3] = [[{"recordid":6314121,"msg":"","data":{"id":557,"actid":88,"name":"无!!","imgurl":"","grade":null,"seq":2,"maxcount":1000,"prizecount":0,"isprize":0,"intro":"","coins":null,"redpack_sum":null,"sendername":"","wishing":"","remark":"谢谢参与"},"success":true,"record":{"id":6314121,"actid":88,"itemid":557,"name":"谢谢参与","imgurl":"","grade":null,"isprize":0,"intro":"","userid":"402881d9769497620176a9f710220483","username":null,"photourl":null,"addr":null,"coins":null,"prizedate":"2021-01-04 23:57:08","ipaddress":null,"verification":"N121","paymentNo":null,"moneySum":null}}]],
}
--返回,各个活动自己去做json解析，显示红包多少
function TaskFoodSafe:onResponse(httpRes, taskCur)
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
TaskFoodSafe.TASK_LIST_URL_CONFIG = {
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


return TaskFoodSafe