using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.RegularExpressions;
using System.ComponentModel;
using System.Windows.Forms;

//处理接收到的Fidder数据
namespace CopyData
{
    class DealRecvData
    {
        private DealHeaderReq _dealHeaderReq = null;
        private RichTextBox _richTextBoxOutPut = null; //日志输出UI
        private RichTextBox _richTextBoxFindToken = null; //找到了token或cookies 的UI
        private StartTask _startTask = null;
        public DealRecvData(RichTextBox richTextBoxFindToken, RichTextBox richTextBoxOutPut)
        {
            _richTextBoxFindToken = richTextBoxFindToken;
            _richTextBoxOutPut = richTextBoxOutPut;

            _dealHeaderReq = new DealHeaderReq();
            _startTask = new StartTask();

            //监听_dealHeaderReq对象的事件，处理回调函数
            _dealHeaderReq._dataChangedEvent += new DataDelegateHander(onDataHeaderFindToken);

            //监听_startTask对象的事件,处理回调函数
            _startTask._dataChangedEvent += new DataDelegateHander(onDataOutPut);
        }

        //处理fidder传过来的数据
        public void dealWithRecvData(string dataStr) {

            if(dataStr == null || dataStr == string.Empty){
                return;
            }

            Regex regex = new Regex("\n", RegexOptions.IgnoreCase);
            string[] sArray  = regex.Split(dataStr,6); //为了减少计算量，只分割6次，取出请求头的url
            for (var index = 0; index < sArray.Length; index++)
            {
                string lineString = StringUtils.RemoveSpace(StringUtils.ReplaceNewline(sArray[index], string.Empty));
                if(lineString == string.Empty){
                    continue;
                }

                if (lineString != GlobalData.REQ_HEAD_STRING && lineString != GlobalData.REQ_BODY_STRING &&
                    lineString != GlobalData.RES_HEAD_STRING && lineString != GlobalData.RES_BODY_STRING)
                {
                    return;
                }

                if (lineString == GlobalData.REQ_HEAD_STRING)
                {
                    dealWithReqHeader(dataStr);
                    break;
                }
                else if (lineString == GlobalData.REQ_BODY_STRING)
                {
                    dealWithReqBody(dataStr);
                    break;
                }
                else if (lineString == GlobalData.RES_HEAD_STRING)
                {
                    dealWithResHeader(dataStr);
                    break;
                }
                else if (lineString == GlobalData.RES_BODY_STRING)
                {
                    dealWithResBody(dataStr);
                    break;
                }
            }
        }

        //////////////////////////////
        //处理fidder传过来的请求和返回
        //////////////////////////////
        //处理请求头
        private void dealWithReqHeader(string reqHeader){
            _dealHeaderReq.parseData(reqHeader);
        }

        //处理请求体
        private void dealWithReqBody(string reqBody) { 
            
        }

        //处理返回头
        private void dealWithResHeader(string resHeader){
        }

        //处理返回体
        private void dealWithResBody(string resBody) { 
            
        }

        //////////////////////////////
        //自己软件处理好数据后，返回，刷新 UI
        //////////////////////////////

        //请求头数据找到了,返回
        private void onDataHeaderFindToken(string dataString)
        {
            Console.WriteLine("hcc>>>>>", dataString);
            if (this._richTextBoxFindToken != null)
            {
                this._richTextBoxFindToken.AppendText(dataString);
            }
        }

        //请求任务返回
        private void onDataOutPut(string dataString) {
            Console.WriteLine("hcc>>>>>", dataString);
            if (_richTextBoxOutPut != null)
            {
                _richTextBoxOutPut.AppendText(dataString);
            }
        }

        //////////////////////////////
        //自己软件，做任务
        //////////////////////////////
        //开始做任务
        public void startDoTask() {
            _startTask.startDoTask(_dealHeaderReq.getFindList());
        }

        //暂停做任务
        public void pauseDoTask() { 
        
        }

        //停止做任务
        public void stopDoTask() { 
            
        }

        //删除所有token
        public void clearList(){
            _dealHeaderReq.clearList();
        }
    }
}
