using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using LuaInterface;
using System.Net;
using System.Collections;

namespace CopyData
{
    class CCHttp
    {
        //执行一次http请求,异步
        public async static void httpRequestAsync(string url = null, int method = 0, LuaTable headTable = null, string urlBody = null, string postBody = null, string cookies = null, LuaFunction taskEndAction = null)
        {
            try
            {
                var ret = await CCHttp.startHttpRequestAsync(url, method, headTable, urlBody, postBody, cookies);
                if (taskEndAction != null)
                {
                    taskEndAction.Call(ret);
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("httpRequestAsync error: " + e.Message);
            }
        }

        //执行一次http请求,同步
        public static string httpRequest(string url = null, int method = 0, LuaTable headTable = null, string urlBody = null, string postBody = null, string cookies = null)
        {
            try
            {
                if (string.IsNullOrEmpty(url))
                {
                    return string.Empty;
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

                    if (!string.IsNullOrEmpty(urlBody)){
                        http.SetUrlBody(urlBody);
                    }

                    if (!string.IsNullOrEmpty(cookies)){
                        http.SetCookieHeader(cookies);
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
                            http.SetPostBody(postBody);
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
            return string.Empty;
        }

        private static Task<string> startHttpRequestAsync(string url = null, int method = 0, LuaTable headTable = null, string urlBody = null, string postBody = null, string cookies = null)
        {
            try
            {
                if (string.IsNullOrEmpty(url))
                {
                    return new Task<string>(() => { return string.Empty; });
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

                    if (!string.IsNullOrEmpty(cookies)) {
                        http.SetCookieHeader(cookies);
                    }

                    if (!string.IsNullOrEmpty(urlBody))
                    {
                        http.SetUrlBody(urlBody);
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
                            http.SetPostBody(postBody);
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
            return new Task<string>(() => { return string.Empty; });
        }
    }
}
