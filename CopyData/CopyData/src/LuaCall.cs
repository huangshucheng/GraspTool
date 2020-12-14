using System;
using System.Collections.Generic;
using System.Linq;
using Newtonsoft.Json.Linq;
using System.Threading.Tasks;
using System.Collections;
using System.ComponentModel;
using System.Text;
using LuaInterface;

//lua 调用的接口
namespace CopyData
{
    class LuaCall
    {
        private static BackWork _bgWork = new BackWork();

        //public static void testttt() {
        //    _bgWork._dataChangedEvent += new DataDelegateHander(onDataHeaderFindToken);
        //}

        //public static void onDataHeaderFindToken(string str) {
        //}

        //获取当前文件所在位置目录
        public static string getCurDir()
        {
            return Environment.CurrentDirectory;
        }

        //获取桌面位置目录
        public static string getDeskTopDir() {
            return Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory);
        }

        //执行一次http请求,异步
        //url: "www.baidu.com"
        //method: Method {GET,POST,PUT,DELETE}: 0 ,1 ,2 ,3
        //headTable:{AAA = "" , bbb = "" }
        //urlBody: "aaa=1&bbb=123"
        //postBody: "anything"
        //cookies: "a=avlue;c=cvalue"
        //taskEndAction: lua function
        public static void httpRequestAsync(string url = null, int method = 0, LuaTable headTable = null, string urlBody = null, string postBody = null, string cookies = null, LuaFunction taskEndAction = null)
        {
            CCHttp.httpRequestAsync(url, method, headTable, urlBody, postBody, cookies, taskEndAction);
        }
        
        //执行一次http请求,同步
        public static string httpRequest(string url = null, int method = 0, LuaTable headTable = null, string urlBody = null, string postBody = null, string cookies = null)
        {
            return CCHttp.httpRequest(url, method, headTable, urlBody, postBody, cookies);
            //HTTP_REQ_PARAM param = new HTTP_REQ_PARAM();
            //param.url = url;
            //param.method = method;
            //param.headTable = headTable;
            //param.urlBody = urlBody;
            //param.postBody = postBody;
            //param.cookies = cookies;
            //_bgWork.setLuaCallFunc(taskEndAction);
            //_bgWork.startReqHttp(param);
        }

    }
}