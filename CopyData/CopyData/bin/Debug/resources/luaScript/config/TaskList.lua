local TaskList = {}

TaskList.ActMapTable = {
	{
		name = "钻石活动", --活动名称
		script = "resources.luaScript.task.TaskDiamond", --活动控制脚本
		qrcode = "hbzhongyan", --活动二维码（公众号名字）
	},
	{
		name = "黄浦食品安全活动",
		script = "resources.luaScript.task.TaskFoodSafe",
		qrcode = "HP-MSA",
	},
	{
		name = "活动",
		script = "resources.luaScript.task.TaskRun",
		qrcode = "juemuren_dev",
	},
}

return TaskList