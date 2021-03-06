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
}
#else  
#include "lua.h"
#include "lualib.h"  
#include "lauxlib.h"  
#endif

#define LOG_ERROR	(1)
#define LOG_WARN	(2)
#define LOG_INFO	(3)
#define LOG_DEBUG	(4)

using namespace std;

#define TASK_OK				0
#define TASK_ERROR			-1
#define TASK_KEY_NOTEXIST	-2
#define TASK_REDIS_ERROR	-3
#define TASK_PARAM_ERROR	-4
#define TASK_TABLE_NOTEXIST -5
#define TASK_DBEXEC_ERROR	-6
#define TASK_DATA_EXIST		-7
#define TASK_PARAMCNT_ERROR -11
#define TASK_DATA_NOT_EXIST	-12

/******************old award redis key**************************/
#define REDIS_HD_TIMESTAMP_KEY          "award_hd_update_time_%d_%d"
#define REDIS_HD_RANKING_KEY            "award_hd_rl_%d_%d"
#define AREDIS_HD_TIMESTAMP_KEY         "aaward_hd_update_time_%d_%d_%d_%d"
#define AREDIS_HD_RANKING_KEY           "aaward_hd_rl_%d_%d_%d_%d"
#define XREDIS_HD_TIMESTAMP_KEY         "xaward_hd_update_time_%d_%d_%d"
#define XREDIS_HD_RANKING_KEY           "xaward_hd_rl_%d_%d_%d"
/***************************************************************/

typedef struct
{
	int nAreaId;
	int nGameId;
	int nType;
	int nNumId;
	long long lCnt;
	int nTimeStamp;
} UserVirData_S;

map<string, int> g_mpUserData;		// Incr用
map<string, string> g_mpStringData;	// LuaSetStringTaskData用
map<string, vector<int>> g_mpUserListData;	// PushUserListData用
map<string, map<int, int>> g_mpUserScore;	// ZIncrUserTaskData用
map<string, map<long long, long long>> g_mpVirData; // LuaZScoreVirDataByUid
lua_State *m_pstLuaState = NULL;
vector<UserVirData_S> m_vecUserVirData;

struct WebProtoRespJson
{
	string strInfo;
	int nStatus;
	string strData;
};

WebProtoRespJson respGetTaskConfig;
WebProtoRespJson respGetPoolConfig;
WebProtoRespJson respDrawAward;
WebProtoRespJson respSendAward;

bool HGet(string strKey, long long uid, long long &llVal)
{
	if (g_mpVirData.find(strKey) == g_mpVirData.end())
	{
		return false;
	}
	else
	{
		map<long long, long long> mpData = g_mpVirData[strKey];
		if (mpData.find(uid) == mpData.end())
		{
			return false;
		}
		else
		{
			llVal = mpData[uid];
			return true;
		}
	}
}

bool HSet(string strKey, long long uid, long long &llVal)
{
	map<long long, long long> mpData;

	if (g_mpVirData.find(strKey) != g_mpVirData.end())
	{
		mpData = g_mpVirData[strKey];
	}

	mpData[uid] = llVal;
	g_mpVirData[strKey] = mpData;
	return true;
}

bool ZScore(string strKey, long long uid, long long &llVal)
{
	return HGet(strKey, uid, llVal);
}

bool ZIncrby(string strKey, long long uid, long long llVal)
{
	map<long long, long long> mpData;

	if (g_mpVirData.find(strKey) != g_mpVirData.end())
	{
		mpData = g_mpVirData[strKey];
	}

	mpData[uid] += llVal;
	g_mpVirData[strKey] = mpData;
	return true;
}

bool ZAdd(string strKey, long long uid, long long llVal)
{
	return HSet(strKey, uid, llVal);
}

bool GetVirDataByDB(int nAreaid, int nGameid, int nType, int nNumid, long long &lCnt, int &nTimeStamp)
{
	for (auto &v : m_vecUserVirData)
	{
		if (v.nAreaId == nAreaid && v.nGameId == nGameid && v.nType == nType && v.nNumId == nNumid)
		{
			lCnt = v.lCnt;
			nTimeStamp = v.nTimeStamp;
			return true;
		}
	}
	return false;
}

bool UpdateVirDataByDB(int nAreaid, int nGameid, int nType, int nNumid, long long lCnt, bool bCover)
{
	for (auto &v : m_vecUserVirData)
	{
		if (v.nAreaId == nAreaid && v.nGameId == nGameid && v.nType == nType && v.nNumId == nNumid)
		{
			if (bCover)
			{
				v.lCnt = lCnt;return true;
				return true;
			}
		}
	}
	UserVirData_S vd;
	vd.nAreaId = nAreaid;
	vd.nGameId = nGameid;
	vd.nType = nType;
	vd.nNumId = nNumid;
	vd.lCnt = lCnt;
	vd.nTimeStamp = (int)time(NULL);
	m_vecUserVirData.push_back(vd);

	return true;
}

// 日志接口
typedef void(*pfLog)(const char *s);
pfLog m_pfLog = NULL;
extern "C" __declspec(dllexport) void LogInit(void(*pfLog)(const char *s))
{
	m_pfLog = pfLog;
}

#define LOG(s)															\
{																		\
	stringstream ss;													\
	ss << "[" << __FUNCTION__ << ":" << __LINE__ << "] " << s;			\
	m_pfLog(ss.str().c_str());											\
}																		\

#define PARAM_CHECK(n, L)						\
{												\
	if (n != lua_gettop(L))						\
	{											\
		LOG("err paramcnt: " << lua_gettop(L));	\
		lua_settop(L, 0);						\
		nFuncRet = TASK_PARAMCNT_ERROR;			\
		break;									\
	}											\
}

// C++提供给Lua调用的接口
/**
 * 1、日志输出，第一个参数日志等级，第二个参数时要打印的日志
 * Example: Log(LOG_ERROR, "This is a log test 1");
 */
int LuaLog(lua_State *L)
{
	int nErrorLevel = (int)lua_tointeger(L, 1);
	std::string strLog = lua_tostring(L, 2);
	LOG(strLog);

	return TASK_OK;
}

/**
 * 2、给某个玩家增加某个数据的值，val大于0。返回值为int，是否增加成功，0为成功，非0不成功
 * Example: IncrUserTaskData("task_signup_1_61497002_7", 1);
 */
int LuaIncrUserTaskData(lua_State *L)
{
	std::string strKey = lua_tostring(L, 1);
	int nVal = (int)lua_tointeger(L, 2);
	int nRet = 0;
	int nFuncRet = TASK_OK;

	if (nVal > 0)
	{
		map<string, int>::iterator it = g_mpUserData.find(strKey);
		if (g_mpUserData.find(strKey) != g_mpUserData.end())
		{
			g_mpUserData[strKey] += nVal;
			//LOG("LuaIncrUserTaskData incr val=" << nVal << ",ret=" << g_mpUserData[strKey]);
			nRet = g_mpUserData[strKey];
		}
		else
		{
			g_mpUserData[strKey] = nVal;
			nRet = g_mpUserData[strKey];
			//LOG("LuaIncrUserTaskData first add");
		}
	}
	else
	{
		//LOG("LuaIncrUserTaskData val error, val=" << nVal);
		nFuncRet = TASK_PARAM_ERROR;
	}

	// 返回值
	lua_pushinteger(L, nFuncRet);
	lua_pushinteger(L, nRet);
	return 2;
}

/**
 * 3、获取某个玩家某个数据的值，返回值有2个，第一个int表示获取成功(0)或失败(非0)，第二个int为获取的数据
 * Example: GetUserTaskData("task_signup_1_61497002_7");
 */
