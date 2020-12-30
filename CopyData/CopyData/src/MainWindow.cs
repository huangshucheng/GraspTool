using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using LuaInterface;
using System.IO;
using System.Collections;
using System.Windows.Forms;
using System.Drawing;
using System.Net;
using JinYiHelp;

namespace CopyData
{
    public partial class HccWindowdGraspTool
    {
        Dictionary<string, System.Timers.Timer> _timerDic = new Dictionary<string, System.Timers.Timer>();
        //注册函数给lua使用
        void registLuaFunc()
        {
            //例：
            // 注册CLR对象方法到Lua，供Lua调用   typeof(TestClass).GetMethod("TestPrint")
            //lua.RegisterFunction("testLuaPrint", obj, obj.GetType().GetMethod("testLuaPrint"));
            // 注册CLR静态方法到Lua，供Lua调用
            //lua.RegisterFunction("testStaticLuaPrint", null, typeof(TestLuaCall).GetMethod("testStaticLuaPrint"));

            //类对象方法
            _luaScript.RegisterFunction("LogOut", this, GetType().GetMethod("LogOut")); //打印到输出界面
            _luaScript.RegisterFunction("LogLua", this, GetType().GetMethod("LogLua")); //打印到控制台
            _luaScript.RegisterFunction("GetFidderString", this, GetType().GetMethod("GetFidderString")); //传Fidder数据到lua
            _luaScript.RegisterFunction("SetDelayTime", this, GetType().GetMethod("SetDelayTime")); //延时函数
            _luaScript.RegisterFunction("SetInterval", this, GetType().GetMethod("SetInterval")); //定时器
            _luaScript.RegisterFunction("StopTimer", this, GetType().GetMethod("StopTimer")); //停止定时器
            _luaScript.RegisterFunction("AddActivityToList", this, GetType().GetMethod("AddActivityToList")); //增加活动名称到列表
            _luaScript.RegisterFunction("IsOpenTipSound", this, GetType().GetMethod("IsOpenTipSound")); //获取是否有提示音
            _luaScript.RegisterFunction("IsAutoGraspCK", this, GetType().GetMethod("IsAutoGraspCK")); //是否自动抓取CK
            _luaScript.RegisterFunction("IsAutoDoAction", this, GetType().GetMethod("IsAutoDoAction")); //是否自动做任务
            _luaScript.RegisterFunction("IsShowOutLog", this, GetType().GetMethod("IsShowOutLog")); //是否显示输出日志
            _luaScript.RegisterFunction("GetReqDelayTime", this, GetType().GetMethod("GetReqDelayTime")); //获取延迟时间
            _luaScript.RegisterFunction("GetReqPktTime", this, GetType().GetMethod("GetReqPktTime")); //获取卡包次数
            _luaScript.RegisterFunction("ClearOutLog", this, GetType().GetMethod("ClearOutLog")); //清理输出日志
            _luaScript.RegisterFunction("ShowQRCode", this, GetType().GetMethod("ShowQRCode")); //显示二维码
            _luaScript.RegisterFunction("GetQRCodeString", this, GetType().GetMethod("GetQRCodeString")); //获取生成二维码字符串
            _luaScript.RegisterFunction("ClearQRCode", this, GetType().GetMethod("ClearQRCode")); //清理二维码图片

            //静态方法
            _luaScript.RegisterFunction("GetCurDir", null, typeof(LuaCall).GetMethod("GetCurDir")); //获取当前exe文件位置
            _luaScript.RegisterFunction("GetDeskTopDir", null, typeof(LuaCall).GetMethod("GetDeskTopDir")); //获取桌面位置
            _luaScript.RegisterFunction("HttpRequest", null, typeof(LuaCall).GetMethod("HttpRequest")); //http请求
            _luaScript.RegisterFunction("HttpRequestAsync", null, typeof(LuaCall).GetMethod("HttpRequestAsync")); //http请求 异步
            _luaScript.RegisterFunction("PlayWAVSound", null, typeof(LuaCall).GetMethod("PlayWAVSound")); //播放音效

            //文件相关（静态方法）
            _luaScript.RegisterFunction("IsFileExist", null, typeof(LocalStorage).GetMethod("IsFileExist")); //文件是否存在
            _luaScript.RegisterFunction("WriteFile", null, typeof(LocalStorage).GetMethod("WriteFile")); //写入文件
            _luaScript.RegisterFunction("ReadFile", null, typeof(LocalStorage).GetMethod("ReadFile")); //读取文件内容
            _luaScript.RegisterFunction("AppendText", null, typeof(LocalStorage).GetMethod("AppendText")); //追加文件
            _luaScript.RegisterFunction("AppendLine", null, typeof(LocalStorage).GetMethod("AppendLine")); //追加一行
            _luaScript.RegisterFunction("CreateFile", null, typeof(LocalStorage).GetMethod("CreateFile")); //创建文件

            //字符串相关方法（静态方法）
            _luaScript.RegisterFunction("Utf8ToDefault", null, typeof(StringUtils).GetMethod("Utf8ToDefault")); //字符串转码
            _luaScript.RegisterFunction("DefaultToUtf8", null, typeof(StringUtils).GetMethod("DefaultToUtf8")); //字符串转码
            _luaScript.RegisterFunction("StringCompare", null, typeof(StringUtils).GetMethod("StringCompare")); //字符串比较

            string path = Environment.CurrentDirectory + "/resources/luaScript/main.lua";
            _luaScript.DoFile(path);
        }

