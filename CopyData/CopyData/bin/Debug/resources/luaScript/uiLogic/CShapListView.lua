local CSFun = require("resources.luaScript.util.CSFun")
local CShapListView = class("CShapListView")

-- 增加列
function CShapListView.ListView_add_columns(columnsName, width)
	if ListView_add_columns then
		ListView_add_columns(columnsName, width)
	end
end

-- 增加显示对象 例：{1, "Cookie=111", "result=111", "state=111"}
function CShapListView.ListView_add_item(table)
	if not next(table) then return end
	if ListView_add_item then
		ListView_add_item(table)
	end
end

-- 设置宽度
function CShapListView.ListView_set_height(height)
	if ListView_set_height then
		ListView_set_height(height)
	end
end

--清理所有内容
function CShapListView.ListView_clear()
	if ListView_clear then
		ListView_clear()
	end
end

--下标获取某个行节点内容
function CShapListView.ListView_get_itme_by_index(index)
	if ListView_get_itme_by_index then
		return ListView_get_itme_by_index(index)
	end
end

-- 获取选中下标
function CShapListView.ListView_get_select_index()
	if ListView_get_select_index then
		local retStr = ListView_get_select_index()
		local indexTable = json.decode(retStr) or {}
		return indexTable
	end
end

--设置选中某个行
function CShapListView.ListView_set_checked(index, isCheck, isAll)
	if ListView_set_checked then
		index = index or 1
		isCheck = isCheck or false
		isAll = isAll or false
		return ListView_set_checked(index, isCheck, isAll)
	end
end

--设置某个行节点内容, nil表示不改变原来值, 空字符串表示设置为空
--itemTable = {1, "Cookie=111", "result=111", "state=111"}
function CShapListView.ListView_set_item(itemTable)
	if ListView_set_item then
		return ListView_set_item(itemTable)
	end
end

--获取节点个数
function CShapListView.ListView_get_count()
	if ListView_get_count then
		return ListView_get_count()
	end
end

local initListView = function()
	CShapListView.ListView_add_columns(CSFun.Utf8ToDefault("序号"), 80)
	CShapListView.ListView_add_columns(CSFun.Utf8ToDefault("Cookie"), 230)
	CShapListView.ListView_add_columns(CSFun.Utf8ToDefault("结果"), 180)
	CShapListView.ListView_add_columns(CSFun.Utf8ToDefault("红包~"), 60)
	CShapListView.ListView_add_columns(CSFun.Utf8ToDefault("状态~"), 100)
	CShapListView.ListView_set_height(22)
	--test
	--[[
	local tb = {1, "Cookie=111", "result=111", "state=111"}
	local tb2 = {[1] = 2, [2] = "Cookie=222", [3] = "result=222", [4] = "state=222"}
	-- local tb = {[1] = 1, [2] = "Cookie=111", [3] = "result=111", [4] = "state=111"}
	local tb2 = {[1] = 2, [2] = "Cookie=222", [3] = "result=222", [4] = "state=222"}
	local tb3 = {[1] = 3, [2] = "Cookie=222", [3] = "result=222", [4] = "state=222"}
	local tb4 = {[1] = 4, [2] = "Cookie=222", [3] = "result=222", [4] = "state=222"}
	local tb5 = {[1] = 5, [2] = "Cookie=222", [3] = "result=222", [4] = "state=222"}
	local tb6 = {[1] = 6, [2] = "Cookie=222", [3] = "result=222", [4] = "state=222"}
	local tb7 = {[1] = 7, [2] = "Cookie=222", [3] = "result=222", [4] = "state=222"}
	local tb8 = {[1] = 8, [2] = "Cookie=222", [3] = "result=222", [4] = "state=222"}
	-- CShapListView.ListView_add_item(tb)
	]]
end

initListView()

return CShapListView