int LuaGetUserTaskData(lua_State *L)
{
	int nVal = 0;
	int nFuncRet = TASK_OK;
	std::string strKey = lua_tostring(L, 1);

	map<string, int>::iterator it = g_mpUserData.find(strKey);
	if (it != g_mpUserData.end())
	{
		nVal = g_mpUserData[strKey];
		//LOG("LuaGetUserTaskData: success get val=" << nVal);
	}
	else
	{
		//LOG("LuaGetUserTaskData: cannot find val");
		nFuncRet = TASK_KEY_NOTEXIST;
	}

	// 返回值
	lua_pushinteger(L, nFuncRet);
	lua_pushinteger(L, nVal);
	return 2;
}

/**
 * 4、给玩家发送奖励
 * Example: SendUserAward(1,61497002,2039,3);
 */
int LuaSendUserAward(lua_State *L)
{
	int nFuncRet = TASK_OK;
	int nAreaId = (int)lua_tointeger(L, 1);
	int nNumId = (int)lua_tointeger(L, 2);
	int nPropId = (int)lua_tointeger(L, 3);
	int nAward = (int)lua_tointeger(L, 4);

	//LOG("LuaSendUserAward send user task");
	//nFuncRet = CLuaHelper::GetServer()->SendUserTaskAward(nAreaId, nNumId, nPropId, nAward);

	lua_pushinteger(L, nFuncRet);
	return 1;
}

/**
 * 5、通知客户端任务进度
 */
int LuaNotifyTaskPercent(lua_State *L)
{
	int nFuncRet = TASK_OK;

	int nAreaId = (int)lua_tointeger(L, 1);
	int nNumId = (int)lua_tointeger(L, 2);
	int nTaskId = (int)lua_tointeger(L, 3);
	int nComplete = (int)lua_tointeger(L, 4);
	int nTotal = (int)lua_tointeger(L, 5);

	//LOG("send task percent, " << ",aid=" << nAreaId << ",nid=" << nNumId << ",taskid=" << nTaskId
	//	<< "," << nComplete << "/" << nTotal);
	//nFuncRet = CLuaHelper::GetServer()->NofityTaskPercent(nAreaId, nNumId, nTaskId, nComplete, nTotal);

	lua_pushinteger(L, nFuncRet);
	return 1;
}

/**
* 6、向某个key中插入数据
*/
int LuaPushUserListData(lua_State *L)
{
	int nFuncRet = TASK_OK;

	std::string strKey = lua_tostring(L, 1);
	int nVal = lua_tointeger(L, 2);
	int nExpire = lua_tointeger(L, 3);

	vector<int> vecUserData;
	bool bIsExist = false;

	map<string, vector<int>>::iterator it = g_mpUserListData.find(strKey);
	if (it != g_mpUserListData.end())
	{
		vecUserData = g_mpUserListData[strKey];
		for (int i = 0; i < (int)vecUserData.size(); i++)
		{
			if (nVal == vecUserData[i])
			{
				bIsExist = true;
				break;
			}
		}
		if (bIsExist)
		{
			//LOG("key=" << strKey << ",val=" << nVal << " exist");
			nFuncRet = TASK_DATA_EXIST;
		}
		else
		{
			vecUserData.push_back(nVal);
			g_mpUserListData[strKey] = vecUserData;
			//LOG("add key=" << strKey << ",val=" << nVal << " success");
		}
	}
	else
	{
		//LOG("first add user list data, key=" << strKey << ",val=" << nVal);

		vecUserData.push_back(nVal);
		g_mpUserListData[strKey] = vecUserData;
	}

	lua_pushinteger(L, nFuncRet);
	return 1;
}

/**
* 7、获取玩家数据，返回数据格式为：1_2_3
*/
int LuaGetUserListData(lua_State *L)
{
	int nFuncRet = TASK_OK;
	std::string strKey = lua_tostring(L, 1);
	bool bIsExist = false;
	std::string strRet = "";

	vector<int> vecUserData;
	map<string, vector<int>>::iterator it = g_mpUserListData.find(strKey);
	if (it != g_mpUserListData.end())
	{
		vecUserData = g_mpUserListData[strKey];
		stringstream ssdata;
		for (int i = 0; i < (int)vecUserData.size(); i++)
		{
			if (i == (int)vecUserData.size() - 1)
			{
				ssdata << vecUserData[i];
			}
			else
			{
				ssdata << vecUserData[i] << "_";
			}
		}
		strRet = ssdata.str();
		//LOG("get key=" << strKey << ",data=" << strRet);
	}
	else
	{
		//LOG("key=" << strKey << " not exist");
		nFuncRet = TASK_KEY_NOTEXIST;
	}

	lua_pushinteger(L, nFuncRet);
	lua_pushstring(L, strRet.c_str());

	return 2;
}

/**
* 8、清空玩家数据
*/
int LuaClearUserTaskData(lua_State *L)
{
	int nFuncRet = TASK_OK;
	std::string strKey = lua_tostring(L, 1);
	bool bIsExist = false;

	vector<int> vecUserData;
	vecUserData.clear();
	if (g_mpUserListData.find(strKey) != g_mpUserListData.end())
	{
		g_mpUserListData[strKey] = vecUserData;
	}
	else if (g_mpUserData.find(strKey) != g_mpUserData.end())
	{
		g_mpUserData[strKey] = 0;
	}
	else if (g_mpStringData.find(strKey) != g_mpStringData.end())
	{
		g_mpStringData[strKey] = "";
	}
	else if (g_mpUserScore.find(strKey) != g_mpUserScore.end())
	{
		map<int, int> m;
		g_mpUserScore[strKey] = m;
	}
	else
	{
		nFuncRet = TASK_KEY_NOTEXIST;
	}

	lua_pushinteger(L, nFuncRet);
	return 1;
}

/**
* 9、设置任务数据
*/
int LuaSetStringTaskData(lua_State *L)
{
	int nFuncRet = TASK_OK;
	std::string strKey = lua_tostring(L, 1);
	std::string strVal = lua_tostring(L, 2);
	int nExpire = lua_tointeger(L, 3);

	g_mpStringData[strKey] = strVal;
	//LOG("set string data, key=" << strKey << ",val=" << strVal << ",expire=" << nExpire);

	lua_pushinteger(L, nFuncRet);
	return 1;
}

/**
* 10、获取任务数据
*/
int LuaGetStringTaskData(lua_State *L)
{
	int nFuncRet = TASK_OK;
	std::string strKey = lua_tostring(L, 1);
	std::string strVal = "";

	if (g_mpStringData.find(strKey) != g_mpStringData.end())
	{
		strVal = g_mpStringData[strKey];
		//LOG("get string data, key=" << strKey << ",val=" << strVal);
	}
	else
	{
		nFuncRet = TASK_KEY_NOTEXIST;
		//LOG("get string data, key=" << strKey << " not exist");
	}

	lua_pushinteger(L, nFuncRet);
	lua_pushstring(L, strVal.c_str());
	return 2;
}

/**
* 11、增加有序集合key中member的score
*/
int LuaZIncrUserTaskData(lua_State *L)
{
	int nFuncRet = TASK_OK;
	string strKey = lua_tostring(L, 1);
	int nMemId = lua_tointeger(L, 2);
	int nScore = lua_tointeger(L, 3);
	int nExpire = lua_tointeger(L, 4);

	map<int, int> mpScore;
	if (g_mpUserScore.find(strKey) == g_mpUserScore.end())
	{
		mpScore[nMemId] = nScore;
	}
	else
	{
		mpScore = g_mpUserScore[strKey];
		mpScore[nMemId] += nScore;
	}
	g_mpUserScore[strKey] = mpScore;

	lua_pushinteger(L, nFuncRet);
	return 1;
}