        //test 按钮点击
        private void btnFinishCatch_Click(object sender, EventArgs e)
        {
            _luaScript.DoString("testCall()");
            //var str = LuaCall.httpRequest("www.baidu.com");
            //LuaCall.httpRequestAsync("www.baidu.com");
            //var url = "https://hbz.qrmkt.cn/hbact/hyr/sign/list";
            //LuaCall.httpRequestAsync("www.baidu.com",1,null,"urlBody=hcc","postBody=123", "", null);
            //LuaCall.httpRequestAsync(url, 1,null,"urlBody=hcc","postBody=123", "", null);
            //LuaCall.HttpRequestAsync("www.baidu.com", 1,null,"","", "", null);
            //SetTimeOut(1);
            //var fileName = "hcc_test.json";
            //var curPath = LuaCall.GetCurDir() + "\\" + fileName;

            /*
            //添加数据项    
            this.listViewToken.BeginUpdate();   //数据更新，UI暂时挂起，直到EndUpdate绘制控件，可以有效避免闪烁并大大提高加载速度
            for (int i = 0; i < 2; i++)   //添加10行数据
            {
                ListViewItem lvi = new ListViewItem();
                lvi.ImageIndex = i;     //通过与imageList绑定，显示imageList中第i项图标
                lvi.Text = "" + i;
                lvi.SubItems.Add("第2列,第 " + i + " 行》》》》");
                lvi.SubItems.Add("第3列,第 " + i + " 行");
                lvi.SubItems.Add("第4列,第 " + i + " 行");
                this.listViewToken.Items.Add(lvi);
            }
            ////滚动到最后
            listViewToken.Items[listViewToken.Items.Count - 1].EnsureVisible();
            //listViewToken.TopItem = listViewToken.Items[listViewToken.Items.Count - 1];
            this.listViewToken.EndUpdate();  //结束数据处理，UI界面一次性绘制。
            */
            SetInterval(1);
            //var utime = JinYiHelp.TimeHelp.TimeHelper.GetUnixTime();
            //LogOut(utime);
        }

        /// ///////////////////////////////////
        /// 注册到lua的函数,lua调用
        /// //////////////////////////////////

        //清理二维码
        public void ClearQRCode() {
            var gra = pictureBoxUrl.CreateGraphics();
            gra.Clear(Color.White);
        }

        //显示二维码
        public void ShowQRCode(string url, string method = "GET", LuaFunction callBack = null) {
            method = string.IsNullOrEmpty(method) ? "GET" : method;
            ShowPicToPictureBox(url, this.pictureBoxUrl, method, callBack);
        }

