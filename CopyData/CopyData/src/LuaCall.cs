using System;
using System.Collections.Generic;
using System.Linq;
using Newtonsoft.Json.Linq;
using System.Threading.Tasks;
using LuaInterface;
using System.Collections;
using System.ComponentModel;

//lua 调用的接口
namespace CopyData
{
    class LuaCall
    {
        public static string _stringCache = "";

        //打印log
        public static void LogLua(string logStr) {
            if (!string.IsNullOrEmpty(logStr)) {
                Console.WriteLine(logStr);
            }
        }

        //获取当前文件所在位置目录
        public static string getCurDir()
        {
            return Environment.CurrentDirectory;
        }

        //获取桌面位置目录
        public static string getDeskTopDir() {
            return Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory);
        }

        //获取Fidder传过来的string
        public static string getFidderString() {
            return LuaCall._stringCache;
        }

        //设置缓存
        public static void setFidderString(string str) {
            LuaCall._stringCache = str;
        }

        //执行一次http请求,异步
        //headTable:{a="",b=""}
        //Method { GET=0, POST, PUT, DELETE }
        private static Task<string> startHttpRequestAsync(string url = null, int method = 0, LuaTable headTable = null, string urlBody = null, string postBody = null)
        {
            try
            {
                if (string.IsNullOrEmpty(url)) {
                    return null;
                }

                EasyHttp http = EasyHttp.With(url);
                if (http != null)
                {
                    if (headTable != null)
                    {
                        if (headTable.Keys.Count > 0)
                        {
                            foreach (DictionaryEntry v in headTable)
                            {
                                http.HeaderCustome(v.Key.ToString(), v.Value.ToString());
                            }
                        }
                    }

                    if (!string.IsNullOrEmpty(urlBody)) {
                        http.setUrlBody(urlBody);
                    }

                    Task<string> ret = null;
                    if (method == (int)EasyHttp.Method.GET)
                    {
                        ret = http.GetForStringAsyc();
                    }
                    else
                    {
                        if (!string.IsNullOrEmpty(postBody))
                        {
                            http.setPostBody(postBody);
                        }
                        ret = http.PostForStringAsyc();
                    }
                    return ret;
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("doOneTaskReq error:{0}" + e.Message);
            }
            return null;
        }

        //执行一次http请求,异步
        public async static void httpRequestAsync(string url = null, int method = 0, LuaTable headTable = null, string urlBody = null, string postBody = null, LuaFunction taskEndAction = null)
        {
            var ret = await LuaCall.startHttpRequestAsync(url, method, headTable, urlBody, postBody);
            if (taskEndAction != null)
            {
                taskEndAction.Call(ret);
            }
        }

        //执行一次http请求,同步
        public static string httpRequest(string url = null, int method = 0, LuaTable headTable = null, string urlBody = null, string postBody = null)
        {
            try
            {
                if (string.IsNullOrEmpty(url))
                {
                    return null;
                }

                EasyHttp http = EasyHttp.With(url);
                if (http != null)
                {
                    if (headTable != null)
                    {
                        if (headTable.Keys.Count > 0)
                        {
                            foreach (DictionaryEntry v in headTable)
                            {
                                http.HeaderCustome(v.Key.ToString(), v.Value.ToString());
                            }
                        }
                    }

                    if (!string.IsNullOrEmpty(urlBody))
                    {
                        http.setUrlBody(urlBody);
                    }

                    string ret = null;
                    if (method == (int)EasyHttp.Method.GET)
                    {
                        ret = http.GetForString();
                    }
                    else
                    {
                        if (!string.IsNullOrEmpty(postBody))
                        {
                            http.setPostBody(postBody);
                        }
                        ret = http.PostForString();
                    }
                    return ret;
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("doOneTaskReq error:{0}" + e.Message);
            }
            return null;
        }

    }
}