/**
* 12、获取有序集合key中member的score
*/
int LuaZScoreUserTaskData(lua_State *L)
{
	int nFuncRet = TASK_OK;
	string strKey = lua_tostring(L, 1);
	int nMemId = lua_tointeger(L, 2);
	int nScore = 0;

	if (g_mpUserScore.find(strKey) != g_mpUserScore.end())
	{
		map<int, int> mpScore = g_mpUserScore[strKey];
		if (mpScore.find(nMemId) != mpScore.end())
		{
			nScore = mpScore[nMemId];
		}
		else
		{
			nFuncRet = TASK_REDIS_ERROR;
		}
	}
	else
	{
		nFuncRet = TASK_REDIS_ERROR;
	}

	lua_pushinteger(L, nFuncRet);
	lua_pushinteger(L, nScore);
	return 2;
}

/**
* 13、获取用户道具数量
*/
int LuaGetUserPropCount(lua_State *L)
{
	int nFuncRet = TASK_OK;
	int nPropCnt = 100;
	long long nTimeStamp = time(NULL);

	lua_pushinteger(L, nFuncRet);
	lua_pushinteger(L, nPropCnt);
	lua_pushinteger(L, nTimeStamp);
	return 3;
}

/**
* 14、记录参加活动玩家
*/
int LuaRecordTaskUser(lua_State *L)
{
	int nFuncRet = TASK_OK;
	
	lua_pushinteger(L, nFuncRet);
	return 1;
}

/**
 * 15、获取玩家虚拟数据与对应时间(MemId为Uid)
 * 对应奖励服务接口getinforedis
 */
int LuaZScoreVirDataByUid(lua_State *L)
{
	int nFuncRet = TASK_OK;

	long long lCnt = 0;
	int nTimeStamp = 0;
	long long llTimeStamp = 0;
	do
	{
		// check param cnt
		PARAM_CHECK(4, L);

		int nAreaid = lua_tointeger(L, 1);
		int nGameid = lua_tointeger(L, 2);
		int nType = lua_tointeger(L, 3);
		int nNumid = lua_tointeger(L, 4);
		lua_settop(L, 0);
		//OFSLOGD("aid=" << nAreaid << ",gid=" << nGameid << ",type=" << nType << ",nid=" << nNumid);

		char szKey[200];
		long long uid = (((long long)nAreaid << 32) | nNumid);
		snprintf(szKey, sizeof(szKey), REDIS_HD_TIMESTAMP_KEY, nGameid, nType);
		if (!HGet(szKey, uid, llTimeStamp))
		{
			nFuncRet = TASK_DATA_NOT_EXIST;
			break;
		}

		snprintf(szKey, sizeof(szKey), REDIS_HD_RANKING_KEY, nGameid, nType);
		if (!ZScore(szKey, uid, lCnt))
		{
			nFuncRet = TASK_DATA_NOT_EXIST;
			break;
		}
		//OFSLOGD("timestamp=" << nTimeStamp << ",count=" << lCnt);

	} while (false);

	nTimeStamp = (int)llTimeStamp;
	lua_pushinteger(L, nFuncRet);
	lua_pushnumber(L, (double)lCnt);
	lua_pushinteger(L, nTimeStamp);
	return 3;
}

/**
 * 16、增加玩家虚拟数据并更新时间(MemId为Uid)
 * 对应奖励服务接口addinforedis
 */
int LuaZIncrVirDataByUid(lua_State *L)
{
	int nFuncRet = TASK_OK;
	do
	{
		// check param cnt
		PARAM_CHECK(6, L);

		int nAreaid = lua_tointeger(L, 1);
		int nGameid = lua_tointeger(L, 2);
		int nType = lua_tointeger(L, 3);
		int nNumid = lua_tointeger(L, 4);
		long long lCnt = lua_tointeger(L, 5);
		int nExpire = lua_tointeger(L, 6);
		lua_settop(L, 0);
		//OFSLOGD("aid=" << nAreaid << ",gid=" << nGameid << ",type=" << nType
		//	<< ",nid=" << nNumid << ",count=" << lCnt << ",expire=" << nExpire);

		char szKey[200];
		long long uid = (((long long)nAreaid << 32) | nNumid);
		snprintf(szKey, sizeof(szKey), REDIS_HD_RANKING_KEY, nGameid, nType);
		if (!ZIncrby(szKey, uid, lCnt))
		{
			//OFSLOGE("redis zincrby failed,key=" << szKey << ",nid=" << nNumid);
			nFuncRet = TASK_REDIS_ERROR;
			break;
		}

		long long nTimeStamp = time(NULL);
		snprintf(szKey, sizeof(szKey), REDIS_HD_TIMESTAMP_KEY, nGameid, nType);
		if (!HSet(szKey, uid, nTimeStamp))
		{
			//OFSLOGE("redis hset failed,key=" << szKey << ",nid=" << nNumid);
			nFuncRet = TASK_REDIS_ERROR;
			break;
		}

	} while (false);

	lua_pushinteger(L, nFuncRet);
	return 1;
}

/**
 * 17、设置玩家虚拟数据并更新时间(MemId为Uid)
 * 对应奖励服务接口setinforedis
 */
int LuaZAddVirDataByUid(lua_State *L)
{
	int nFuncRet = TASK_OK;
	do
	{
		// check param cnt
		PARAM_CHECK(6, L);

		int nAreaid = lua_tointeger(L, 1);
		int nGameid = lua_tointeger(L, 2);
		int nType = lua_tointeger(L, 3);
		int nNumid = lua_tointeger(L, 4);
		long long lCnt = (long long)lua_tonumber(L, 5);
		int nExpire = lua_tointeger(L, 6);
		lua_settop(L, 0);
		//OFSLOGI("aid=" << nAreaid << ",gid=" << nGameid << ",type=" << nType
		//	<< ",nid=" << nNumid << ",count=" << lCnt << ",expire=" << nExpire);

		char szKey[200];
		long long uid = (((long long)nAreaid << 32) | nNumid);

		snprintf(szKey, sizeof(szKey), REDIS_HD_RANKING_KEY, nGameid, nType);
		if (!ZAdd(szKey, uid, lCnt))
		{
			//OFSLOGE("redis zadd failed,key=" << szKey << ",nid=" << nNumid);
			nFuncRet = TASK_REDIS_ERROR;
			break;
		}

		long long nTimeStamp = time(NULL);
		snprintf(szKey, sizeof(szKey), REDIS_HD_TIMESTAMP_KEY, nGameid, nType);
		if (!HSet(szKey, uid, nTimeStamp))
		{
			//OFSLOGE("redis hset failed,key=" << szKey << ",nid=" << nNumid);
			nFuncRet = TASK_REDIS_ERROR;
			break;
		}

	} while (false);

	lua_pushinteger(L, nFuncRet);
	return 1;
}

/**
 * 18、设置玩家虚拟数据并更新时间(MemId为Numid,Key包含Agid)
 * 对应奖励服务接口getinfoa
 */
