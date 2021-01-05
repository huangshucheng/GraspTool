#pragma once

#if __cplusplus
extern "C" {
#endif

#include "lua.h"

void luaopen_luasocket_scripts(lua_State* L);

#if __cplusplus
}
#endif