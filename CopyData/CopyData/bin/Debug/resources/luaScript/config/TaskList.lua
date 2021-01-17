local TaskList = {}
local Define = require("resources.luaScript.config.Define")

--设置代理二维码

local proxy_qrcode = [[http://hcc.hccfun.com/%E8%AF%81%E4%B9%A6%E9%AA%8C%E8%AF%81%E7%A0%81.png]]
TaskList.ActMapTable = {
	{
		name = "设置手机代理~",
		script = "",
		qrcode = proxy_qrcode,
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
		name = "测试活动",
		script = "resources.luaScript.task.TaskRun",
		qrcode = "juemuren_dev",
	},
}

return TaskList