int LuaZScoreVirDataByNid_WithAgid(lua_State *L)
{
	int nFuncRet = TASK_OK;
	long long lCnt = 0;
	int nTimeStamp = 0;
	long long llTimeStamp = 0;
	do
	{
		// check param cnt
		PARAM_CHECK(5, L);

		int nAreaid = lua_tointeger(L, 1);
		int nGameid = lua_tointeger(L, 2);
		int nAgid = lua_tointeger(L, 3);
		int nType = lua_tointeger(L, 4);
		int nNumid = lua_tointeger(L, 5);
		lua_settop(L, 0);
		//OFSLOGD("aid=" << nAreaid << ",gid=" << nGameid << ",agid=" << nAgid
		//	<< ",type=" << nType << ",nid=" << nNumid);

		char szKey[200];
		snprintf(szKey, sizeof(szKey), AREDIS_HD_TIMESTAMP_KEY, nGameid, nAgid, nType, nAreaid);
		if (!HGet(szKey, nNumid, llTimeStamp))
		{
			nFuncRet = TASK_DATA_EXIST;
			break;
		}

		snprintf(szKey, sizeof(szKey), AREDIS_HD_RANKING_KEY, nGameid, nAgid, nType, nAreaid);
		if (!ZScore(szKey, nNumid, lCnt))
		{
			nFuncRet = TASK_DATA_EXIST;
			break;
		}

		//OFSLOGD("timestamp=" << nTimeStamp << ",count=" << lCnt);
	} while (false);

	nTimeStamp = (int)llTimeStamp;
	lua_pushinteger(L, nFuncRet);
	lua_pushnumber(L, (double)lCnt);
	lua_pushinteger(L, nTimeStamp);
	return 3;
}

/**
 * 20、设置玩家虚拟数据并更新时间(MemId为Numid,Key包含Agid)
 * 对应奖励服务接口setinfoa
 */
int LuaZAddVirDataByNid_WithAgid(lua_State *L)
{
	int nFuncRet = TASK_OK;
	do
	{
		// check param cnt
		PARAM_CHECK(7, L);

		int nAreaid = lua_tointeger(L, 1);
		int nGameid = lua_tointeger(L, 2);
		int nAgid = lua_tointeger(L, 3);
		int nType = lua_tointeger(L, 4);
		int nNumid = lua_tointeger(L, 5);
		long long lCnt = (long long)lua_tonumber(L, 6);
		int nExpire = lua_tointeger(L, 7);
		lua_settop(L, 0);
		//OFSLOGD("aid=" << nAreaid << ",gid=" << nGameid << ",agid=" << nAgid << ",type=" << nType
		//	<< ",nid=" << nNumid << ",count=" << lCnt << ",expire=" << nExpire);

		char szKey[200];
		snprintf(szKey, sizeof(szKey), AREDIS_HD_RANKING_KEY, nGameid, nAgid, nType, nAreaid);
		if (!ZAdd(szKey, nNumid, lCnt))
		{
			//OFSLOGE("redis zadd failed,key=" << szKey << ",nid=" << nNumid);
			nFuncRet = TASK_REDIS_ERROR;
			break;
		}

		long long nTimeStamp = time(NULL);
		snprintf(szKey, sizeof(szKey), AREDIS_HD_TIMESTAMP_KEY, nGameid, nAgid, nType, nAreaid);
		if (!HSet(szKey, nNumid, nTimeStamp))
		{
			//OFSLOGE("redis hset failed,key=" << szKey << ",nid=" << nNumid);
			nFuncRet = TASK_REDIS_ERROR;
			break;
		}

	} while (false);

	lua_pushinteger(L, nFuncRet);
	return 1;
}

/**
 * 19、增加玩家虚拟数据并更新时间(MemId为Numid,Key包含Agid)
 * 对应奖励服务接口addinfoa
 */
int LuaZIncrVirDataByNid_WithAgid(lua_State *L)
{
	int nFuncRet = TASK_OK;
	do
	{
		// check param cnt
		PARAM_CHECK(7, L);

		int nAreaid = lua_tointeger(L, 1);
		int nGameid = lua_tointeger(L, 2);
		int nAgid = lua_tointeger(L, 3);
		int nType = lua_tointeger(L, 4);
		int nNumid = lua_tointeger(L, 5);
		long long lCnt = lua_tointeger(L, 6);
		int nExpire = lua_tointeger(L, 7);
		lua_settop(L, 0);
		//OFSLOGD("aid=" << nAreaid << ",gid=" << nGameid << ",agid=" << nAgid << ",type=" << nType
		//	<< ",nid=" << nNumid << ",count=" << lCnt << ",expire=" << nExpire);

		char szKey[200];
		snprintf(szKey, sizeof(szKey), AREDIS_HD_RANKING_KEY, nGameid, nAgid, nType, nAreaid);
		if (!ZIncrby(szKey, nNumid, lCnt))
		{
			//OFSLOGE("redis zincrby failed,key=" << szKey << ",nid=" << nNumid);
			nFuncRet = TASK_REDIS_ERROR;
			break;
		}

		long long nTimeStamp = time(NULL);
		snprintf(szKey, sizeof(szKey), AREDIS_HD_TIMESTAMP_KEY, nGameid, nAgid, nType, nAreaid);
		if (!HSet(szKey, nNumid, nTimeStamp))
		{
			//OFSLOGE("redis hset failed,key=" << szKey << ",nid=" << nNumid);
			nFuncRet = TASK_REDIS_ERROR;
			break;
		}

	} while (false);

	lua_pushinteger(L, nFuncRet);
	return 1;
}

/**
 * 21、获取玩家虚拟数据(MemId为Uid,Key包含Agid)
 * 对应奖励服务接口getinfox
 */
int LuaZScoreVirDataByUid_WithAgid(lua_State *L)
{
	int nFuncRet = TASK_OK;
	long long lCnt = 0;
	int nTimeStamp = 0;
	long long llTimeStamp = 0;
	do
	{
		// check param cnt
		PARAM_CHECK(5, L);

		int nAreaid = lua_tointeger(L, 1);
		int nGameid = lua_tointeger(L, 2);
		int nAgid = lua_tointeger(L, 3);
		int nType = lua_tointeger(L, 4);
		int nNumid = lua_tointeger(L, 5);
		lua_settop(L, 0);
		//OFSLOGD("aid=" << nAreaid << ",gid=" << nGameid << ",agid=" << nAgid
		//	<< ",type=" << nType << ",nid=" << nNumid);

		char szKey[200];
		long long uid = (((long long)nAreaid << 32) | nNumid);
		snprintf(szKey, sizeof(szKey), XREDIS_HD_TIMESTAMP_KEY, nGameid, nAgid, nType);
		if (!HGet(szKey, uid, llTimeStamp))
		{
			nFuncRet = TASK_DATA_EXIST;
			break;
		}

		snprintf(szKey, sizeof(szKey), XREDIS_HD_RANKING_KEY, nGameid, nAgid, nType);
		if (!ZScore(szKey, uid, lCnt))
		{
			nFuncRet = TASK_DATA_EXIST;
			break;
		}
		//OFSLOGD("timestamp=" << nTimeStamp << ",count=" << lCnt);

	} while (false);
	nTimeStamp = (int)llTimeStamp;
	lua_pushinteger(L, nFuncRet);
	lua_pushnumber(L, (double)lCnt);
	lua_pushinteger(L, nTimeStamp);
	return 3;
}

/**
 * 23、设置玩家虚拟数据并更新时间(MemId为Uid,Key包含Agid)
 * 对应奖励服务接口setinfox
 */
