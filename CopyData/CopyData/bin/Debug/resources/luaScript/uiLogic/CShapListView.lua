-- LogOut("CShapScrollView.lua>>>>")

-- local luanet = require("luanet")

-- LogOut(tostring(luanet))

local CSFun = require("resources.luaScript.util.CSFun")
local CShapListView = class("CShapListView")

function CShapListView.ListView_add_columns(columnsName, width)
	if ListView_add_columns then
		ListView_add_columns(columnsName, width)
	end
end

function CShapListView.ListView_add_item(table)
	if ListView_add_item then
		ListView_add_item(table)
	end
end

function CShapListView.ListView_set_height(height)
	if ListView_set_height then
		ListView_set_height(height)
	end
end

function CShapListView.ListView_clear()
	if ListView_clear then
		ListView_clear()
	end
end

function CShapListView.ListView_get_itme_by_index(index)
	if ListView_get_itme_by_index then
		return ListView_get_itme_by_index(index)
	end
end

function CShapListView.ListView_get_select_index()
	if ListView_get_select_index then
		local retStr = ListView_get_select_index()
		local indexTable = json.decode(retStr) or {}
		return indexTable
	end
end

function CShapListView.ListView_set_checked(index, isCheck, isAll)
	if ListView_set_checked then
		index = index or 1
		isCheck = isCheck or false
		isAll = isAll or false
		return ListView_set_checked(index, isCheck, isAll)
	end
end


local initListView = function()
	CShapListView.ListView_add_columns(CSFun.Utf8ToDefault("序号"), 80)
	CShapListView.ListView_add_columns(CSFun.Utf8ToDefault("Cookie"), 250)
	CShapListView.ListView_add_columns(CSFun.Utf8ToDefault("结果"), 200)
	CShapListView.ListView_add_columns(CSFun.Utf8ToDefault("状态~"), 100)

	--test
	local tb = {[1] = 1, [2] = "Cookie=111", [3] = "result=111", [4] = "state=111"}
	local tb2 = {[1] = 2, [2] = "Cookie=222", [3] = "result=222", [4] = "state=222"}
	local tb3 = {[1] = 3, [2] = "Cookie=222", [3] = "result=222", [4] = "state=222"}
	local tb4 = {[1] = 4, [2] = "Cookie=222", [3] = "result=222", [4] = "state=222"}
	local tb5 = {[1] = 5, [2] = "Cookie=222", [3] = "result=222", [4] = "state=222"}
	local tb6 = {[1] = 6, [2] = "Cookie=222", [3] = "result=222", [4] = "state=222"}
	local tb7 = {[1] = 7, [2] = "Cookie=222", [3] = "result=222", [4] = "state=222"}
	local tb8 = {[1] = 8, [2] = "Cookie=222", [3] = "result=222", [4] = "state=222"}
	CShapListView.ListView_add_item(tb)
	CShapListView.ListView_add_item(tb2)
-- 	CShapListView.ListView_add_item(tb3)
-- 	CShapListView.ListView_add_item(tb4)
-- 	CShapListView.ListView_add_item(tb5)
-- 	CShapListView.ListView_add_item(tb6)
-- 	CShapListView.ListView_add_item(tb7)
-- 	CShapListView.ListView_add_item(tb8)
end

initListView()

return CShapListView