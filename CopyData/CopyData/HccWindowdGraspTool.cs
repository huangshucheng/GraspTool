using System;
using System.Windows.Forms;
using LuaInterface;
using JinYiHelp.EasyHTTPClient;
using System.Text;
using System.Threading.Tasks;
using System.Net.Http;
using JetyDu.HttpParse;

namespace CopyData
{
    public partial class HccWindowdGraspTool : Form
    {
        private bool _isReceiveFidderLog = false;//是否开启打印Fidder传过来的日志
        private Lua _luaScript = null; //Lua对象
        private string _stringCache = ""; //数据缓存

        public HccWindowdGraspTool()
        {
            //设置Http请求的并发连接数最大值为1000
            System.Net.ServicePointManager.DefaultConnectionLimit = 1000;

            InitializeComponent();
            //加载lua函数，并注册函数到Lua
            try{
                _luaScript = new Lua();
                registLuaFunc();
            }
            catch (Exception e){
                Console.WriteLine("HccWindowdGraspTool error: " + e.Message);
                if (richTextBoxLog != null){
                    richTextBoxLog.AppendText(e.Message);
                }
            }
        }

        //捕获FD消息
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
                    DealWithRecvData(content);
                    this._stringCache = content;
                    if (_isReceiveFidderLog == true){
                        richTextBoxFind.AppendText(content);
                    }
                    break;
                default:
                    break;
            }
            base.WndProc(ref m);
        }

        //处理Fidder传过来的数据,传给lua处理
        private void DealWithRecvData(string dataStr)
        {
            if (string.IsNullOrEmpty(dataStr))
            {
                return;
            }
            try
            {
                _luaScript.DoString("receiveFidderData()");
            }
            catch (Exception e)
            {
                Console.WriteLine("hcc>>DealWithRecvData error: " + e.Message);
                if (richTextBoxLog != null)
                {
                    richTextBoxLog.AppendText("\n" + e.Message);
                }
            }
        }

        //获取Fidder传过来的String
        public string GetFidderString()
        {
            return this._stringCache;
        }
    }
}
