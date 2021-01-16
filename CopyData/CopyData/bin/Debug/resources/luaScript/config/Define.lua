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
-- Define.DEFAULT_PROXY = "http://127.0.0.1:8888" --如："http://127.0.0.1:8080", 如果不想用填false, 要用的话填true或指定IP端口
Define.DEFAULT_PROXY = "false" --默认使用代理 ，如果使用代理则如："http://127.0.0.1:8080"，如果指定了http://就用指定的http://，如果没加就会默认加上https://

Define.ANYPROXY_WEB_SOCKET_URL = "ws://hccfun.com:8002/do-not-proxy"; -- anyproxy 自身ws address
Define.ANYPROXY_SELF_WS_URL = "ws://hccfun.com:8005" --自己创建的ws address

--获取本机IP和地理位置的URL
Define.IP_ADDRESS_URL = "http://pv.sohu.com/cityjson?ie=utf-8" --比较快
-- Define.IP_ADDRESS_URL = "http://ip-api.com/json/?lang=zh-CN" --比较慢

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

--[[
数据格式：
[reqHeader<res.wx.qq.com>] 
GET https://res.wx.qq.com/open/libs/weui/2.0-alpha.1/weui.min.css HTTP/1.1
Host: res.wx.qq.com
Connection: keep-alive
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36 QBCore/4.0.1301.400 QQBrowser/9.0.2524.400 Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36 NetType/WIFI MicroMessenger/7.0.20.1781(0x6700143B) WindowsWechat
Accept: text/css,*/*;q=0.1

[reqBody<res.wx.qq.com>] 
xxx=1223

[resBody<www.baidu.com>]
123

]]

return Define