using System;
using System.Windows.Forms;
using LuaInterface;
using JinYiHelp.EasyHTTPClient;
using System.Text;
using System.Threading.Tasks;
using System.Net.Http;

namespace CopyData
{
    public partial class HccWindowdGraspTool : Form
    {
        private bool _isReceiveFidderLog = false;//是否开启打印Fidder传过来的日志
        private Lua _luaScript = null; //Lua对象
        private string _stringCache = ""; //数据缓存

        public HccWindowdGraspTool()
        {
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

        private void btnClearTokenClick(object sender, EventArgs e)
        {
            this.richTextBoxFind.Clear();
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

        private void check_btn_log_CheckedChanged(object sender, EventArgs e)
        {
            if (check_btn_log != null){
                _isReceiveFidderLog = this.check_btn_log.Checked;
            }
        }
    }
}
