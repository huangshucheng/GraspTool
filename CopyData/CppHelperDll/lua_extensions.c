#include "lua_extensions.h"
#include "stdafx.h"

#if __cplusplus
extern "C" {
#endif

#include "lua.h"
#include "lualib.h"  
#include "lauxlib.h" 
#include "lua_extensions.h"
// luasocket
//#include "luasocket/luasocket.h"
//#include "luasocket/mime.h"
//#include "cjson/lua_cjson.h"
#include "3third/luasocket/luasocket.h"
#include "3third/luasocket/mime.h"
#include "3third/cjson/lua_cjson.h"
//#include "luasocket_scripts.h"
#include "3third/luasocket/luasocket_scripts.h"


static luaL_Reg luax_exts[] = {
    //{"socket.core", luaopen_socket_core},
    //{"mime.core", luaopen_mime_core},
	//{"cjson", luaopen_cjson},
    {NULL, NULL}
};

static const char *lua_m_socket = "";

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
    //lua_pop(L, 2);

    //luaopen_luasocket_scripts(L);
	
	//luaL_loadstring(L, lua_m_socket);
	//lua_settop(L,0);
}

#if __cplusplus
} // extern "C"
#endif
