--[[微信登录记录]]
local TaskBase = require("luaScript.task.base.TaskBase")
local TaskWeiXinAuth = class("TaskWeiXinAuth", TaskBase)

-- TaskBase.FIND_STRING_HOST = "api.weixin.qq.com"
TaskBase.FIND_STRING_HOST = "szextshort.weixin.qq.com"
TaskBase.FILE_SAVE_NAME = "task_weixin_auth_token.lua"
TaskBase.RECORD_SAVE_FILE_NAME = "task_weixin_auth_record.lua"
TaskBase.DATA_TO_FIND_ARRAY = {} --需要查找的taken 或者cookie
TaskBase.IS_OPEN_RECORD = true --是否抓取接口保存到本地

return TaskWeiXinAuth