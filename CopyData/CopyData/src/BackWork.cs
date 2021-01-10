using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel;
using LuaInterface;

namespace CopyData
{
    class BackWork
    {
        BackgroundWorker _bgWorker = null; //工作线程

        public BackWork() {
            InitBackGroundWorker();
        }

        //初始化工作线程
        private void InitBackGroundWorker()
        {
            _bgWorker = new BackgroundWorker();
            _bgWorker.WorkerReportsProgress = true;
            _bgWorker.WorkerSupportsCancellation = true;
            _bgWorker.DoWork += new DoWorkEventHandler(bgWorkerDoReq); //开始工作
            _bgWorker.ProgressChanged += new ProgressChangedEventHandler(bgWorkProgressChanged);
            _bgWorker.RunWorkerCompleted += new RunWorkerCompletedEventHandler(bgWorkRunWorkerCompleted);
        }

        //开始工作，回调
        private void bgWorkerDoReq(object sender, DoWorkEventArgs eventArgs)
        {
            try {
                var param = eventArgs.Argument;
                if (param != null) {
                    HTTP_REQ_PARAM reqParam = (HTTP_REQ_PARAM)param;
                    //_bgWorker.ReportProgress(100, retStr);
                }
            } catch (Exception e) {
                Console.WriteLine("error: bgWorkerDoReq>> " + e.Message);
            }
        }

        //工作进度，回调
        private void bgWorkProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            string info = (string)e.UserState;
            if (string.IsNullOrEmpty(info)){
                info = "";
            }
            Console.WriteLine("ret>> " + info);
        }

        //工作完成，回调
        private void bgWorkRunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
        }

        //开始工作，外部调用
        private void startBackWork(object argument)
        {
            if (_bgWorker.IsBusy){
                Console.WriteLine("error: bgWorker is busy");
                return;
            }

            try {
                _bgWorker.RunWorkerAsync(argument);
            } catch (Exception e) {
                Console.WriteLine("error: bgWorker>> " + e.Message);
            }
        }
    }
}
