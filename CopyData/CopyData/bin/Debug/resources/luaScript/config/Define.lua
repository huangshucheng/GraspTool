local Define = {}

Define.Method = {GET = 0, POST = 1, PUT = 2, DELETE = 3, OPTIONS = 4}

Define.COOKIE_NAME = "Cookie" 

-- Fidder传过来的请求头
Define.QR_CODE_STR = "https://open.weixin.qq.com/qr/code?username=" --二维码获取链接，后面跟公众号名称就能显示公众号二维码
Define.PROXY_LOG_URL = "http://hccluck.com:8002/" --日志显示链接
-- Define.DEFAULT_PROXY = "http://127.0.0.1:8888" --如："http://127.0.0.1:8080", 如果不想用填false, 要用的话填true或指定IP端口
-- true可以被Fidder捕捉到，"false"不能捕捉到
Define.DEFAULT_PROXY = "false" --默认使用代理 ，如果使用代理则如："http://127.0.0.1:8080"，如果指定了http://就用指定的http://，如果没加就会默认加上https://

Define.LOG_LINE_COUNT_LIMIE = 1000 --日志限制行数

-- Define.ANYPROXY_WEB_SOCKET_URL = "ws://hccfun.com:8002/do-not-proxy"; -- anyproxy 自身ws address
Define.ANYPROXY_SELF_WS_URL = "ws://hccluck.com:8005" --自己创建的ws address

--获取本机IP和地理位置的URL
Define.IP_ADDRESS_URL = "http://pv.sohu.com/cityjson?ie=utf-8" --比较快

Define.HTTP_HEADER_TABLE = {
	-- ["Accept"] = "application/json,text/javascript,text/html,text/plain,application/xhtml+xml,application/xml, */*; q=0.01",
	-- ["Proxy-Connection"] = "keep-alive",
	-- ["Connection"] = "keep-alive",
	-- ["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8; application/json",
	-- ["Referer"] = "www.baidu.com",
	["Accept"] = "*/*",
	-- ["X-Requested-With"] = "XMLHttpRequest",
	["Accept-Encoding"] = "br, gzip, deflate",
	["Accept-Language"] = "zh-cn",
	["Content-Type"] = "application/json",
	["User-Agent"] = "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13G34 MicroMessenger/7.0.9(0x17000929) NetType/WIFI Language/zh_CN",
}

return Define