--[[所有交互记录]]
local TaskBase = require("luaScript.task.base.TaskBase")
local TaskAllRecord = class("TaskAllRecord", TaskBase)

-- TaskBase.FIND_STRING_HOST = "api.weixin.qq.com"
TaskBase.FIND_STRING_HOST = ""
TaskBase.FILE_SAVE_NAME = "task_all_url_token.lua"
TaskBase.RECORD_SAVE_FILE_NAME = "task_all_url_record.lua"
TaskBase.DATA_TO_FIND_ARRAY = {} --需要查找的taken 或者cookie
TaskBase.IS_OPEN_RECORD = true --是否抓取接口保存到本地

return TaskAllRecord