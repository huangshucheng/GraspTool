local TaskList = {}


TaskList.ActMapTable = {
	{
		name = "请下载证书~",
		script = "",
		qrcode = "http://hcc.hccfun.com/qr_code_proxy_2.png",--设置手机代理的 二维码URL
	},
	{
		name = "广安储蓄有礼", --活动名称
		script = "resources.luaScript.task.TaskGACXYL", --活动控制脚本
		qrcode = "", --活动二维码（公众号名字）
	},
	{
		name = "钻石活动", --活动名称
		script = "resources.luaScript.task.TaskDiamond", --活动控制脚本
		qrcode = "hbzhongyan", --活动二维码（公众号名字）
	},
	{
		name = "黄浦食品安全",
		script = "resources.luaScript.task.TaskFoodSafe",
		qrcode = "HP-MSA",
	},
	{
		name = "华夏基金",
		script = "resources.luaScript.task.TaskHXJJ",
		qrcode = "",
	},
	{
		name = "测试活动",
		script = "resources.luaScript.task.TaskRun",
		qrcode = "juemuren_dev",
	},
}

return TaskList