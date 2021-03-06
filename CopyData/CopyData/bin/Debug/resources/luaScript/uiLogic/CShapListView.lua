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
function CShapListView.ListView_set_checked(index, isCheck)
	if ListView_set_checked then
		index = index or 1
		isCheck = isCheck or false
		return ListView_set_checked(index, isCheck)
	end
end

--设置是否全部选中
function CShapListView.ListView_set_all_checked(isCheck)
	if ListView_set_all_checked then
		ListView_set_all_checked(isCheck)
	end
end

--是否全部选中
function CShapListView.ListView_is_all_checked()
	local allCount = CShapListView.ListView_get_count()
	local selCount = #CShapListView.ListView_get_select_index()
	-- print("all: " .. allCount .. " , selCount: " .. selCount)
	return allCount == selCount
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

--删除item ，参数：index table
function CShapListView.ListView_remove_by_index_table(itemIndexTable)
	if not next(itemIndexTable) then
		return
	end
	if ListView_remove_by_index_table then
		local ret = ListView_remove_by_index_table(itemIndexTable)
		if ret then
			local FindData = require("resources.luaScript.data.FindData")
			FindData:getInstance():deleteToken(itemIndexTable)
			FindData:getInstance():readLocalFileToken()
		end
	end
end

--设置全选是否生效
function CShapListView.Strip_menu_set_allsel_enable(enable)
	if Strip_menu_set_allsel_enable then
		Strip_menu_set_allsel_enable(enable)
	end
end
--设置拷贝是否生效
function CShapListView.Strip_menu_set_copy_enable(enable)
	if Strip_menu_set_copy_enable then
		Strip_menu_set_copy_enable(enable)
	end
end

--设置粘贴是否生效
function CShapListView.Strip_menu_set_paste_enable(enable)
	if Strip_menu_set_paste_enable then
		Strip_menu_set_paste_enable(enable)
	end
end

--设置删除是否生效
function CShapListView.Strip_menu_set_delete_enable(enable)
	if Strip_menu_set_delete_enable then
		Strip_menu_set_delete_enable(enable)
	end
end

local initListView = function()
	CShapListView.ListView_add_columns(CSFun.Utf8ToDefault("序号(全选~)"), 80)
	CShapListView.ListView_add_columns(CSFun.Utf8ToDefault("Cookie"), 230)
	CShapListView.ListView_add_columns(CSFun.Utf8ToDefault("结果"), 150)
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