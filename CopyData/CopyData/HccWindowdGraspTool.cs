using System;
using System.Windows.Forms;
using LuaInterface;

namespace CopyData
{
    public partial class HccWindowdGraspTool : Form
    {
        private Lua _luaScript = null; //Lua对象
        private string _stringCache = ""; //数据缓存

        public HccWindowdGraspTool()
        {
            //设置Http请求的并发连接数最大值为1000
            System.Net.ServicePointManager.DefaultConnectionLimit = 1000;
            //Control.CheckForIllegalCrossThreadCalls = false; //开启多个线程能同时访问UI,会引起一系列问题

            InitializeComponent();
            InitListView();
            //加载lua函数，并注册函数到Lua
            try{
                _luaScript = new Lua();
                registLuaFunc();
            }
            catch (Exception e){
                LogOut("初始化错误>>>> " + e.Message);
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
                var func = _luaScript.GetFunction("Fidder_OnRecvData");
                if (func != null){
                    _luaScript.DoString("Fidder_OnRecvData()");
                }
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
        public string GetFidderString(){
            return this._stringCache;
        }

        private void 删除ToolStripMenuItem1_Click(object sender, EventArgs e)
        {

        }
    }
}
