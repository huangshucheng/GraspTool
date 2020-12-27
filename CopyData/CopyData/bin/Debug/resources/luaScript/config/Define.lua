local Define = {}

Define.Method = {GET = 0, POST = 1}

Define.COOKIE_NAME = "Cookie" 

-- Fidder传过来的请求头
Define.REQ_HEAD_BEFORE = "reqHeader<"
Define.REQ_BODY_BEFORE = "reqBody<"
Define.RES_HEAD_BEFORE = "resHeader<"
Define.RES_BODY_BEFORE = "resBody<"
Define.RES_RECORD = "host<" --记录请求用
Define.QR_CODE_STR = "https://open.weixin.qq.com/qr/code?username="
-- Define.DEFAULT_PROXY = "http://127.0.0.1:8888" --默认使用代理 ，如果使用代理则如："http://127.0.0.1:8080", 如果不想用填false, 要用的话填true或指定IP端口
Define.DEFAULT_PROXY = "false" --默认使用代理 ，如果使用代理则如："http://127.0.0.1:8080", 如果不想用填false, 要用的话填true或指定IP端口

Define.HTTP_HEADER_TABLE = {
	["Accept"] = "application/json,text/javascript,text/html,text/plain,application/xhtml+xml,application/xml, */*; q=0.01",
	-- ["Proxy-Connection"] = "keep-alive",
	-- ["Connection"] = "keep-alive",
	["X-Requested-With"] = "XMLHttpRequest",
	["Accept-Encoding"] = "br, gzip, deflate",
	["Accept-Language"] = "zh-cn",
	["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8",
	["User-Agent"] = "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13G34 MicroMessenger/7.0.9(0x17000929) NetType/WIFI Language/zh_CN",
	-- ["Referer"] = "www.baidu.com",
}

return Define