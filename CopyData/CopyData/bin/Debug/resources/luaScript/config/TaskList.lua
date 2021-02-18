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
		name = "太平洋抽奖~",
		script = "resources.luaScript.task.TaskTaiPingYang",
		qrcode = "CPIC-LIFE",
	},
	{
		name = "丰田抽奖~",
		script = "resources.luaScript.task.TaskYiQiFengTian",
		qrcode = "https://sourl.cn/4fQsMg",
		-- qrcode = "sourl.cn/4fQsMg",
	},
	-- {
	-- 	name = "科学防御抽奖~",
	-- 	script = "resources.luaScript.task.TaskKeXueFangYu",
	-- 	qrcode = "rugaofabu",
	-- },
	-- {
	-- 	name = "采荷活动",
	-- 	script = "resources.luaScript.task.TaskCaiHe",
	-- 	qrcode = "hbzhongyan",
	-- },
	{
		name = "江都农商",
		script = "resources.luaScript.task.TaskNongShang_JiangDu",
		qrcode = "jdnsh96008",
	},
	{
		name = "仪征农商",
		script = "resources.luaScript.task.TaskNongShang_YiZheng",
		qrcode = "jsyznsh",
	},
	{
		name = "扬州农商",
		script = "resources.luaScript.task.TaskNongShang_YangZhou",
		qrcode = "yznsyh96008",
	},
	-- {
	-- 	name = "钻石活动",
	-- 	script = "resources.luaScript.task.TaskDiamond",
	-- 	qrcode = "hbzhongyan",
	-- },
	{
		name = "黄浦食品安全",
		script = "resources.luaScript.task.TaskFoodSafe",
		qrcode = "HP-MSA",
	},
	-- {
	-- 	name = "通用活动",
	-- 	script = "resources.luaScript.task.TaskCommon",
	-- 	qrcode = "",
	-- },
	-- {
	-- 	name = "中荷人寿-开车~",
	-- 	script = "resources.luaScript.task.TaskCM_KaiChe",
	-- 	qrcode = "",
	-- },
	{
		name = "红牛活动~",
		script = "resources.luaScript.task.TaskHongNiu",
		qrcode = "RedBull_ZheJiang",
	},
}

return TaskList