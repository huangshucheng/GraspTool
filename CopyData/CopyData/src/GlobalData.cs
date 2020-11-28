using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

//全局数据配置
namespace CopyData
{
    class GlobalData
    {
        //////////////////////// 宏定义，类名直接访问
        public static string FIND_STRING_HOST = "hbz.qrmkt.cn"; //域名，针对不同活动，域名需修改
        public static string[] DATA_TO_FIND_ARRAY = { "token" };//http请求头中，查找指定串,只要符合其中一条，就会找出来
        //public static string[] DATA_TO_FIND_ARRAY = { "token", "cookie" };
        //public static string[] DATA_TO_FIND_ARRAY = { "token", "Content-Type", "Cookie" };//http请求头中，查找指定串

        public static string REQ_HEAD_STRING = "[reqHeader<" + GlobalData.FIND_STRING_HOST + ">]"; //请求头
        public static string REQ_BODY_STRING = "[reqBody<" + GlobalData.FIND_STRING_HOST + ">]";   //请求体
        public static string RES_HEAD_STRING = "[resHeader<" + GlobalData.FIND_STRING_HOST + ">]"; //返回头
        public static string RES_BODY_STRING = "[resBody<" + GlobalData.FIND_STRING_HOST + ">]";  //返回体

        ////////////////////////
        //请求参数,需要用对象访问
        public Dictionary<string, string> _reqHeaderDic = new Dictionary<string, string>();//请求头

        //任务列表
        public List<TaskConfig> _taskConfiList = new List<TaskConfig>();

        public GlobalData()
        {
            initData();            
        }

        public void initData(){
            //请求头初始化
            _reqHeaderDic.Add("Accept", "application/json,text/javascript,text/html,text/plain,application/xhtml+xml,application/xml, */*; q=0.01");
            _reqHeaderDic.Add("Proxy-Connection", "keep-alive");
            _reqHeaderDic.Add("Connection", "keep-alive");
            _reqHeaderDic.Add("X-Requested-With", "XMLHttpRequest");
            _reqHeaderDic.Add("User-Agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 12_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/7.0.14(0x17000e2e) NetType/WIFI Language/zh_CN");
            _reqHeaderDic.Add("Accept-Encoding", "br, gzip, deflate");
            _reqHeaderDic.Add("Accept-Language", "zh-cn");
            _reqHeaderDic.Add("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");      //发送的数据格式
            //_reqHeaderDic.Add("Cookie", "");

            //任务配置初始化
            //_taskConfiList.Add(new TaskConfig(GlobalData.FIND_STRING_HOST + "/hbact/hyr/sign/list", EasyHttp.Method.POST, null));
            _taskConfiList.Add(new TaskConfig(GlobalData.FIND_STRING_HOST + "/hbact/hyr/sign/doit", EasyHttp.Method.POST, null));
            //_taskConfiList.Add(new TaskConfig(GlobalData.FIND_STRING_HOST + "/hbact/school/study/start", EasyHttp.Method.POST, null));
            //_taskConfiList.Add(new TaskConfig(GlobalData.FIND_STRING_HOST + "/hbact/school/study/end", EasyHttp.Method.POST, null));
        }

        public Dictionary<string, string> getHeadDic(){
            return _reqHeaderDic;
        }

        public List<TaskConfig> getTaskConfig() {
            return _taskConfiList;
        }
    }
}