int LuaZAddVirDataByUid_WithAgid(lua_State *L)
{
	int nFuncRet = TASK_OK;
	do
	{
		// check param cnt
		PARAM_CHECK(7, L);

		int nAreaid = lua_tointeger(L, 1);
		int nGameid = lua_tointeger(L, 2);
		int nAgid = lua_tointeger(L, 3);
		int nType = lua_tointeger(L, 4);
		int nNumid = lua_tointeger(L, 5);
		long long lCnt = (long long)lua_tonumber(L, 6);
		int nExpire = lua_tointeger(L, 7);
		lua_settop(L, 0);
		//OFSLOGD("aid=" << nAreaid << ",gid=" << nGameid << ",agid=" << nAgid << ",type=" << nType
		//	<< ",nid=" << nNumid << ",count=" << lCnt << ",expire=" << nExpire);

		char szKey[200];
		long long uid = (((long long)nAreaid << 32) | nNumid);
		snprintf(szKey, sizeof(szKey), XREDIS_HD_RANKING_KEY, nGameid, nAgid, nType);
		if (!ZAdd(szKey, uid, lCnt))
		{
			//OFSLOGE("redis zadd failed,key=" << szKey << ",nid=" << nNumid);
			nFuncRet = TASK_REDIS_ERROR;
			break;
		}

		long long nTimeStamp = time(NULL);
		snprintf(szKey, sizeof(szKey), XREDIS_HD_TIMESTAMP_KEY, nGameid, nAgid, nType);
		if (!HSet(szKey, uid, nTimeStamp))
		{
			//OFSLOGE("redis hset failed,key=" << szKey << ",nid=" << nNumid);
			nFuncRet = TASK_REDIS_ERROR;
			break;
		}

	} while (false);

	lua_pushinteger(L, nFuncRet);
	return 1;
}

/**
 * 22、增加玩家虚拟数据并更新时间(MemId为Uid,Key包含Agid)
 * 对应奖励服务接口addinfox
 */
int LuaZIncrVirDataByUid_WithAgid(lua_State *L)
{
	int nFuncRet = TASK_OK;
	do
	{
		// check param cnt
		PARAM_CHECK(7, L);

		int nAreaid = lua_tointeger(L, 1);
		int nGameid = lua_tointeger(L, 2);
		int nAgid = lua_tointeger(L, 3);
		int nType = lua_tointeger(L, 4);
		int nNumid = lua_tointeger(L, 5);
		long long lCnt = lua_tointeger(L, 6);
		int nExpire = lua_tointeger(L, 7);
		lua_settop(L, 0);
		//OFSLOGD("aid=" << nAreaid << ",gid=" << nGameid << ",agid=" << nAgid << ",type=" << nType
		//	<< ",nid=" << nNumid << ",count=" << lCnt << ",expire=" << nExpire);

		char szKey[200];
		long long uid = (((long long)nAreaid << 32) | nNumid);
		snprintf(szKey, sizeof(szKey), XREDIS_HD_RANKING_KEY, nGameid, nAgid, nType);
		if (!ZIncrby(szKey, uid, lCnt))
		{
			//OFSLOGE("redis zincrby failed,key=" << szKey << ",nid=" << nNumid);
			nFuncRet = TASK_REDIS_ERROR;
			break;
		}

		long long nTimeStamp = time(NULL);
		snprintf(szKey, sizeof(szKey), XREDIS_HD_TIMESTAMP_KEY, nGameid, nAgid, nType);
		if (!HSet(szKey, uid, nTimeStamp))
		{
			//OFSLOGE("redis hset failed,key=" << szKey << ",nid=" << nNumid);
			nFuncRet = TASK_REDIS_ERROR;
			break;
		}

	} while (false);

	lua_pushinteger(L, nFuncRet);
	return 1;
}

/**
 * 25、获取玩家虚拟数据(DB)
 */
int LuaGetVirDataByDB(lua_State *L)
{
	int nFuncRet = TASK_OK;
	long long lCnt = 0;
	int nTimeStamp = 0;
	do
	{
		// check param cnt
		PARAM_CHECK(5, L);

		int nAreaid = lua_tointeger(L, 1);
		int nGameid = lua_tointeger(L, 2);
		int nType = lua_tointeger(L, 3);
		int nNumid = lua_tointeger(L, 4);
		std::string strTable = "hdrecinfo";
		std::string strTemp = lua_tostring(L, 5);
		if (strTemp != "")
		{
			strTable = strTemp;
		}

		lua_settop(L, 0);

		nFuncRet = GetVirDataByDB(nAreaid, nGameid, nType, nNumid, lCnt, nTimeStamp);
		//OFSLOGD("ret=" << nFuncRet << ",areaid=" << nAreaid << ",numid=" << nNumid << ",type=" << nType
		//	<< ",gameid=" << nGameid << ",cnt=" << lCnt << ",time=" << nTimeStamp << ",table=" << strTable);

	} while (false);

	lua_pushinteger(L, nFuncRet);
	lua_pushnumber(L, (double)lCnt);
	lua_pushinteger(L, nTimeStamp);
	return 3;
}

/**
 * 26、增加玩家虚拟数据(DB)
 */
int LuaAddVirDataByDB(lua_State *L)
{
	int nFuncRet = TASK_OK;
	do
	{
		// check param cnt
		PARAM_CHECK(6, L);

		int nAreaid = lua_tointeger(L, 1);
		int nGameid = lua_tointeger(L, 2);
		int nType = lua_tointeger(L, 3);
		int nNumid = lua_tointeger(L, 4);
		long long lCnt = (long long)lua_tonumber(L, 5);
		std::string strTable = "hdrecinfo";
		std::string strTemp = lua_tostring(L, 6);
		if (strTemp != "")
		{
			strTable = strTemp;
		}
		bool bCover = false;    // 是否覆盖原数据

		lua_settop(L, 0);

		nFuncRet = UpdateVirDataByDB(nAreaid, nGameid, nType, nNumid, lCnt, bCover);
		//OFSLOGD("ret=" << nFuncRet << " areaid=" << nAreaid << ",numid=" << nNumid << ",type=" << nType
		//	<< ",gameid=" << nGameid << ",cnt=" << lCnt << ",table=" << strTable);

	} while (false);

	lua_pushinteger(L, nFuncRet);
	return 1;
}

/**
 * 27、设置玩家虚拟数据(DB)
 */
int LuaSetVirDataByDB(lua_State *L)
{
	int nFuncRet = TASK_OK;
	do
	{
		// check param cnt
		PARAM_CHECK(6, L);

		int nAreaid = lua_tointeger(L, 1);
		int nGameid = lua_tointeger(L, 2);
		int nType = lua_tointeger(L, 3);
		int nNumid = lua_tointeger(L, 4);
		long long lCnt = (long long)lua_tonumber(L, 5);
		std::string strTable = "hdrecinfo";
		std::string strTemp = lua_tostring(L, 6);
		if (strTemp != "")
		{
			strTable = strTemp;
		}
		bool bCover = true;    // 是否覆盖原数据

		lua_settop(L, 0);

		nFuncRet = UpdateVirDataByDB(nAreaid, nGameid, nType, nNumid, lCnt, bCover);
		//OFSLOGD("ret=" << nFuncRet << " areaid=" << nAreaid << ",numid=" << nNumid << ",type=" << nType
		//	<< ",gameid=" << nGameid << ",cnt=" << lCnt << ",table=" << strTable);

	} while (false);

	lua_pushinteger(L, nFuncRet);
	return 1;
}

/**
 * 28、给茶馆增加道具
 */
int LuaAddTeaProps(lua_State *L)
{
	int nFuncRet = TASK_OK;
	lua_pushinteger(L, nFuncRet);
	return 1;
}

/**
 * 29、向web请求获取活动配置
 */
int LuaReqGetWebTaskConfig(lua_State *L)
{
	lua_pushstring(L, respGetTaskConfig.strInfo.c_str());
	lua_pushinteger(L, respGetTaskConfig.nStatus);
	lua_pushstring(L, respGetTaskConfig.strData.c_str());
	return 3;
}

/**
 * 30、向web请求获取奖池配置
 */
