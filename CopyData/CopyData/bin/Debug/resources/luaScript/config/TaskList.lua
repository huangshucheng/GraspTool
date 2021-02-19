local TaskList = {}
-- 
TaskList.ActMapTable = {
	{
		name = "请下载证书~",
		script = "",
		qrcode = "http://hcc.hccfun.com/qr_code_proxy_2.png",--设置手机代理的 二维码URL
	},
	{
		name = "太平洋保险~",
		script = "resources.luaScript.task.TaskTaiPingYang",
		qrcode = "CPIC-LIFE",
		linkUrl = "https://mp.weixin.qq.com/s/5Oiv1W5IHuwOttH6M5qb-w",
	},
	{
		name = "一汽丰田抽奖~",
		script = "resources.luaScript.task.TaskYiQiFengTian",
		qrcode = "",
		linkUrl = "https://sourl.cn/4fQsMg",
	},
	{
		name = "江都农商",
		script = "resources.luaScript.task.TaskNongShang_JiangDu",
		qrcode = "jdnsh96008",
		linkUrl = "http://jiangdu.bj-virgo.cn/win/WxyhServer_DY_V5/Areas/JDGoodStart/index.html",
	},
	{
		name = "仪征农商",
		script = "resources.luaScript.task.TaskNongShang_YiZheng",
		qrcode = "jsyznsh",
		linkUrl = "http://wxs.yzbank.com/win/WxyhServer_YZV5/Areas/YZGoodStart/index.html",
	},
	{
		name = "扬州农商",
		script = "resources.luaScript.task.TaskNongShang_YangZhou",
		qrcode = "yznsyh96008",
		linkUrl = "http://yzweixin.yznsh.net/win/WxyhServerV5/Areas/YZGoodStart/PagesIndex/index.html",
	},
	{
		name = "黄浦食品安全",
		script = "resources.luaScript.task.TaskFoodSafe",
		qrcode = "HP-MSA",
		linkUrl = "http://xinhua.mofangdata.cn/wx/prize/game/answercard.htm?id=402881d97622ed0201767e799f370ba0&prizeid=88&basescope=true&cardid=hpcj2020-10&backGroupId=ed4f2e0737334907ab811b17e316d164",
	},
	{
		name = "红牛活动~",
		script = "resources.luaScript.task.TaskHongNiu",
		qrcode = "RedBull_ZheJiang",
		linkUrl = "http://hzhn2.msjp1.com/#/follow/504005",
	},
	-- {
	-- 	name = "六合答题抽奖~",
	-- 	script = "resources.luaScript.task.TaskLiuHeChouJiang",
	-- 	qrcode = "gh_03b7ae1a9557",
	-- 	linkUrl = "",
	-- },
	-- {
	-- 	name = "建行裕农红包加码~",
	-- 	script = "resources.luaScript.task.TaskJianHangYuNong",
	-- 	qrcode = "CCB_yunongtong",
	-- 	linkUrl = "",
	-- },
	-- {
	-- 	name = "东海农商",
	-- 	script = "resources.luaScript.task.TaskNongShang_DongHai",
	-- 	qrcode = "jsdhnsyh",
	-- 	linkUrl = "http://wx.dhrcbank.com/win/WxyhServerV5/Areas/DHGoodStart/index.html",
	-- },
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
	-- {
	-- 	name = "钻石活动",
	-- 	script = "resources.luaScript.task.TaskDiamond",
	-- 	qrcode = "hbzhongyan",
	-- },
}

return TaskList