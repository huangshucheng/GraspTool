local Sound = class("Sound")
local CSFun = require("resources.luaScript.util.CSFun")

--抓住token或cookie的音效
function Sound.playTokenSound()
	local path = CSFun.GetCurDir() .. [[\resources\sound\show10.wav]]
	-- local path = CSFun.GetCurDir() .. [[\resources\sound\dangdang.wav]]
	CSFun.PlayWAVSound(path)
end

--任务结束音效
function Sound.playFinishTaskSound()
	local path = CSFun.GetCurDir() .. [[\resources\sound\select.wav]]
	CSFun.PlayWAVSound(path)
end

--获得道具
function Sound.playGetAward()
	local path = CSFun.GetCurDir() .. [[\resources\sound\lobby_act_get_award.wav]]
	CSFun.PlayWAVSound(path)
end

--成功
function Sound.playSuccess()
	local path = CSFun.GetCurDir() .. [[\resources\sound\go.wav]]
	CSFun.PlayWAVSound(path)
end

return Sound