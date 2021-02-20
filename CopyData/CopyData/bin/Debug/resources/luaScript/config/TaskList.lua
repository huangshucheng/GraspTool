local TaskList = {}

TaskList.ActMapTable = {
	{
		name = "请下载证书~",
		script = "",
		qrcode = "http://hcc.hccfun.com/qr_code_proxy_2.png",--设置手机代理的 二维码URL
	},
	{
		name = "跑酷刷分~",
		script = "resources.luaScript.task.TaskNiuNianYiQiNiu",
		qrcode = "gh_12e6e8141fba",
		linkUrl = "http://bright-dairy.tb21.cn/bright-dairy-h5-2021/index",
		desc = "微信进入链接->玩一把跑酷~->脚本里面改分数~->点击执行任务~ \n 脚本：TaskNiuNianYiQiNiu_token.lua, 搜索修改score=你自己的分数",
	},
	{
		name = "期货消消乐~",
		script = "resources.luaScript.task.TaskXiaoXiaoLe",
		qrcode = "hualianqihuo",
		linkUrl = "https://a.myyqxiu.com/gs/aItuVpSXJ",
		desc = "扫码关注【华联期货】公众号,进公众号右下角~->微文化~->牛年大吉->进入游戏界面右上角~->点击活动锦囊->点击我的奖品->抓到CK->点击抽奖->顺利毕业~",
	},
	{
		name = "太平洋保险~",
		script = "resources.luaScript.task.TaskTaiPingYang",
		qrcode = "CPIC-LIFE",
		linkUrl = "https://mp.weixin.qq.com/s/5Oiv1W5IHuwOttH6M5qb-w",
		desc = "扫码关注->进第一篇文章~->进文章内图片小程序二维码[趣健康]->抓到CK->点击抽奖->顺利毕业~",
	},
	{
		name = "黄浦食品安全",
		script = "resources.luaScript.task.TaskFoodSafe",
		qrcode = "HP-MSA",
		linkUrl = "http://xinhua.mofangdata.cn/wx/prize/game/answercard.htm?id=402881d97622ed0201767e799f370ba0&prizeid=88&basescope=true&cardid=hpcj2020-10&backGroupId=ed4f2e0737334907ab811b17e316d164",
		desc = "扫码关注->公众号中间~有奖问答->抓到CK->点击抽奖->顺利毕业~",
	},
	{
		name = "红牛活动~",
		script = "resources.luaScript.task.TaskHongNiu",
		qrcode = "RedBull_ZheJiang",
		linkUrl = "http://hzhn2.msjp1.com/#/follow/504005",
		desc = "扫码关注->进活动链接~->抓到CK->点击抽奖->毕业~",
	},
	{
		name = "一汽丰田抽奖~",
		script = "resources.luaScript.task.TaskYiQiFengTian",
		qrcode = "",
		linkUrl = "https://sourl.cn/4fQsMg",
		desc = "复制链接微信内打开->输入手机号验证码->抽奖->顺利毕业~, 提示:本软件会自动帮你多抽100次~",
	},
	-- {
	-- 	name = "江都农商",
	-- 	script = "resources.luaScript.task.TaskNongShang_JiangDu",
	-- 	qrcode = "jdnsh96008",
	-- 	linkUrl = "http://jiangdu.bj-virgo.cn/win/WxyhServer_DY_V5/Areas/JDGoodStart/index.html",
	-- 	desc = "暂无说明",
	-- },
	-- {
	-- 	name = "扬州农商",
	-- 	script = "resources.luaScript.task.TaskNongShang_YangZhou",
	-- 	qrcode = "yznsyh96008",
	-- 	linkUrl = "http://yzweixin.yznsh.net/win/WxyhServerV5/Areas/YZGoodStart/PagesIndex/index.html",
	-- 	desc = "暂无说明",
	-- },
	-- {
	-- 	name = "仪征农商",
	-- 	script = "resources.luaScript.task.TaskNongShang_YiZheng",
	-- 	qrcode = "jsyznsh",
	-- 	linkUrl = "http://wxs.yzbank.com/win/WxyhServer_YZV5/Areas/YZGoodStart/index.html",
	-- 	desc = "暂无说明",
	-- },
	-- {
	-- 	name = "六合答题抽奖~",
	-- 	script = "resources.luaScript.task.TaskLiuHeChouJiang",
	-- 	qrcode = "gh_03b7ae1a9557",
	-- 	linkUrl = "",
	-- 	desc = "暂无说明",
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