        //显示图片
        private async void ShowPicToPictureBox(string url, PictureBox imgNode, string method = "GET", LuaFunction callBack = null)
        {
            try{
                HttpWebRequest req = HttpWebRequest.CreateHttp(url);
                req.Method = method;
                var resp = await req.GetResponseAsync();
                Stream stream = resp.GetResponseStream();
                if (imgNode != null){
                    imgNode.Image = Image.FromStream(stream);
                }
                stream.Close();
                if (callBack != null) {
                    callBack.Call("SUCCESS");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("GetPicStream error>> " + ex.Message);
                if (callBack != null){
                    callBack.Call(ex.Message);
                }
            }
        }

        // 导出给lua使用，打印字符串到log界面
        public void LogOut(string logStr)
        {
            if (richTextBoxLog != null)
            {
                if (!string.IsNullOrEmpty(logStr))
                {
                    richTextBoxLog.AppendText(logStr + "\n");
                }
            }
        }

        //打印log 到cmd
        public void LogLua(string logStr)
        {
            if (!string.IsNullOrEmpty(logStr)) {
                Console.WriteLine(logStr + "\n");
            }
        }

        //定时器, 
        //interval 秒
        //返回： 定时器ID(string类型)，用于取消定时器
        public string SetInterval(double interVal, LuaFunction callback = null) {
            if (callback == null){
                return string.Empty;
            }
            interVal = interVal * 1000;
            if (interVal <= 0)
            {
                if (callback != null){
                    callback.Call();
                }
                return string.Empty;
            }
            System.Timers.Timer timer = new System.Timers.Timer(interVal);
            timer.Elapsed += delegate (object sender, System.Timers.ElapsedEventArgs e)
            {
                Action action = new Action(() => {
                    //LogOut("timer>>>>>>>>>>>>>");
                    if (callback != null){
                        callback.Call();
                    }
                });
                this.Invoke(action);
            };
            timer.Enabled = true;//开始触发
            string timerID = JinYiHelp.TimeHelp.TimeHelper.GetUnixTime();
            _timerDic.Add(timerID, timer);
            return timerID;
        }

        //停止定时器,id: string 类型
        public bool StopTimer(string timerID) {
            if (_timerDic.ContainsKey(timerID)) {
                var timer = _timerDic[timerID];
                if (timer != null) {
                    _timerDic[timerID].Stop();
                    _timerDic[timerID].Close();
                }
                _timerDic.Remove(timerID);
                return true;
            }
            return false;
        }

        //延时函数, delayTime:秒
        public void SetDelayTime(double delayTime, LuaFunction endFunc = null)
        {
            delayTime = delayTime * 1000;
            if (delayTime <= 0)
            {
                if (endFunc != null)
                {
                    endFunc.Call();
                }
                return;
            }
            System.Timers.Timer timer = new System.Timers.Timer();
            timer.AutoReset = true;//是否只触发一次
            timer.Interval = delayTime;//时间间隔
            timer.Elapsed += delegate (object sender, System.Timers.ElapsedEventArgs e)
            {
                timer.Enabled = false;//停用触发
                timer.Stop();
                timer.Close();
                Action action = new Action(() => {
                    if (endFunc != null)
                    {
                        endFunc.Call();
                    }
                });
                this.Invoke(action);
            };
            timer.Enabled = true;//开始触发
        }

        //增加活动名称到列表
        public void AddActivityToList(LuaTable actTable)
        {
            if (actTable != null)
            {
                if (actTable.Keys.Count > 0)
                {
                    foreach (DictionaryEntry v in actTable)
                    {
                        string nameStr = v.Value.ToString();
                        comboBoxActList.Items.Add(nameStr);
                    }
                }
            }
        }

        //获取生成二维码字符串
        public string GetQRCodeString() {
            return richTextQRCode.Text;
        }

        //获取是否有提示音
        public bool IsOpenTipSound()
        {
            return chckSound.Checked;
        }

        //是否自动抓取CK
        public bool IsAutoGraspCK()
        {
            return checkAutoGraspCk.Checked;
        }

        // 是否自动做任务
        public bool IsAutoDoAction()
        {
            return checkAutoDoAct.Checked;
        }

        //是否显示输出日志
        public bool IsShowOutLog()
        {
            return checkShowLog.Checked;
        }

        // 获取延迟时间
        public decimal GetReqDelayTime()
        {
            return numUDDelay.Value;
        }

        // 获取请求次数
        public decimal GetReqPktTime()
        {
            return numUDGraspTime.Value;
        }

        //清理输出日志
        public void ClearOutLog()
        {
            if (richTextBoxLog != null)
                richTextBoxLog.Clear();
        }

        //点击清理token日志
        private void btnClearTokenClick(object sender, EventArgs e)
        {
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

        /// ///////////////////////////////////
        /// 调用Lua函数
        /// //////////////////////////////////

        //点击生成二维码
        private void btnGenQRCode_Click(object sender, EventArgs e)
        {
            try
            {
                _luaScript.DoString("onClickGenQRCode()");
            }
            catch (Exception ex)
            {
                Console.WriteLine("btnGenQRCode_Click error >> " + ex.Message);
            }
        }

        //点击开始抓包
        private void btnStartCatch_Click(object sender, EventArgs e)
        {
            try
            {
                _luaScript.DoString("onClickStartDoAct()");
            }
            catch (Exception ex)
            {
                Console.WriteLine("btnStartCatch_Click error >> " + ex.Message);
            }
        }

        //点击停止抓包
        private void btnStopCatch_Click(object sender, EventArgs e)
        {
            try
            {
                _luaScript.DoString("onClickStopDoAct()");
                //var keys = _timerDic.Keys;
                //foreach (var value in keys) {
                //    StopTimer(value);
                //}
            }
            catch (Exception ex)
            {
                Console.WriteLine("btnStopCatch_Click error >> " + ex.Message);
            }
        }

        //是否显示FD日志
        private void check_btn_log_CheckedChanged(object sender, EventArgs e)
        {
            if (check_btn_log != null)
            {
                _isReceiveFidderLog = this.check_btn_log.Checked;
            }
        }

        //修改了延迟时间
        private void numUDDelay_ValueChanged(object sender, EventArgs e)
        {
            try
            {
                var num = (NumericUpDown)sender;
                var value = num.Value.ToString();
                _luaScript.DoString("onDelayTimeChanged("+ value + ")");
            }
            catch (Exception ex)
            {
                Console.WriteLine("numUDDelay_ValueChanged error >> " + ex.Message);
            }
        }

        //修改了卡包次数
        private void numUDGraspTime_ValueChanged(object sender, EventArgs e)
        {
            try
            {
                var num = (NumericUpDown)sender;
                var value = num.Value.ToString();
                _luaScript.DoString("onReqTimeChanged(" + value + ")");
            }
            catch (Exception ex)
            {
                Console.WriteLine("numUDGraspTime_ValueChanged error >> " + ex.Message);
            }
        }

        //选中列表元素
        private void comboBoxActList_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                int selectIndex = comboBoxActList.SelectedIndex + 1;
                _luaScript.DoString("onSelectActivityFromList(" + selectIndex + ")");
            }
            catch (Exception ex)
            {
                Console.WriteLine("comboBoxActList_SelectedIndexChanged error >> " + ex.Message);
            }
        }

