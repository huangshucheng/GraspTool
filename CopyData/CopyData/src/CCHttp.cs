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
        public async static void HttpRequestAsync(string url = null, int method = 0, LuaTable headTable = null, string urlBody = null, string postBody = null, string cookies = null, string proxyAddress = null, LuaFunction luaCallFunc = null)
        {
            try {
                string ret = await CCHttp.StartHttpRequestAsync(url, method, headTable, urlBody, postBody, cookies, proxyAddress);
                if (luaCallFunc != null){
                    luaCallFunc.Call(ret);
                }
            }
            catch (Exception ex) {
                if (luaCallFunc != null){
                    luaCallFunc.Call(ex.Message);
                }
                Console.WriteLine("HttpRequestAsync error : " + ex.Message);
            }
        }

        //执行一次http请求,同步
        public static string HttpRequest(string url = null, int method = 0, LuaTable headTable = null, string urlBody = null, string postBody = null, string cookies = null, string proxyAddress = null)
        {
            if (string.IsNullOrEmpty(url)){
                return string.Empty;
            }
            try{
                EasyHttp http = EasyHttp.With(url);
                if (http != null)
                {
                    if (headTable != null)
                    {
                        if (headTable.Keys.Count > 0)
                        {
                            foreach (DictionaryEntry v in headTable)
                            {
                                http.AddHeaderCustome(v.Key.ToString(), v.Value.ToString());
                            }
                        }
                    }

                    if (!string.IsNullOrEmpty(urlBody)){
                        http.SetUrlBody(urlBody);
                    }

                    if (!string.IsNullOrEmpty(cookies)){
                        http.SetCookieHeader(cookies);
                    }

                    http.SetProxy(proxyAddress);

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

        public async static Task<string> StartHttpRequestAsync(string url = null, int method = 0, LuaTable headTable = null, string urlBody = null, string postBody = null, string cookies = null, string proxyAddress = null){
            if (string.IsNullOrEmpty(url)){
                return string.Empty;
            }
            EasyHttp http = EasyHttp.With(url);
            if (http == null) {
                return string.Empty;
            }

            if (headTable != null){
                if (headTable.Keys.Count > 0){
                    foreach (DictionaryEntry v in headTable){
                        http.AddHeaderCustome(v.Key.ToString(), v.Value.ToString());
                    }
                }
            }

            if (!string.IsNullOrEmpty(cookies)) {
                http.SetCookieHeader(cookies);
            }

            if (!string.IsNullOrEmpty(urlBody)){
                http.SetUrlBody(urlBody);
            }

            http.SetProxy(proxyAddress);

            string ret = null;
            if (method == (int)EasyHttp.Method.GET){
                ret = await http.GetForStringAsyc();
            }
            else{
                if (!string.IsNullOrEmpty(postBody)){
                    http.SetPostBody(postBody);
                }
                ret = await http.PostForStringAsyc();
            }
            return ret;
        }
    }
}
