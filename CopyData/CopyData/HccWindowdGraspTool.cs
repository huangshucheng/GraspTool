using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Runtime.InteropServices;

namespace CopyData
{
    public partial class HccWindowdGraspTool : Form
    {
        public const int WM_COPYDATA = 0x004A;
        private DealRecvData _dealData = null;
        //COPYDATASTRUCT结构
        public struct COPYDATASTRUCT
        {
            public IntPtr dwData;
            public int cData;
            [MarshalAs(UnmanagedType.LPStr)]
            public string lpData;
        }

        public HccWindowdGraspTool()
        {
            InitializeComponent();
            //UI在这里传过去，dealData那边操作UI
            _dealData = new DealRecvData(this.richTextBoxFind,this.richTextBoxLog);

            //test
            /*
            var headDic = new Dictionary<string, string>();
            var headDic2 = new Dictionary<string, string>();
            
            headDic["key1"] = "value1";
            headDic["key2"] = "value2";
            headDic["key3"] = "value3";

            headDic2["key1"] = "value1";
            headDic2["key2"] = "value2";
            headDic2["key3"] = "value4";
            headDic2["key4"] = "value6";

            bool isEqul = StringUtils.isDictionaryEqule(headDic, headDic2);
            var newDic = StringUtils.mergeDictionary(headDic, headDic2);

            //foreach(var key in headDic){
            //    Console.WriteLine("hcc>>Dic: ", key.Key.ToString(), key.Value.ToString());
            //}

            for(int idx = 0; idx <GlobalData.DATA_TO_FIND_ARRAY.Length; idx++)
            {
                Console.WriteLine("hcc>>DATA_TO_FIND_ARRAY: ", idx, GlobalData.DATA_TO_FIND_ARRAY[idx]);
            }
            */
        }

        //捕获消息
        protected override void WndProc(ref Message m)
        {
            switch (m.Msg)
            {
                case WM_COPYDATA:
                    //处理消息
                    COPYDATASTRUCT mystr = new COPYDATASTRUCT();
                    Type mytype = mystr.GetType();
                    mystr = (COPYDATASTRUCT)m.GetLParam(mytype);
                    string content = mystr.lpData;
                    //Console.WriteLine("hcc>>recvCopyData: ", content);
                    //this.richTextBoxLog.AppendText(content);
                    //this.richTextBoxFind.AppendText(content);

                    _dealData.dealWithRecvData(content);
                    break;
                default:
                    break;
            }
            base.WndProc(ref m);
        }

        private void btnClearTokenClick(object sender, EventArgs e)
        {
            this.richTextBoxFind.Clear();
            _dealData.clearList();
        }

        //将滚动条滚动到最后
        private void richTextBoxFindTextChanged(object sender, EventArgs e)
        {
            richTextBoxFind.SelectionStart = richTextBoxFind.Text.Length;
            richTextBoxFind.ScrollToCaret();
        }

        private void richTextBoxLogTextChanged(object sender, EventArgs e)
        {
            richTextBoxLog.SelectionStart = richTextBoxLog.Text.Length;
            richTextBoxLog.ScrollToCaret();
        }

        private void buttonClearLogClick(object sender, EventArgs e)
        {
            this.richTextBoxLog.Clear();
        }
      
        private void btnStartCatch_Click(object sender, EventArgs e)
        {
            _dealData.startDoTask();
        }

        private void btnStopCatch_Click(object sender, EventArgs e)
        {
            _dealData.pauseDoTask();
        }

        private void btnFinishCatch_Click(object sender, EventArgs e)
        {
            _dealData.stopDoTask();
        }
    }
}
