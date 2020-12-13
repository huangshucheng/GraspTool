using System;
using System.Windows.Forms;
using LuaInterface;
using JinYiHelp.EasyHTTPClient;
using System.Text;
using System.Threading.Tasks;

namespace CopyData
{
    public partial class HccWindowdGraspTool : Form
    {
        //private DealRecvData _dealData = null; //数据处理对象
        private bool _isReceiveFidderLog = false;//是否开启打印Fidder传过来的日志
        private Lua _luaScript = null; //Lua对象

        public HccWindowdGraspTool()
        {
            InitializeComponent();

            _luaScript = new Lua();
            //UI在这里传过去，dealData那边操作UI
            //_dealData = new DealRecvData(this.richTextBoxFind,this.richTextBoxLog);

            //加载lua函数，并注册函数到Lua
            try{
                registLuaFunc();
            }
            catch (Exception e){
                Console.WriteLine("hcc>>HccWindowdGraspTool error: " + e.Message);
                if (richTextBoxLog != null){
                    richTextBoxLog.AppendText(e.Message);
                }
            }
        }

        //注册函数给lua使用
        void registLuaFunc()
        {
            //例：
            // 注册CLR对象方法到Lua，供Lua调用   typeof(TestClass).GetMethod("TestPrint")
            //lua.RegisterFunction("testLuaPrint", obj, obj.GetType().GetMethod("testLuaPrint"));
            // 注册CLR静态方法到Lua，供Lua调用
            //lua.RegisterFunction("testStaticLuaPrint", null, typeof(TestLuaCall).GetMethod("testStaticLuaPrint"));

            _luaScript.RegisterFunction("LogLua", null, typeof(LuaCall).GetMethod("LogLua")); //打印到控制台
            _luaScript.RegisterFunction("LogToken", this, GetType().GetMethod("LogToken")); //打印到token界面
            _luaScript.RegisterFunction("LogOut", this, GetType().GetMethod("LogOut")); //打印到输出界面
            _luaScript.RegisterFunction("getCurDir", null, typeof(LuaCall).GetMethod("getCurDir")); //获取当前exe文件位置
            _luaScript.RegisterFunction("getDeskTopDir", null, typeof(LuaCall).GetMethod("getDeskTopDir")); //获取桌面位置
            _luaScript.RegisterFunction("getFidderString", null, typeof(LuaCall).GetMethod("getFidderString")); //传Fidder数据
            //_luaScript.RegisterFunction("testDic", null, typeof(LuaCall).GetMethod("testDic")); //传Fidder数据
            _luaScript.RegisterFunction("httpRequest", null, typeof(LuaCall).GetMethod("httpRequest")); //传Fidder数据
            _luaScript.RegisterFunction("httpRequestAsync", null, typeof(LuaCall).GetMethod("httpRequestAsync")); //传Fidder数据

            string path = Environment.CurrentDirectory + "\\luaScript\\main.lua";
            _luaScript.DoFile(path);
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
                    //_dealData.dealWithRecvData(content);
                    dealWithRecvData(content);
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
        private void dealWithRecvData(string dataStr)
        {
            if (string.IsNullOrEmpty(dataStr))
            {
                return;
            }

            try
            {
                LuaCall.setFidderString(dataStr);
                _luaScript.DoString("receiveFidderData()");
            }
            catch (Exception e)
            {
                Console.WriteLine("hcc>>dealWithRecvData error: " + e.Message);
                if (richTextBoxLog != null)
                {
                    richTextBoxLog.AppendText("\n" + e.Message);
                }
            }
        }

        // 导出给lua使用，打印字符串到token界面
        public void LogToken(string str)
        {
            if (richTextBoxFind != null)
            {
                if (!string.IsNullOrEmpty(str))
                {
                    richTextBoxFind.AppendText(str);
                }
            }
        }

        // 导出给lua使用，打印字符串到log界面
        public void LogOut(string str)
        {
            if (richTextBoxLog != null)
            {
                if (!string.IsNullOrEmpty(str))
                {
                    richTextBoxLog.AppendText(str);
                }
            }
        }

        private void btnClearTokenClick(object sender, EventArgs e)
        {
            this.richTextBoxFind.Clear();
            //_dealData.clearList();
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
        }

        //点击停止抓包
        private void btnStopCatch_Click(object sender, EventArgs e)
        {
        }

        //test 按钮点击
        private void btnFinishCatch_Click(object sender, EventArgs e)
        {
            //var ret = await testLua();
            //Console.WriteLine(ret);
            //var str = LuaCall.httpRequest("www.baidu.com");
            //LuaCall.httpRequestAsync("www.baidu.com",0);
            //Console.WriteLine(str);

            _luaScript.DoString("testCall()");
        }

        private async Task<string> testLua() {
            //var str = LuaCall.httpRequest("www.baidu.com");
            //LuaCall.startReqHttp("test");
            //Console.WriteLine("cccc" + str);

            HttpItem item = new HttpItem()
            {
                URL = "https://www.baidu.com",
                Method = System.Net.Http.HttpMethod.Get,
                Allowautoredirect = true,
                Encoding = Encoding.UTF8,
            };
            //需要在方法上面加上 async Task<string> 
            var result = await item.GetHtml();
            Console.WriteLine(result.Html);
            return result.Html;
        }

        private void check_btn_log_CheckedChanged(object sender, EventArgs e)
        {
            if (check_btn_log != null){
                _isReceiveFidderLog = this.check_btn_log.Checked;
            }
        }
    }
}
