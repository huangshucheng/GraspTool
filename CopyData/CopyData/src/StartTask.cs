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

        //执行任务总线
        private void doTaskReq(object argument)
        {
            var tokenList = (List<Dictionary<string, string>>)argument;
            var headDic = _globalData.getHeadDic();
            for (int index = 0; index < tokenList.Count(); index++)
            {
                var tmpHeadDic = StringUtils.mergeDictionary(headDic, tokenList[index]);
                var taskList = _globalData.getTaskConfig();
                foreach(TaskConfig t in taskList){
                    //for(int i = 0; i < 50; i++){
                    doOneTaskReq(index+1, t.getUrl(), t.getMethod(), tmpHeadDic, t.getBody());
                    //}
                }
            }
        }

        //执行一种任务
        /*
         * index: 下标
         * url: 链接，可不带https://
         * method: get 还是post,默认post
         * headDic: 请求头
         * body：请求体
         */
        private void doOneTaskReq(int index, string url, EasyHttp.Method method, Dictionary<string, string> headDic, List<KeyValue> body) {
            try
            {
                EasyHttp http = EasyHttp.With(url);
                if(http != null){
                    if(headDic != null && headDic.Count() > 0){
                        http.AddHeadersByDic(headDic);//添加请求头
                    }
                    if(body != null && body.Count > 0){ //添加请求体
                        http.Data(body);
                    }
                    Task<string> ret = null;
                    if(method == EasyHttp.Method.GET){
                        ret = http.GetForStringAsyc();
                    }else{
                         ret = http.PostForStringAsyc();
                    }

                    if (ret != null)
                    {
                        string sRet = ret.Result;
                        if(sRet != null){
                            string resStr = "【" + index.ToString() + "】" + StringUtils.UnicodeDencode(sRet) + "\n";
                            _bgWorker.ReportProgress(100, resStr);
                        }
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("doOneTaskReq error:{0}", e.Message);
            }
        }
    }
}
