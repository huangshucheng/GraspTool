--[[荷声活动--跑步领奖活动]]

local TaskBase = require("resources.luaScript.task.base.TaskBase")
local TaskRun = class("TaskRun", TaskBase)

TaskBase.FIND_STRING_HOST = "hbz.qrmkt.cn"
TaskBase.FILE_SAVE_NAME = "task_run_token.lua"
TaskBase.RECORD_SAVE_FILE_NAME = "task_run_record.lua"
TaskBase.DATA_TO_FIND_ARRAY = {"token"} --需要查找的taken 或者cookie
TaskBase.IS_OPEN_RECORD = true --是否抓取接口保存到本地

return TaskRun