        //点击是否播放音效
        private void chckSound_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                var checkBox = (CheckBox)sender;
                string isCheckdStr = checkBox.Checked == true ? "true" : "false";
                var doStirng = "onSelectPlayCound(" + isCheckdStr + ")";
                _luaScript.DoString(doStirng);
            }
            catch (Exception ex)
            {
                Console.WriteLine("checkAutoGraspCk_CheckedChanged error >> " + ex.Message);
            }
        }

        //点击自动抓CK
        private void checkAutoGraspCk_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                var checkBox = (CheckBox)sender;
                string isCheckdStr = checkBox.Checked == true ? "true" : "false";
                var doStirng = "onSelectAutoGraspCk(" + isCheckdStr + ")";
                _luaScript.DoString(doStirng);
            }
            catch (Exception ex)
            {
                Console.WriteLine("checkAutoGraspCk_CheckedChanged error >> " + ex.Message);
            }
        }

        //点击自动做任务
        private void checkAutoDoAct_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                var checkBox = (CheckBox)sender;
                string isCheckdStr = checkBox.Checked == true ? "true" : "false";
                _luaScript.DoString("onSelectAutoDoAct(" + isCheckdStr + ")");
            }
            catch (Exception ex)
            {
                Console.WriteLine("checkAutoGraspCk_CheckedChanged error >> " + ex.Message);
            }
        }

        //点击是否显示输出日志
        private void checkShowLog_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                var checkBox = (CheckBox)sender;
                string isCheckdStr = checkBox.Checked == true ? "true" : "false";
                _luaScript.DoString("onSelectShowOutLog(" + isCheckdStr + ")");
            }
            catch (Exception ex)
            {
                Console.WriteLine("checkAutoGraspCk_CheckedChanged error >> " + ex.Message);
            }
        }

        //点击listView
        private void listViewToken_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        //listView 初始化
        private void InitListView() {

            //初始化
            listViewToken.View = View.Details;
            listViewToken.FullRowSelect = true; //设置是否行选择模式, 可选中整个行
            listViewToken.GridLines = true; //设置行和列之间是否显示网格线。
            listViewToken.MultiSelect = true; //设置是否可以选择多个项
            listViewToken.HeaderStyle = ColumnHeaderStyle.Clickable; //设置列标头样式
            listViewToken.LabelEdit = true; //设置用户是否可以编辑控件中项的标签(没用)
            listViewToken.CheckBoxes = true; //设置控件中各项的旁边是否显示复选框
            //listViewToken.CheckedItems = null; //获取控件中当前复选框选中的项(有用)
            listViewToken.HideSelection = true; //设置选定项在控件没焦点时是否隐藏突出显示
            //listViewToken.TopItem = ;// 获取或设置控件中的第一个可见项，可用于定位。（效果类似于EnsureVisible方法）

            //列表头创建（记得，需要先创建列表头）
            listViewToken.Columns.Add("序号", 50, HorizontalAlignment.Left);
            listViewToken.Columns.Add("Cookies", 250, HorizontalAlignment.Left);
            listViewToken.Columns.Add("结果", 200, HorizontalAlignment.Left);
            listViewToken.Columns.Add("状态", 100, HorizontalAlignment.Left);

            //添加数据项    
            this.listViewToken.BeginUpdate();   //数据更新，UI暂时挂起，直到EndUpdate绘制控件，可以有效避免闪烁并大大提高加载速度
            for (int i = 0; i < 60; i++)   //添加10行数据
            {
                ListViewItem lvi = new ListViewItem();
                lvi.ImageIndex = i;     //通过与imageList绑定，显示imageList中第i项图标
                lvi.Text = "" + i;
                lvi.SubItems.Add("第2列,第 " + i + " 行》》》》");
                lvi.SubItems.Add("第3列,第 " + i + " 行");
                lvi.SubItems.Add("第4列,第 " + i + " 行");
                lvi.SubItems.Add("第5列,第 " + i + " 行");
                this.listViewToken.Items.Add(lvi);
            }
            ////滚动到最后
            //listViewToken.Items[listViewToken.Items.Count - 1].EnsureVisible();
            //listViewToken.TopItem = listViewToken.Items[listViewToken.Items.Count - 1];
            this.listViewToken.EndUpdate();  //结束数据处理，UI界面一次性绘制。
            //访问数据
            foreach (ListViewItem item in this.listViewToken.Items){
                //处理行
                for (int i = 0; i < item.SubItems.Count; i++)
                {
                    //处理列
                    //MessageBox.Show(item.SubItems[i].Text);
                }
            }

            //移除
            foreach (ListViewItem lvi in listViewToken.SelectedItems)  //选中项遍历
            {
                listViewToken.Items.RemoveAt(lvi.Index); // 按索引移除
                //listView1.Items.Remove(lvi);   //按项移除
            }

            //行高设置（利用imageList实现）
            ImageList imgList = new ImageList();
            imgList.ImageSize = new Size(1, 20);// 设置行高 20 //分别是宽和高
            listViewToken.SmallImageList = imgList; //这里设置listView的SmallImageList ,用imgList将其撑大

            //（6）清空
            //this.listViewToken.Clear();  //从控件中移除所有项和列（包括列表头）。
            //this.listViewToken.Items.Clear();  //只移除所有的项。
        }

    }
}
