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
using Newtonsoft.Json.Linq;
using JWT.Net;

namespace CopyData
{
    public partial class HccWindowdGraspTool : Form
    {
        private DealRecvData _dealData = null; //数据处理对象
        private bool _isReceiveFidderLog = false;//是否开启打印Fidder传过来的日志

        public HccWindowdGraspTool()
        {
            InitializeComponent();
            //UI在这里传过去，dealData那边操作UI
            _dealData = new DealRecvData(this.richTextBoxFind,this.richTextBoxLog);
            //test
            /*
            JObject subFather = new JObject();
            JObject sub = new JObject();
            sub.Add("orgId", "hebeizhongyan");
            sub.Add("appid", "wxae8baae566aa8758");
            sub.Add("openid", "o1UcM6OyGhMPkZoLfwcAvGzCeqnw");
            sub.Add("unionid", "o0HJV0r9IyBravvLDw1l826-ZU6A");
            sub.Add("loginTime", 1606838480971);
            sub.Add("tag", "16068384809718KAYPLSVUZNNJ33");
            sub.Add("userId", 1066681204);
            subFather.Add("sub", sub);
            subFather.Add("exp", 1606834519);

            string json_str = StringUtils.json_encode(subFather);

            string key = "hebeizhongyan";
            string key2 = "a753d4df7ff177a8287cc4b010c2e1464e89a4b4";

            var token = JWT.JsonWebToken.Encode(json_str, key2, JWT.JwtHashAlgorithm.HS256);
           // var deToken = JWT.JsonWebToken.Decode(token,key,false);
            */
            /*
            JObject obj = new JObject();
            obj.Add("a", "123");
            obj.Add("b", "1233454");

            var fileName = "token.json";
            //LocalStorage.saveJsonObjToFile(obj);
            JObject bigObj = LocalStorage.getJsonObjFromFile(fileName);
            if (bigObj != null)
            {
                foreach(var o in bigObj){
                    Console.WriteLine("hcc>>index>> key:" + o.Key + " ,value:" + o.Value);
                    Console.WriteLine("hcc>>index>> " + o.Value["token"] + o.Value["cookie"]);
                    var vl = (JObject)o.Value;
                    foreach(var v in vl){
                        var kkk = v.Key;
                        var vvv = v.Value;
                        //var dic = new Dictionary<string, string>();
                        //dic.Add(v.First.ToString(), v.Last.ToString());
                        //Console.WriteLine("hcc>>index>> vv:" + aaa );
                    }
                }
            }
            */
        }

        //捕获消息
        protected override void WndProc(ref Message m)
        {
            switch (m.Msg)
            {
                case Define.WM_COPYDATA:
                    //处理消息
                    COPYDATASTRUCT mystr = new COPYDATASTRUCT();
                    Type mytype = mystr.GetType();
                    mystr = (COPYDATASTRUCT)m.GetLParam(mytype);
                    string content = mystr.lpData;
                    //Console.WriteLine("hcc>>recvCopyData: "+ content);
                    //this.richTextBoxLog.AppendText(content);
                    if (_isReceiveFidderLog == true){
                        this.richTextBoxFind.AppendText(content);
                    }
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

        //token查找输出，函数将滚动条滚动到最后
        private void richTextBoxFindTextChanged(object sender, EventArgs e)
        {
            richTextBoxFind.SelectionStart = richTextBoxFind.Text.Length;
            richTextBoxFind.ScrollToCaret();
        }

        //日志打印查找输出
        private void richTextBoxLogTextChanged(object sender, EventArgs e)
        {
            richTextBoxLog.SelectionStart = richTextBoxLog.Text.Length;
            richTextBoxLog.ScrollToCaret();
        }

        //点击清理输出
        private void buttonClearLogClick(object sender, EventArgs e)
        {
            this.richTextBoxLog.Clear();
        }
      
        //点击开始抓包
        private void btnStartCatch_Click(object sender, EventArgs e)
        {
            _dealData.startDoTask();
        }

        //点击停止抓包
        private void btnStopCatch_Click(object sender, EventArgs e)
        {
            _dealData.stopDoTask();
        }

        //test 按钮点击
        private void btnFinishCatch_Click(object sender, EventArgs e)
        {
        }

        private void check_btn_log_CheckedChanged(object sender, EventArgs e)
        {
            if (this.check_btn_log != null){
                _isReceiveFidderLog = this.check_btn_log.Checked;
            }
        }
    }
}
