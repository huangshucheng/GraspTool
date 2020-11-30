using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.ComponentModel;

//执行请求任务
namespace CopyData
{
    class StartTask
    {
        BackgroundWorker _bgWorker = null; //工作线程
        public event DataDelegateHander _dataChangedEvent;//声明一个事件，有返回数据，就派发出去
        public GlobalData _globalData = null;
        private bool isStopTask = false;

        public StartTask() {
            _globalData = new GlobalData();
            InitBackGroundWorker();
        }

        //初始化工作线程
        private void InitBackGroundWorker()
        {
            _bgWorker = new BackgroundWorker();
            _bgWorker.WorkerReportsProgress = true;
            _bgWorker.WorkerSupportsCancellation = true;
            _bgWorker.DoWork += new DoWorkEventHandler(bgWorkerDoReq); //开始工作
            _bgWorker.ProgressChanged += new ProgressChangedEventHandler(bgWorkProgressChanged);  //更新UI
            _bgWorker.RunWorkerCompleted += new RunWorkerCompletedEventHandler(bgWorkRunWorkerCompleted); //更新UI
        }

        //开始工作，回调
        private void bgWorkerDoReq(object sender, DoWorkEventArgs e)
        {
            var param = e.Argument;
            doTaskReq(param);
        }

        //工作进度，回调
        private void bgWorkProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            string info = (string)e.UserState;
            if (string.IsNullOrEmpty(info)){
                info = "返回空";
            }
            var tmpStr = "[" + DateTime.Now.ToLongTimeString().ToString() + "]:" + info;
            _dataChangedEvent.Invoke(tmpStr); //派发事件
        }

        //工作完成，回调
        void bgWorkRunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
        }

        //开始工作，外部调用
        public void startDoTask(object argument){
            if (_bgWorker.IsBusy){
                Console.WriteLine("hcc>>worker IsBusy");
                return;
            }
            _bgWorker.RunWorkerAsync(argument);
        }

        //停止工作
        public void stopDoTask() {
            isStopTask = true;
        }

        //执行任务总线
        private void doTaskReq(object argument)
        {
            var tokenList = (List<Dictionary<string, string>>)argument;
            var headDic = _globalData.getHeadDic();
            for (int index = 0; index < tokenList.Count(); index++){
                var tmpHeadDic = StringUtils.mergeDictionary(headDic, tokenList[index]);
                var taskList = _globalData.getTaskObjList();
                foreach (TaskObj task in taskList){
                    doTaskReq(index + 1, tmpHeadDic , task);
                }
            }
        }

        //执行任务
        private void doTaskReq(int index, Dictionary<string, string> headDic, TaskObj t) {
            //停止做任务
            if (isStopTask == true){
                isStopTask = false;
                return;
            }
            doOneTaskRequest(index, t.getTaskName(), t.getUrl(), t.getMethod(), headDic, t.getUrlBody(), t.getBody());
        }

        //执行一次任务
        /*
         * index: 下标
         * url: 链接，可不带https://
         * method: get 还是post,默认post
         * headDic: 请求头
         * body：放在Url的后面的参数，get或者post都可以用
         * postBody： post的请求体，get可以不用
         */
        private void doOneTaskRequest(int index, string taskName, string url, EasyHttp.Method method, Dictionary<string, string> headDic, string urlBody, string postBody) {
            string retStr = doHttpReq(url, method, headDic, urlBody, postBody);
            if(retStr != null){
                string resStr = "【" + index.ToString() + "】" + taskName + ":" + StringUtils.UnicodeDencode(retStr) + "\n";
                _bgWorker.ReportProgress(100, resStr);
                doOneTaskResPonse(index, taskName, headDic, retStr);
            }
        }

        //执行一次http请求
        private string doHttpReq(string url, EasyHttp.Method method, Dictionary<string, string> headDic, string urlBody, string postBody)
        {
            try{
                EasyHttp http = EasyHttp.With(url);
                if (http != null){
                    if (headDic != null && headDic.Count() > 0){
                        http.AddHeadersByDic(headDic);//添加请求头
                    }

                    http.setUrlBody(urlBody);
                    Task<string> ret = null;
                    if (method == EasyHttp.Method.GET){
                        ret = http.GetForStringAsyc();
                    }
                    else{
                        ret = http.PostForStringAsyc(postBody);
                    }

                    if (ret != null){
                        string sRet = ret.Result;
                        return sRet;
                    }
                }
            }
            catch (Exception e){
                Console.WriteLine("doOneTaskReq error:{0}" + e.Message);
            }
            return null;
        }

        //处理请求后的返回,再去处理其他任务
        private void doOneTaskResPonse(int index, string taskName, Dictionary<string, string> headDic, string responsStr)
        {
            List<TaskObj> taskList = _globalData.getAfterTaskObjList();
            foreach (var t in taskList)
            {
                if(!t.getPreTaskName().Equals(string.Empty) && t.getPreTaskName().Equals(taskName)){
                    doOneTaskByPreTask(index, taskName, headDic, responsStr, t);
                    break;
                }
            }
        }

        //根据前置任务，执行一个任务
        //一般处理：获取前置任务的参数之后，再去做后置任务
        private void doOneTaskByPreTask(int index, string preTaskName, Dictionary<string, string> headDic, string responsStr, TaskObj t)
        {
            if (preTaskName.Equals("分享码")) //例：获取分享码后，再去做其他任务
            {
                var obj = StringUtils.json_decode(responsStr);
                if (obj != null)
                {
                    Console.WriteLine(preTaskName + ":" + " \n" + obj.ToString());
                    string shareCode = (string)obj["data"]["shareCode"];
                    Console.WriteLine("分享码" + ":" + shareCode);

                    string urlBody = string.Empty;
                    if(!string.IsNullOrEmpty(shareCode)){
                        urlBody = "shareCode=" + shareCode;
                    }

                    t.addUrlBody(urlBody).addBody("actType=6&code=5");
                    doOneTaskRequest(index, t.getTaskName(), t.getUrl(), t.getMethod(), headDic, t.getUrlBody(), t.getBody());
                }
            }
            else {
                //处理其他后置任务
                doOneTaskRequest(index, t.getTaskName(), t.getUrl(), t.getMethod(), headDic, t.getUrlBody(), t.getBody());
            }
        }
    }
}