int LuaReqGetWebPoolConfig(lua_State *L)
{
	lua_pushstring(L, respGetPoolConfig.strInfo.c_str());
	lua_pushinteger(L, respGetPoolConfig.nStatus);
	lua_pushstring(L, respGetPoolConfig.strData.c_str());
	return 3;
}

/**
 * 31、向web请求抽奖
 */
int LuaReqDrawWebAward(lua_State *L)
{
	lua_pushstring(L, respDrawAward.strInfo.c_str());
	lua_pushinteger(L, respDrawAward.nStatus);
	lua_pushstring(L, respDrawAward.strData.c_str());

	LOG("LuaReqDrawWebAward info = " << respDrawAward.strInfo);
	return 3;
}

/**
 * 32、向web请求发奖并同步
 */
int LuaReqSendWebAwardAndSync(lua_State *L)
{
	lua_pushstring(L, respSendAward.strInfo.c_str());
	lua_pushinteger(L, respSendAward.nStatus);
	lua_pushstring(L, respSendAward.strData.c_str());
	return 3;
}

/**
 * 33、增加茶馆道具
 */
int LuaSendOnePlayerOwnerCard(lua_State *L)
{
	int nFuncRet = TASK_OK;
	int nParamNum = lua_gettop(L);

	int nAreaId = lua_tointeger(L, 1);
	int nNumId = lua_tointeger(L, 2);
	int nTeaId = lua_tointeger(L, 3);
	int nPropId = lua_tointeger(L, 4);
	int nAwardCnt = lua_tointeger(L, 5);
	int nTaskId = lua_tointeger(L, 6);
	std::string strTaskName = "";
	if (nParamNum >= 7) strTaskName = lua_tostring(L, 7);

	//nFuncRet = GetProcessThread(L)->SendOnePlayerOwnerCard(nAreaId, nNumId, nTeaId, nPropId, nAwardCnt, nTaskId,strTaskName);

	lua_pushinteger(L, nFuncRet);
	return 1;
}

/**
 * 34、向web请求获取活动列表
 * Example: ReqGetWebTaskList
 */
int LuaReqGetWebTaskList(lua_State *L) {
	std::string strRet = "";
	std::string strInfo = "";
	int nStatus = 0;
	std::string strData = "";

	if (lua_gettop(L) >= 4) {
		int nAreaId = lua_tointeger(L, 1);
		int nNumId = lua_tointeger(L, 2);
		int nWid = lua_tointeger(L, 3);
		int nChannelId = lua_tointeger(L, 4);
		//HLOGI(L, "aid=" << nAreaId << ",nid=" << nNumId << ",wid=" << nWid << ",channel=" << nChannelId);
		//GetProcessThread(L)->ReqGetWebTaskList(nAreaId, nNumId, nWid, nChannelId, strInfo, nStatus, strData);
	}

	lua_pushstring(L, strInfo.c_str());
	lua_pushinteger(L, nStatus);
	lua_pushstring(L, strData.c_str());
	return 3;
}

/**
 * 35、批量获取道具(第一个table传时效道具ID，第二个table传数量道具ID)
 * Example: GetUserPropBatch
 */
int LuaGetUserPropBatch(lua_State *L) {
	int nFuncRet = TASK_OK;
	std::vector<int> vecTimePropId;
	std::vector<int> vecCountPropId;

	int nAreaId = lua_tointeger(L, 1);
	int nNumId = lua_tointeger(L, 2);
	size_t ullTimePropTableLen = lua_objlen(L, 3);
	for (size_t i = 0; i < ullTimePropTableLen; i++) {
		lua_rawgeti(L, 3, i + 1);
		int nPropId = lua_tointeger(L, -1);
		lua_pop(L, 1);
		vecTimePropId.push_back(nPropId);
	}

	size_t ullCountPropTableLen = lua_objlen(L, 4);
	for (size_t i = 0; i < ullCountPropTableLen; i++) {
		lua_rawgeti(L, 4, i + 1);
		int nPropId = lua_tointeger(L, -1);
		lua_pop(L, 1);
		vecCountPropId.push_back(nPropId);
	}

	lua_settop(L, 0);

	return 2;
}

/**
 * 36.日志记录
 */
int LuaRecordLog(lua_State *L) {
	std::string strRet = "";
	int nFuncRet = TASK_OK;

	if (lua_gettop(L) >= 8) {
		int nAreaId = lua_tointeger(L, 1);
		int nNumId = lua_tointeger(L, 2);
		int nTaskId = lua_tointeger(L, 3);
		int nTaskType = lua_tointeger(L, 4);
		int attr1 = lua_tointeger(L, 5);
		int attr2 = lua_tointeger(L, 6);
		int attr3 = lua_tointeger(L, 7);
		std::string data = lua_tostring(L, 8);
	}
	else {
		nFuncRet = TASK_PARAM_ERROR;
	}

	lua_pushinteger(L, nFuncRet);
	return 1;
}

/**
 * 37、获取玩家标签
 */
int LuaReqUserTag(lua_State *L) {
	std::string strRet = "";
	int nFuncRet = TASK_OK;

	if (lua_gettop(L) >= 2) {
		int nAreaId = lua_tointeger(L, 1);
		int nNumId = lua_tointeger(L, 2);
	}
	else {
		nFuncRet = TASK_PARAM_ERROR;
	}

	lua_settop(L, 0);
	lua_pushinteger(L, nFuncRet);

	lua_newtable(L);

	return 2;
}

/**
 * 38、获取玩家注册时间
 */
int LuaReqUserRegTime(lua_State *L) {
	std::string strRet = "";
	int nFuncRet = TASK_OK;

	if (lua_gettop(L) >= 2) {
		int nAreaId = lua_tointeger(L, 1);
		int nNumId = lua_tointeger(L, 2);

	}
	else {
		nFuncRet = TASK_PARAM_ERROR;
	}

	lua_settop(L, 0);
	lua_pushinteger(L, nFuncRet);
	lua_pushinteger(L, 0);
	return 2;
}

/**
 * 39、广播通知客户端奖励情况
 */
int LuaNotifyAward(lua_State *L) {
	int nFuncRet = TASK_OK;

	if (lua_gettop(L) >= 4) {
		int nAreaId = lua_tointeger(L, 1);
		int nNumId = lua_tointeger(L, 2);
		int nTaskId = lua_tointeger(L, 3);
		// 奖励内容
		std::string strData = lua_tostring(L, 4);
	}
	else {
		nFuncRet = TASK_PARAM_ERROR;
	}

	lua_pushinteger(L, nFuncRet);
	return 1;
}

/**
 * 40、向web请求抽奖
 * Example: ReqSendWebAwards
 */
int LuaReqSendWebAwards(lua_State *L) {
	std::string strRet = "";
	if (lua_gettop(L) >= 7) {
		int nAreaId = lua_tointeger(L, 1);
		int nNumId = lua_tointeger(L, 2);
		int nTaskId = lua_tointeger(L, 3);
		int nPoolId = lua_tointeger(L, 4);
		std::string strPropIds = lua_tostring(L, 5);    // 奖品id列表，多个时用,分隔。例如"12,34,56"
		int nSync = lua_tointeger(L, 6);
		std::string strStript = lua_tostring(L, 7);     // 脚本名称
	}

	lua_pushstring(L, strRet.c_str());
	return 1;
}

/**
 * 41、向web请求活动配置
 * Example: ReqGetWebTaskConfigEx(7102,30001050,1002);
 */
