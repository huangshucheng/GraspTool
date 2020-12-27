local TaskList = {}

TaskList.ActMapTable = {
	{
		name = "1钻石活动", --活动名称
		script = "resources.luaScript.task.TaskDiamond", --活动控制脚本
		qrcode = "hbzhongyan", --活动二维码（公众号名字）
	},
	{
		name = "2活动",
		script = "resources.luaScript.task.TaskRun",
		qrcode = "juemuren_dev",
	},
	{
		name = "3支付宝a",
		script = "resources.luaScript.task.TaskZFB",
	},
	{
		name = "4活动",
		script = "resources.luaScript.task.TaskWeiXinRecordx",
	},
}

return TaskList