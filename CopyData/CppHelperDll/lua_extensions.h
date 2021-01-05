#pragma once

#if defined(_USRDLL)
    #define LUA_EXTENSIONS_DLL     __declspec(dllexport)
#else
    #define LUA_EXTENSIONS_DLL
#endif

#if __cplusplus
extern "C" {
#endif

#include "lauxlib.h"

void LUA_EXTENSIONS_DLL luaopen_lua_extensions(lua_State *L);
    
#if __cplusplus
}
#endif