int LuaReqGetWebTaskConfigEx(lua_State *L) {
	std::string strRet = "";
	std::string strInfo = "";
	int nStatus = 0;
	std::string strData = "";

	if (lua_gettop(L) >= 3) {
		int nAreaId = lua_tointeger(L, 1);
		int nNumId = lua_tointeger(L, 2);
		int nTaskId = lua_tointeger(L, 3);
	}

	lua_pushstring(L, strInfo.c_str());
	lua_pushinteger(L, nStatus);
	lua_pushstring(L, strData.c_str());
	return 3;
}

/**
 * 42、请求web数据
 * Example: SendApiHubRequest("https://api.bianfeng.com/agent/fengxin/agent-shop-url",
 * "rid=1&search_type=2&search_value=3&shop_type=qrshop");
 */
int LuaSendApiHubRequest(lua_State *L) {
	int nFuncRet = TASK_OK;
	std::string strRet = "";

	do {
		PARAM_CHECK(2, L);

		std::string strUrl = lua_tostring(L, 1);
		std::string strParam = lua_tostring(L, 2);
		(void)nFuncRet;
	} while (false);

	lua_pushstring(L, strRet.c_str());
	return 1;
}

/**
 * 43、请求web数据-post方法
 * Example: PostApiHubRequest("https://api.bianfeng.com/agent/get-user-charge-order",
 * "{\"appids\":\"1143\",\"eDate\":\"2020-03-10\",\"itemCode\":\"\",\"itemQty\":0,\"numid\":\"59583949\",\"rid\":47,\"sDate\":\"2020-03-09\",\"wid\":1045}")
 */
int LuaPostApiHubRequest(lua_State *L) {
	int nFuncRet = TASK_OK;
	std::string strRet = "";

	do {
		PARAM_CHECK(2, L);

		std::string strUrl = lua_tostring(L, 1);
		std::string strParam = lua_tostring(L, 2);
		(void)nFuncRet;
	} while (false);

	lua_pushstring(L, strRet.c_str());
	return 1;
}

/**
 * 44、获取玩家虚拟数据和排名(MemId为Numid,Key包含Agid)
 * 对应奖励服务接口getranka
 */
int LuaZRankVirDataByNid_WithAgid(lua_State *L) {
	int nFuncRet = TASK_OK;
	long long lCnt = 0;
	int nTimeStamp = 0;
	int nTotal = 0;
	int nRank = 0;
	do {
		// check param cnt
		PARAM_CHECK(5, L);

		int nAreaid = lua_tointeger(L, 1);
		int nGameid = lua_tointeger(L, 2);
		int nAgid = lua_tointeger(L, 3);
		int nType = lua_tointeger(L, 4);
		int nNumid = lua_tointeger(L, 5);
		lua_settop(L, 0);
	} while (false);

	lua_pushinteger(L, nFuncRet);
	lua_pushnumber(L, lCnt);
	lua_pushinteger(L, nTimeStamp);
	lua_pushinteger(L, nTotal);
	lua_pushinteger(L, nRank);
	return 5;
}


// 提供给Lua调用的函数
luaL_Reg m_afLuaFunc[] =
{
		{ "Log", LuaLog },
		{ "IncrUserTaskData", LuaIncrUserTaskData },
		{ "GetUserTaskData", LuaGetUserTaskData },
		{ "SendUserAward", LuaSendUserAward },
		{ "NotifyTaskPercent", LuaNotifyTaskPercent },
		{ "PushUserListData", LuaPushUserListData },
		{ "GetUserListData", LuaGetUserListData },
		{ "ClearUserTaskData", LuaClearUserTaskData },
		{ "SetStringTaskData", LuaSetStringTaskData },
		{ "GetStringTaskData", LuaGetStringTaskData },
		{ "ZIncrUserTaskData", LuaZIncrUserTaskData },
		{ "ZScoreUserTaskData", LuaZScoreUserTaskData },
		{ "GetUserPropCount", LuaGetUserPropCount },
		{ "RecordTaskUser", LuaRecordTaskUser },

		{"GetVirDataByUid", LuaZScoreVirDataByUid},
		{"AddVirDataByUid", LuaZIncrVirDataByUid},
		{"SetVirDataByUid", LuaZAddVirDataByUid},
		{"GetVirDataByNid_Agid", LuaZScoreVirDataByNid_WithAgid},
		{"SetVirDataByNid_Agid", LuaZAddVirDataByNid_WithAgid},
		{"AddVirDataByNid_Agid", LuaZIncrVirDataByNid_WithAgid},
		{"GetVirDataByUid_Agid", LuaZScoreVirDataByUid_WithAgid},
		{"SetVirDataByUid_Agid", LuaZAddVirDataByUid_WithAgid},
		{"AddVirDataByUid_Agid", LuaZIncrVirDataByUid_WithAgid},
		{"GetRankDataByNid_Agid", LuaZRankVirDataByNid_WithAgid},
		{"GetVirDataByDB", LuaGetVirDataByDB},
		{"AddVirDataByDB", LuaAddVirDataByDB},
		{"SetVirDataByDB", LuaSetVirDataByDB},

		{"AddTeaProps", LuaAddTeaProps}, 

		{"ReqGetWebTaskConfig", LuaReqGetWebTaskConfig},
		{"ReqGetWebTaskConfigEx", LuaReqGetWebTaskConfigEx},  // 活动配置信息
		{"ReqGetWebPoolConfig", LuaReqGetWebPoolConfig},
		{"ReqDrawWebAward", LuaReqDrawWebAward},
		{"ReqSendWebAwardAndSync", LuaReqSendWebAwardAndSync},
		{"SendOnePlayerOwnerCard", LuaSendOnePlayerOwnerCard },

		{"ReqGetWebTaskList", LuaReqGetWebTaskList},
		{"GetUserPropBatch", LuaGetUserPropBatch},
		{"RecordLog", LuaRecordLog},
		{"ReqUserTag", LuaReqUserTag},
		{"ReqUserRegTime", LuaReqUserRegTime },
		{"NotifyAward", LuaNotifyAward },

		{"ReqSendWebAwards", LuaReqSendWebAwards},

		{"SendApiHubRequest", LuaSendApiHubRequest},
		{"PostApiHubRequest", LuaPostApiHubRequest},
};

bool CheckFunctionSig(const char* param)
{
	int type = 0;
	int nCnt[2];
	memset(nCnt, 0, sizeof(nCnt));

	char *sig = const_cast<char *>(param);

	while (*sig)
	{
		if ((*sig == 'd') || (*sig == 'i') || (*sig == 's'))
		{
			nCnt[type]++;
		}
		else if (*sig == '>')
		{
			type++;
		}
		else
		{
			return false;
		}

		if (type >= 2)
		{
			break;
		}
		sig++;
	}

	if ((type >= 2) || (nCnt[0] + 1 >= LUA_MINSTACK) || (nCnt[1] + 1 >= LUA_MINSTACK))
	{
		return false;
	}

	return true;
}

extern "C" __declspec(dllexport) bool LoadLuaFile(const char *pcFileName)
{
	bool bRet = true;
	if (0 != luaL_dofile(m_pstLuaState, pcFileName))
	{
		LOG("load file " << pcFileName << " fail");
		lua_pop(m_pstLuaState, 1);
		bRet = false;
	}
	else
	{
		LOG("load file " << pcFileName << " success");
	}
	return bRet;
}

