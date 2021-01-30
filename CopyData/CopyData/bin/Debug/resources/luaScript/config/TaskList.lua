local TaskList = {}


TaskList.ActMapTable = {
	{
		name = "请下载证书~",
		script = "",
		qrcode = "http://hcc.hccfun.com/qr_code_proxy_2.png",--设置手机代理的 二维码URL
	},
	{
		name = "东海农商",
		script = "resources.luaScript.task.TaskNongShang_DongHai",
		qrcode = "jsdhnsyh",
	},
	{
		name = "扬州农商",
		script = "resources.luaScript.task.TaskNongShang_YangZhou",
		qrcode = "yznsyh96008",
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
		name = "通用活动",
		script = "resources.luaScript.task.TaskCommon",
		qrcode = "",
	},
	{
		name = "开车开始~",
		script = "resources.luaScript.task.TaskCM_KaiChe_Start",
		qrcode = "",
	},
	{
		name = "开车完成~",
		script = "resources.luaScript.task.TaskCM_KaiChe_End",
		qrcode = "",
	},
	{
		name = "开车后抽奖~",
		script = "resources.luaScript.task.TaskCM_KaiChe_ChouJiang",
		qrcode = "",
	},
}

return TaskList