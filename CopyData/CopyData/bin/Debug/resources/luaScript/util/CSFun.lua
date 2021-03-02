-- c#的一些通用函数

local CSFun = class("CSFun")
local UIConfigData = require("resources.luaScript.data.UIConfigData")
local StringUtils = require("resources.luaScript.util.StringUtils")

--打印到输出界面
function CSFun.LogOut(data)
	if not UIConfigData.getIsShowOutLog() then
		return
	end
	if LogOut then
		LogOut(tostring(data))
	end
end

--打印到命令行
function CSFun.LogLua(data)
	if not UIConfigData.getIsShowOutLog() then
		return
	end
	if LogLua then
		LogLua(tostring(data))
	end
end

--获取fidder传过来的字符串
function CSFun.GetFidderString()
	if GetFidderString then
		return GetFidderString()
	end
end

--设置延时，time 秒
function CSFun.SetDelayTime(time ,func)
	if SetDelayTime then
		SetDelayTime(time, func)
	end
end

--定时器
--返回定时器ID
function CSFun.SetInterval(time, func)
	if SetInterval then
		return SetInterval(time, func)
	end
end

--停止某个定时器
-- timerID: 定时器ID，string类型
function CSFun.StopTimer(timerID)
	if StopTimer then
		return StopTimer(tostring(timerID))
	end
end

--删掉所有Timer定时器，timerIDExceptTable: 需要保留的timerID table
function CSFun.StopAllTimer(timerIDExceptTable)
	timerIDExceptTable = timerIDExceptTable or {}
	local paramType = type(timerIDExceptTable)
	if paramType == "table" then
		if StopAllTimer then
			StopAllTimer(timerIDExceptTable)
		end
	else
		print("error>>>> param is not talbe")
	end
end

--获取当前exe所在目录
function CSFun.GetCurDir()
	if GetCurDir then
		return GetCurDir()
	end
end

--获取桌面目录
function CSFun.GetDeskTopDir()
	if GetDeskTopDir then
		return GetDeskTopDir()
	end
end

--[[
url: "www.baidu.com"
callFunc: 回调
method: Method {GET,POST,PUT,DELETE}: 0 ,1 ,2 ,3
headTable:{AAA = "" , bbb = "" }
urlBody: "aaa=1&bbb=123"
postBody: "anything"
cookies: "cookie1=avlue;cookies2=cvalue"  需要用分号隔开
taskEndAction: lua function
proxyAddress:"false" --代理, 默认false 不开启
]]
--异步请求http
function CSFun.httpReqAsync(url, callFunc, reqCount, method, headTable, urlBody, postBody, cookies, proxyAddress)
	local Define = require("resources.luaScript.config.Define")
	method = method or Define.Method.GET
	headTable = headTable or {}
	urlBody = urlBody or ""
	postBody = postBody or ""
	cookies = cookies or ""
	proxyAddress = proxyAddress or ""
	reqCount = reqCount or 1
	if type(headTable) ~= "table" then
		headTable = {}
	end

	if not url or url == "" then 
		LogOut("error url is empty>> " .. debug.traceback())
		return
	 end

	 callFunc = callFunc or function(ret) end

	if HttpRequestAsync then
		HttpRequestAsync(url, method, headTable, urlBody, postBody, cookies, proxyAddress, callFunc, reqCount)
	end
end

--[[
function CSFun.HttpRequestDirect(url, callFunc, reqCount, method, headTable, urlBody, postBody, cookies, proxyAddress)
	local Define = require("resources.luaScript.config.Define")
	method = method or Define.Method.GET
	headTable = headTable or {}
	urlBody = urlBody or ""
	postBody = postBody or ""
	cookies = cookies or ""
	proxyAddress = proxyAddress or ""
	reqCount = reqCount or 1
	if type(headTable) ~= "table" then
		headTable = {}
	end

	if not url or url == "" then 
		LogOut("error url is empty>> " .. debug.traceback())
		return
	 end

	 callFunc = callFunc or function(ret) end

	if HttpRequestDirect then
		HttpRequestDirect(url, method, headTable, urlBody, postBody, cookies, proxyAddress, callFunc, reqCount)
	end
end
]]

--文件是否存在
function CSFun.IsFileExist(fileName)
	if IsFileExist then
		return IsFileExist(fileName)
	end
end

--写入字符串到文件，文件不存在会创建
function CSFun.WriteFile(fileName, dataStr)
	if WriteFile then
		return WriteFile(fileName, dataStr)
	end
end

--读取文件内容
function CSFun.ReadFile(fileName)
	if ReadFile then
		return ReadFile(fileName)
	end
end

--继续写入字符串
function CSFun.AppendText(fileName, dataStr)
	if AppendText then
		return AppendText(fileName, dataStr)
	end
end

--继续写入一行
function CSFun.AppendLine(fileName, dataStr)
	if AppendLine then
		return AppendLine(fileName, dataStr)
	end
end

--创建文件
function CSFun.CreateFile(fileName)
	if CreateFile then
		return CreateFile(fileName)
	end
end

--播放wav音效
function CSFun.PlayWAVSound(filePath)
	local UIConfigData = require("resources.luaScript.data.UIConfigData")
	if not UIConfigData.getIsOpenTipSound() then
		return
	end
	if PlayWAVSound then
		PlayWAVSound(filePath)
	end
end

--字符串比较
function CSFun.StringCompare(srcStr, desStr)
	if StringCompare then
		return StringCompare(srcStr, desStr)
	end
end

--字符串转码
function CSFun.Utf8ToDefault(str)
	if Utf8ToDefault then
		return Utf8ToDefault(str)
	end
end

--字符串转码
function CSFun.DefaultToUtf8(str)
	if DefaultToUtf8 then
		return DefaultToUtf8(str)
	end
end

-- 清理输出日志
function CSFun.ClearOutLog()
	if ClearOutLog then ClearOutLog() end
end

-- 设置到剪贴板
function CSFun.CopyToClipBoard(dataStr)
	if CopyToClipBoard then
		CopyToClipBoard(dataStr)
	end
end

-- 获取剪贴板内容
function CSFun.GetClipBoardData()
	if GetClipBoardData then
		return GetClipBoardData()
	end
end

--resStr是否是srcStr的子串
function CSFun.IsSubString(srcStr, resStr)
	if srcStr and resStr then
		if IsSubString then
			return IsSubString(srcStr, resStr)
		end
	end
end

-- base64加密
function CSFun.Base64Encode(sourceStr)
	if Base64Encode then
		return Base64Encode(sourceStr)
	end
end

-- base64解密
function CSFun.Base64Decode(sourceStr)
	if Base64Decode then
		return Base64Decode(sourceStr)
	end
end

-- md5加密
function CSFun.MD5Encode(sourceStr)
	if MD5Encode then
		return MD5Encode(sourceStr)
	end
end

-- sha1 加密
function CSFun.Sha1Encode(sourceStr)
	if Sha1Encode then
		return Sha1Encode(sourceStr)
	end
end

-- 字符转unicode
function CSFun.String2Unicode(sourceStr)
	if String2Unicode then
		return String2Unicode(sourceStr)
	end
end

-- Unicode转字符串
function CSFun.Unicode2String(sourceStr)
	if Unicode2String then
		return Unicode2String(sourceStr)
	end
end

--是否json字符串
function CSFun.IsJsonFormat(sourceStr)
	if IsJsonFormat then
		return IsJsonFormat(sourceStr)
	end
end

return CSFun