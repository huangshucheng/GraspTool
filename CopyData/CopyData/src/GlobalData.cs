using System.Collections.Generic;

//全局数据配置
namespace CopyData
{
    class GlobalData
    {
        //////////////////////// 宏定义，类名直接访问
        public static string FIND_STRING_HOST = "hbz.qrmkt.cn"; //域名，针对不同活动，域名需修改
        public static string[] DATA_TO_FIND_ARRAY = { "token" };//http请求头中，查找指定串,只要符合其中一条，就会找出来
        public static string REQ_HEAD_STRING = "[reqHeader<" + GlobalData.FIND_STRING_HOST; //请求头
        public static string REQ_BODY_STRING = "[reqBody<" + GlobalData.FIND_STRING_HOST;   //请求体
        public static string RES_HEAD_STRING = "[resHeader<" + GlobalData.FIND_STRING_HOST; //返回头
        public static string RES_BODY_STRING = "[resBody<" + GlobalData.FIND_STRING_HOST;  //返回体

        ////////////////////////
        //请求参数,需要用对象访问
        public Dictionary<string, string> _reqHeaderDic = new Dictionary<string, string>();//请求头

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

            var sign_list = GlobalData.FIND_STRING_HOST + "/hbact/hyr/sign/list";//签到列表
            var sign_do = GlobalData.FIND_STRING_HOST + "/hbact/hyr/sign/doit";//签到
            var study_start = GlobalData.FIND_STRING_HOST + "/hbact/school/study/start";//开始学习
            var study_end = GlobalData.FIND_STRING_HOST + "/hbact/school/study/end";//结束学习
            var card_list = GlobalData.FIND_STRING_HOST + "/hbact/commucard/mycard"; //查卡
            var share_code = GlobalData.FIND_STRING_HOST + "/hbact/hyr/home/hasAwd"; //分享码
            var study_page = GlobalData.FIND_STRING_HOST + "/syx/wx/jsapi"; //学习页面
            var room_actcode = GlobalData.FIND_STRING_HOST + "/hbact/hyr/home/queryActCode";  //开启考场 POST  {"code":"200","msg":null,"data":{"actCode":"ACT-8K38GWT8552W","id":245}}
            var get_chance = GlobalData.FIND_STRING_HOST + "/hbact/exam/chance"; //请求考试机会，answerNum考试机会 GET  {"code":"200","msg":null,"data":{"exchangeNum":10,"answerNum":1}}
            var exam_check = GlobalData.FIND_STRING_HOST + "/hbact/exam/check"; //考试检测 GET  {"code":"200","msg":null,"data":null}
            var random_room = GlobalData.FIND_STRING_HOST + "/hbact/exam/random"; //请求题目 GET 
            var put_answer = GlobalData.FIND_STRING_HOST + "/hbact/exam/finish?shareCode=d7fc08d9e6754043ad8bfaa0ae597b63"; //考试提交答案 Post

            //任务配置初始化
            //前置任务
            //_taskConfiList.Add(new TaskObj(sign_list, EasyHttp.Method.POST, "签到列表").addBody("hcc=postbody"));
            //_taskConfiList.Add(new TaskObj(sign_do, EasyHttp.Method.POST, "签到").setReqCount(10));
            //_taskConfiList.Add(new TaskObj(study_start, EasyHttp.Method.POST, "开始学习"));
            //_taskConfiList.Add(new TaskObj(study_end, EasyHttp.Method.POST, "结束学习"));
            //_taskConfiList.Add(new TaskObj(card_list, EasyHttp.Method.POST, "我的卡片").addBody("from=1"));
            //_taskConfiList.Add(new TaskObj(share_code, EasyHttp.Method.GET, "分享码"));
            //_taskConfiList.Add(new TaskObj(study_page, EasyHttp.Method.POST, "请求学习页面").addBody("url=https%3A%2F%2Fhbz.qrmkt.cn%2Fyx%2Fviews%2Factivity%2FmemberDaySchool.html%3Ft%3D1606640950645"));
            //_taskConfiList.Add(new TaskObj(room_actcode, EasyHttp.Method.POST, "激活考场").addBody("actType=6"));
            //_taskConfiList.Add(new TaskObj(get_chance, EasyHttp.Method.GET, "考试机会"));
            //_taskConfiList.Add(new TaskObj(exam_check, EasyHttp.Method.GET, "考试检测"));
            //_taskConfiList.Add(new TaskObj(random_room, EasyHttp.Method.GET, "请求题目"));
            //_taskConfiList.Add(new TaskObj(put_answer, EasyHttp.Method.POST, "提交答案"));

            //后置任务
            //_taskConfiListAfter.Add(new TaskObj(study_start, EasyHttp.Method.POST, "开始学习").addPreTaskName("签到"));
            //_taskConfiListAfter.Add(new TaskObj(study_end, EasyHttp.Method.POST, "结束学习").addPreTaskName("开始学习"));
            //_taskConfiListAfter.Add(new TaskObj(get_chance, EasyHttp.Method.GET, "考试机会").addPreTaskName("结束学习"));
            //_taskConfiListAfter.Add(new TaskObj(exam_check, EasyHttp.Method.GET, "考试检测").addPreTaskName("考试机会"));
            //_taskConfiListAfter.Add(new TaskObj(room_actcode, EasyHttp.Method.POST, "激活考场").addPreTaskName("考试检测").addBody("actType=6"));
            //_taskConfiListAfter.Add(new TaskObj(random_room, EasyHttp.Method.GET, "请求题目").addPreTaskName("激活考场"));
        }
    }
}
