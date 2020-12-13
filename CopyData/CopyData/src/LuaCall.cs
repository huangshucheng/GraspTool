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
        public static void httpRequestAsync(string url = null, int method = 0, LuaTable headTable = null, string urlBody = null, string postBody = null, LuaFunction taskEndAction = null)
        {
            CCHttp.httpRequestAsync(url, method, headTable, urlBody, postBody, taskEndAction);
        }
        
        //执行一次http请求,同步
        public static string httpRequest(string url = null, int method = 0, LuaTable headTable = null, string urlBody = null, string postBody = null)
        {
            return CCHttp.httpRequest(url, method, headTable, urlBody, postBody);
        }

    }
}