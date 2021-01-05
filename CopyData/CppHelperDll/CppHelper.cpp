#pragma once

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
#include "lua_extensions.h"
#pragma comment (lib, "lua.lib")
}
#else  
#include "lua.h"
#include "lualib.h"  
#include "lauxlib.h"  
#endif

using namespace std;

extern "C" __declspec(dllexport) void initLua(lua_State* state)
{
	luaopen_lua_extensions(state);
}