bool CallLuaFunc(const char *pcFuncName, const char* param, ...)
{
	va_list vl;
	int narg, nres, nresmem;

	if (!CheckFunctionSig(param))
	{
		LOG("wrong param");
		return false;
	}

	lua_getglobal(m_pstLuaState, pcFuncName);
	if (lua_type(m_pstLuaState, -1) != LUA_TFUNCTION)
	{
		LOG("no function");
		lua_pop(m_pstLuaState, 1);
		return false;
	}

	char *sig = const_cast<char *>(param);
	va_start(vl, param);

	narg = 0;
	while (*sig)
	{
		switch (*sig++)
		{
		case 'd':
			lua_pushnumber(m_pstLuaState, va_arg(vl, double));
			narg++;
			break;
		case 'i':
			lua_pushinteger(m_pstLuaState, va_arg(vl, int));
			narg++;
			break;
		case 's':
			lua_pushstring(m_pstLuaState, va_arg(vl, char*));
			narg++;
			break;
		case '>':
			goto callcontinue;
			break;
		default:
			break;
		}
		luaL_checkstack(m_pstLuaState, 1, "too manyarguments");
	}

callcontinue:

	nres = static_cast<int>(strlen(sig));
	if (lua_pcall(m_pstLuaState, narg, nres, 0) != 0)
	{
		LOG("pcall " << pcFuncName << ": " << lua_tostring(m_pstLuaState, -1));
		va_end(vl);

		lua_pop(m_pstLuaState, 1);
		return false;
	}

	nresmem = nres;
	nres = -nres;
	while (*sig)
	{
		switch (*sig++)
		{
		case 'd':
			if (lua_isnumber(m_pstLuaState, nres))
			{
				*va_arg(vl, double*) = lua_tonumber(m_pstLuaState, nres);
			}
			break;
		case 'i':
			if (lua_isnumber(m_pstLuaState, nres))
			{
				*va_arg(vl, int*) = static_cast<int>(lua_tointeger(m_pstLuaState, nres));
			}
			break;
		case 's':
			if (lua_isstring(m_pstLuaState, nres))
			{
				sprintf(va_arg(vl, char *), "%s", lua_tostring(m_pstLuaState, nres));
			}
			break;
		default:
			break;
		}
		nres++;
	}
	va_end(vl);

	lua_pop(m_pstLuaState, nresmem);

	return true;
}

extern "C" __declspec(dllexport) void RunTask(const char *acData, int nAreaId, int nNumId, int nLobbyId)
{
	CallLuaFunc("RunTask", "siii", acData, nAreaId, nNumId, nLobbyId);
}

extern "C" __declspec(dllexport) void GetPercent(int nAreaId, int nNumId, int nLobbyId, int nTaskId)
{
	CallLuaFunc("GetTaskPercent", "iiii", nAreaId, nNumId, nLobbyId, nTaskId);
}

extern "C" __declspec(dllexport) void GetAward(int nAreaId, int nNumId, int nLobbyId, int nTaskId)
{
	CallLuaFunc("GetTaskAward", "iiii", nAreaId, nNumId, nLobbyId, nTaskId);
}

extern "C" __declspec(dllexport) void RunProtocol(int nAreaId, int nNumId, int nLobbyId, int nProtoId, const char *pcData)
{
	CallLuaFunc("DealTaskProtocol", "iiiis", nAreaId, nNumId, nLobbyId, nProtoId, pcData);
}

extern "C" __declspec(dllexport) void RunInit(char *acData)
{
	CallLuaFunc("init", ">s", acData);
}

extern "C" __declspec(dllexport) void SetWebRespData(const char *pcTaskConfigInfo, int nTaskConfigStatus, const char *pcTaskConfigData,
													 const char *pcPoolConfigInfo, int nPoolConfigStatus, const char *pcPoolConfigData,
													 const char *pcDrawInfo, int nDrawStatus, const char *pcDrawData,
													 const char *pcSendInfo, int nSendStatus, const char *pcSendData)
{
	respGetTaskConfig.strInfo = pcTaskConfigInfo;
	respGetTaskConfig.nStatus = nTaskConfigStatus;
	respGetTaskConfig.strData = pcTaskConfigData;

	respGetPoolConfig.strInfo = pcPoolConfigInfo;
	respGetPoolConfig.nStatus = nPoolConfigStatus;
	respGetPoolConfig.strData = pcPoolConfigData;

	respDrawAward.strInfo = pcDrawInfo;
	respDrawAward.nStatus = nDrawStatus;
	respDrawAward.strData = pcDrawData;

	respSendAward.strInfo = pcSendInfo;
	respSendAward.nStatus = nSendStatus;
	respSendAward.strData = pcSendData;
}

extern "C" __declspec(dllexport) bool LuaInit(const char *pcBaseDir, char *acWebTaskId)
{
	m_pstLuaState = luaL_newstate();
	if (NULL == m_pstLuaState)
	{
		LOG("luaL_newstate fail");
		return false;
	}
	luaL_openlibs(m_pstLuaState);

	// 注册函数给lua调用
	luaL_register(m_pstLuaState, "Task", m_afLuaFunc);


	{
		const char *errh_func = "local dbg = debug\n"
			"function __redis__err__handler(err)\n"
			"  local i = dbg.getinfo(2,'nSl')\n"
			"  if i and i.what == 'C' then\n"
			"	 i = dbg.getinfo(3,'nSl')\n"
			"  end\n"
			"  if i then\n"
			"	 return i.source .. ':' .. i.currentline .. ': ' .. err\n"
			"  else\n"
			"	 return err\n"
			"  end\n"
			"end\n";
		luaL_loadbuffer(m_pstLuaState, errh_func, strlen(errh_func), "@err_handler_def");
		lua_pcall(m_pstLuaState, 0, 0, 0);
	}

	{
		/* strict.lua from: http://metalua.luaforge.net/src/lib/strict.lua.html.
		 * Modified to be adapted to Redis. */
		const char* code = "local dbg=debug\n"
			"local mt = {}\n"
			"setmetatable(_G, mt)\n"
			"mt.__newindex = function (t, n, v)\n"
			"  if dbg.getinfo(2) then\n"
			"	local w = dbg.getinfo(2, \"S\").what\n"
			"	if w ~= \"main\" and w ~= \"C\" then\n"
			"	  error(\"Script attempted to create global variable '\"..tostring(n)..\"'\", 2)\n"
			"	end\n"
			"  end\n"
			"  rawset(t, n, v)\n"
			"end\n"
			"mt.__index = function (t, n)\n"
			"if dbg.getinfo(2) and dbg.getinfo(2, \"S\").what ~= \"C\" then\n"
			"	error(\"Script attempted to access nonexistent global variable '\"..tostring(n)..\"'\", 2)\n"
			"end\n"
			"  return rawget(t, n)\n"
			"end\n";

		luaL_loadbuffer(m_pstLuaState, code, strlen(code), "@enable_strict_lua");
		lua_pcall(m_pstLuaState, 0, 0, 0);
	}

	{
		char setpath[256];
		snprintf(setpath, sizeof(setpath),
			"package.path='%sluascript/?.lua;' .. package.path;"
			"package.cpath='%sluascript/?.so;' .. package.cpath;",pcBaseDir, pcBaseDir);
		luaL_dostring(m_pstLuaState, setpath);
	}

	char acFullName[256] = { 0 };
	snprintf(acFullName, sizeof(acFullName), "%s%s", pcBaseDir, "luascript/TaskInterface.lua");
	
	if (false == LoadLuaFile(acFullName))
	{
		LOG("load file " << acFullName << " error");
		return false;
	}

	snprintf(acFullName, sizeof(acFullName), "%s%s", pcBaseDir, "template/ParamModify.lua");
	if (false == LoadLuaFile(acFullName))
	{
		LOG("load file " << acFullName << " error");
	}

	if (!CallLuaFunc("init", ">s", acWebTaskId))
	{
		LOG("lua init fail");
		return false;
	}

	return true;
}