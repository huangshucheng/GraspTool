// LuaHelperDll.cpp : 定义 DLL 应用程序的导出函数。
//

#include "stdafx.h"
#include <iostream>
#include <string>
#include <sstream>
#include <map>
#include <vector>
#include <time.h>

#ifdef __cplusplus
extern "C" {
#include "lua.h"
#include "lualib.h"  
#include "lauxlib.h" 
// socket
#include "luasocket/luasocket.h"
#include "luasocket/luasocket_scripts.h"
#include "luasocket/mime.h"
#include "cjson/lua_cjson.h"
//TODO HCC
/*
static luaL_Reg luax_exts[] = {
	{"socket.core", luaopen_socket_core},
	{"mime.core", luaopen_mime_core},
	{"cjson", luaopen_cjson},
	{NULL, NULL}
};

void luaopen_lua_extensions(lua_State *L)
{
	// load extensions
	luaL_Reg* lib = luax_exts;
	lua_getglobal(L, "package");
	lua_getfield(L, -1, "preload");
	for (; lib->func; lib++)
	{
		lua_pushcfunction(L, lib->func);
		lua_setfield(L, -2, lib->name);
	}
	lua_pop(L, 2);
	luaopen_luasocket_scripts(L);
}
*/
}
#else  
#include "lua.h"
#include "lualib.h"  
#include "lauxlib.h"  
#endif

using namespace std;

//导入函数到dll
extern "C" __declspec(dllexport) bool LuaTestHcc()
{
	return false;
}