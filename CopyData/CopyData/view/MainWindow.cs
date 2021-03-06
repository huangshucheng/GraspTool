﻿using System;
using System.Collections.Generic;
using LuaInterface;
using System.IO;
using System.Collections;
using System.Windows.Forms;
using System.Drawing;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using JinYiHelp;

namespace CopyData
{
    public partial class HccWindowdGraspTool
    {
        Dictionary<string, System.Timers.Timer> _timerDic = new Dictionary<string, System.Timers.Timer>();
        private int _logLineCountLimit = 1500; //日志限制行数
        private string _proxyLogUrl = "www.baidu.com";

        //c++ 的 dll接口导入到c#
        //https://www.cnblogs.com/skyfreedom/p/11773597.html
        //[DllImport(@"CppHelperDll.dll", EntryPoint = "initLua", CallingConvention = CallingConvention.Cdecl)]
        //static extern bool initLua(IntPtr luaState);

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
            _luaScript.RegisterFunction("StopAllTimer", this, GetType().GetMethod("StopAllTimer")); //停止所有定时器
            _luaScript.RegisterFunction("AddActivityToList", this, GetType().GetMethod("AddActivityToList")); //增加活动名称到列表
            _luaScript.RegisterFunction("SetActivitySelIndex", this, GetType().GetMethod("SetActivitySelIndex")); //设置下拉列表，选中某个下标
            _luaScript.RegisterFunction("IsOpenTipSound", this, GetType().GetMethod("IsOpenTipSound")); //获取是否有提示音
            _luaScript.RegisterFunction("IsAutoGraspCK", this, GetType().GetMethod("IsAutoGraspCK")); //是否自动抓取CK
            _luaScript.RegisterFunction("IsAutoDoAction", this, GetType().GetMethod("IsAutoDoAction")); //是否自动做任务
            _luaScript.RegisterFunction("SetAutoDoAction", this, GetType().GetMethod("SetAutoDoAction")); //设置是否自动做任务，是否选中
            _luaScript.RegisterFunction("IsShowOutLog", this, GetType().GetMethod("IsShowOutLog")); //是否显示输出日志
            _luaScript.RegisterFunction("GetReqDelayTime", this, GetType().GetMethod("GetReqDelayTime")); //获取延迟时间
            _luaScript.RegisterFunction("ClearOutLog", this, GetType().GetMethod("ClearOutLog")); //清理输出日志
            _luaScript.RegisterFunction("ShowQRCode", this, GetType().GetMethod("ShowQRCode")); //显示二维码
            _luaScript.RegisterFunction("GetQRCodeString", this, GetType().GetMethod("GetQRCodeString")); //获取生成二维码字符串
            _luaScript.RegisterFunction("SetQRCodeString", this, GetType().GetMethod("SetQRCodeString")); //清理二维码图片
            _luaScript.RegisterFunction("ClearQRCode", this, GetType().GetMethod("ClearQRCode")); //清理二维码图片
            _luaScript.RegisterFunction("SetIPText", this, GetType().GetMethod("SetIPText")); //设置IP文本显示
            _luaScript.RegisterFunction("SetLogLineCountLimie", this, GetType().GetMethod("SetLogLineCountLimie")); //设置日志行数限制
            _luaScript.RegisterFunction("GetProxyString", this, GetType().GetMethod("GetProxyString")); //获取代理IP文本内容
            _luaScript.RegisterFunction("SetProxyLinkUrl", this, GetType().GetMethod("SetProxyLinkUrl")); //设置日志显示连接
            _luaScript.RegisterFunction("SetKaBaoCount", this, GetType().GetMethod("SetKaBaoCount")); //设置卡包次数
            _luaScript.RegisterFunction("GetKaBaoCount", this, GetType().GetMethod("GetKaBaoCount")); //获取卡包次数
            _luaScript.RegisterFunction("SetActivityLink", this, GetType().GetMethod("SetActivityLink")); //设置活动链接
            _luaScript.RegisterFunction("GetActivityLink", this, GetType().GetMethod("GetActivityLink")); //获取活动链接
            _luaScript.RegisterFunction("SetActivityDesc", this, GetType().GetMethod("SetActivityDesc")); //设置活动简介
            _luaScript.RegisterFunction("SetUserInputText", this, GetType().GetMethod("SetUserInputText")); //设置用户输入内容
            _luaScript.RegisterFunction("GetUserInputText", this, GetType().GetMethod("GetUserInputText")); //获取用户输入内容

            //_luaScript.RegisterFunction("HttpRequestDirect", this, GetType().GetMethod("HttpRequestDirect")); //http请求同步

            //静态方法
            _luaScript.RegisterFunction("GetCurDir", null, typeof(LuaCall).GetMethod("GetCurDir")); //获取当前exe文件位置
            _luaScript.RegisterFunction("GetDeskTopDir", null, typeof(LuaCall).GetMethod("GetDeskTopDir")); //获取桌面位置
            //_luaScript.RegisterFunction("HttpRequest", null, typeof(LuaCall).GetMethod("HttpRequest")); //http请求同步
            _luaScript.RegisterFunction("HttpRequestAsync", null, typeof(LuaCall).GetMethod("HttpRequestAsync")); //http请求 异步
            _luaScript.RegisterFunction("PlayWAVSound", null, typeof(LuaCall).GetMethod("PlayWAVSound")); //播放音效
            _luaScript.RegisterFunction("GetLocalIP", null, typeof(LuaCall).GetMethod("GetLocalIP")); //获取本机IP接口
            _luaScript.RegisterFunction("CopyToClipBoard", null, typeof(LuaCall).GetMethod("CopyToClipBoard")); //设置到剪贴板
            _luaScript.RegisterFunction("GetClipBoardData", null, typeof(LuaCall).GetMethod("GetClipBoardData")); //获取剪贴板内容

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
            _luaScript.RegisterFunction("IsSubString", null, typeof(StringUtils).GetMethod("IsSubString")); //是否是字符串子串

            _luaScript.RegisterFunction("Base64Encode", null, typeof(StringUtils).GetMethod("Base64Encode")); //base64加密
            _luaScript.RegisterFunction("Base64Decode", null, typeof(StringUtils).GetMethod("Base64Decode")); //base64解密 
            _luaScript.RegisterFunction("MD5Encode", null, typeof(StringUtils).GetMethod("MD5Encode")); //md5加密
            _luaScript.RegisterFunction("Sha1Encode", null, typeof(StringUtils).GetMethod("Sha1Encode")); //sha1 加密
            _luaScript.RegisterFunction("String2Unicode", null, typeof(StringUtils).GetMethod("String2Unicode")); //字符转unicode
            _luaScript.RegisterFunction("Unicode2String", null, typeof(StringUtils).GetMethod("Unicode2String")); //Unicode转字符串
            _luaScript.RegisterFunction("IsJsonFormat", null, typeof(StringUtils).GetMethod("IsJsonFormat")); //是否json字符串

            registLuaFuncListView();
            registWebSocket();

            string exePath = System.AppDomain.CurrentDomain.SetupInformation.ApplicationBase;
            string scriptPath = "/resources/luaScript/main.lua";
            _luaScript.DoFile(exePath + scriptPath);
        }


        //test 按钮点击
        private void btnFinishCatch_Click(object sender, EventArgs e)
        {
            if (_luaScript.GetFunction("testCall") != null) {
                _luaScript.DoString("testCall()");
            }
            //var unicodeStr = "{"success":false,"message":"\u6d3b\u52a8\u5df2\u7ecf\u7ed3\u675f\u4e86\uff01","data":null,"status":null}";
            //var jsonSstr = "{"base_req":{"session_id":"330D ","fast":1}}";
            /*
            var fzy = "{\"base_req\":{\"session_id\":\"330DCGIlXYrp6NpJ3UI/b9KTlzOrspNDSVLPzIhhE+OjnOvaJSuXqmo9h8fQdajkuHNnZGd1pABTCnouepznVT+d7fxQqCE9eqNeCsAIbV1Kzs9FoUG65OQomAv3LGQ8wbjerDL3mjKYqeS56Ilzzw==\",\"fast\":1}}";
            var rrrr = System.Text.RegularExpressions.Regex.Unescape(fzy); //反转义
             rrrr = System.Text.RegularExpressions.Regex.Escape(fzy);// 转义 加 /
            Console.WriteLine(rrrr);
            */
        }

        /// ///////////////////////////////////
        /// 注册到lua的函数,lua调用
        /// //////////////////////////////////

        //设置IP文本显示
        public void SetIPText(string ipInfoText) {
            if (ipInfoText == null) {
                return;
            }
            text_box_ip_info.Text = ipInfoText;
        }

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
            if (string.IsNullOrEmpty(logStr)) {
                return;
            }
            if (richTextBoxLog != null){
                richTextBoxLog.AppendText(logStr + "\n");
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
            timer.Elapsed += delegate (object sender, System.Timers.ElapsedEventArgs e){
                try {
                    Action action = new Action(() => {
                        if (callback != null){
                            callback.Call();
                        }
                    });
                    this.BeginInvoke(action);
                } catch (Exception ex) {
                    Console.WriteLine("SetInterval error " + ex.Message);
                }
            };
            timer.Enabled = true;//开始触发
            string timerID = JinYiHelp.TimeHelp.TimeHelper.GetUnixTime();
            _timerDic.Add(timerID, timer);
            return timerID;
        }

        //删掉所有Timer定时器，timerIDExceptTable: 需要保留的timerID table
        public void StopAllTimer(LuaTable timerIDExceptTable = null) {
            try{
                List<string> timerIDList = new List<string>();

                if (timerIDExceptTable != null)
                {
                    List<string> notDeleteTimerIDList = new List<string>(); //不需要删掉的
                    if (timerIDExceptTable.Keys.Count > 0)
                    {
                        foreach (DictionaryEntry v in timerIDExceptTable)
                        {
                            string timerIDTmp = v.Value.ToString();
                            if (_timerDic.ContainsKey(timerIDTmp)){
                                //不需要删除的
                                notDeleteTimerIDList.Add(timerIDTmp);
                            }
                        }
                    }
                    foreach (var item in _timerDic)
                    {
                        string timerID = item.Key;
                        System.Timers.Timer timer = (System.Timers.Timer)item.Value;
                        if (!notDeleteTimerIDList.Contains(timerID))
                        { //需要删除的
                            if (timer != null)
                            {
                                timer.Stop();
                                timer.Close();
                                timerIDList.Add(timerID);
                            }
                        }
                    }
                }
                else
                {
                    foreach (var item in _timerDic)
                    {
                        string timerID = item.Key;
                        System.Timers.Timer timer = (System.Timers.Timer)item.Value;
                        if (timer != null)
                        {
                            timer.Stop();
                            timer.Close();
                            timerIDList.Add(timerID);
                        }
                    }
                }

                foreach (string timerIDStr in timerIDList) {
                    if (_timerDic.ContainsKey(timerIDStr)) {
                        _timerDic.Remove(timerIDStr);
                    }
                }
            }
            catch (Exception ex){
                Console.WriteLine("stopAllTimer error: " + ex.Message);
            }
        }

        //停止定时器,id: string 类型
        public bool StopTimer(string timerID) {
            try {
                if (_timerDic.ContainsKey(timerID)) {
                    var timer = _timerDic[timerID];
                    if (timer != null) {
                        _timerDic[timerID].Stop();
                        _timerDic[timerID].Close();
                    }
                    _timerDic.Remove(timerID);
                    return true;
                }
            } catch (Exception ex) {
                Console.WriteLine("StopTimer error: " + ex.Message);
            }
            return false;
        }

        //延时函数, delayTime:秒
        public void SetDelayTime(double delayTime, LuaFunction endFunc = null)
        {
            delayTime = delayTime * 1000;
            if (delayTime <= 0){
                if (endFunc != null){
                    endFunc.Call();
                }
                return;
            }
            System.Timers.Timer timer = new System.Timers.Timer();
            timer.AutoReset = true;//是否只触发一次
            timer.Interval = delayTime;//时间间隔
            timer.Elapsed += delegate (object sender, System.Timers.ElapsedEventArgs e){
                timer.Enabled = false;//停用触发
                timer.Stop();
                timer.Close();
                Action action = new Action(() => {
                    if (endFunc != null){
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

        //设置下拉列表，选中某个下标
        public void SetActivitySelIndex(int index) {
            if (index >= 0 && index < comboBoxActList.Items.Count) {
                comboBoxActList.SelectedIndex = index;
            }
        }
        //获取生成二维码字符串
        public string GetQRCodeString() {
            return richTextQRCode.Text;
        }

        //设置二维码字符串
        public void SetQRCodeString(string str) {
            if (str == null){
                return;
            }
            richTextQRCode.Text = str;
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

        //获取卡包次数
        public decimal GetKaBaoCount() {
            return numeric_kabao_count.Value;
        }

        //设置卡包次数
        public void SetKaBaoCount(int count) {
            numeric_kabao_count.Value = count;
        }

        //清理输出日志
        public void ClearOutLog()
        {
            if (richTextBoxLog != null)
                richTextBoxLog.Clear();
        }

        //限制日志行数，默认1500
        public bool SetLogLineCountLimie(int lineCount) {
            if (_logLineCountLimit <= 0 )
            {
                return false;
            }
            _logLineCountLimit = lineCount;
            return true;
        }

        //日志打印查找输出
        private void richTextBoxLogTextChanged(object sender, EventArgs e)
        {
            //限制行数
            if (this.richTextBoxLog.Lines.Length > _logLineCountLimit)
            {
                int moreLines = this.richTextBoxLog.Lines.Length - _logLineCountLimit;
                string[] lines = this.richTextBoxLog.Lines;
                Array.Copy(lines, moreLines, lines, 0, _logLineCountLimit);
                Array.Resize(ref lines, _logLineCountLimit);
                this.richTextBoxLog.Lines = lines;
            }
            richTextBoxLog.SelectionStart = richTextBoxLog.Text.Length;
            richTextBoxLog.ScrollToCaret();
        }

        //点击清理输出
        private void buttonClearLogClick(object sender, EventArgs e)
        {
            this.richTextBoxLog.Clear();
        }

        //获取代理IP文本
        public string GetProxyString() {
            return text_box_proxy_ip.Text;
        }

        //设置日志链接Url
        public void SetProxyLinkUrl(string url_str) {
            this._proxyLogUrl = url_str;
        }

        //设置是否自动做任务
        public void SetAutoDoAction(bool isAuto) {
            checkAutoDoAct.Checked = isAuto;
        }

        //获取活动链接
        public string GetActivityLink() {
            return richTextLink.Text;
        }

        //设置活动链接
        public void SetActivityLink(string linkStr) {
            richTextLink.Text = linkStr;
        }

        //设置活动简介文本
        public void SetActivityDesc(string descStr) {
            richTextDesc.Text = descStr;
        }

        //设置用户输入内容
        public void SetUserInputText(string inputText) {
            richTextInput.Text = inputText;
        }

        //获取用户输入内容
        public string GetUserInputText() {
            return richTextInput.Text;
        }

        /// ///////////////////////////////////
        /// 调用Lua函数
        /// //////////////////////////////////

        //点击生成二维码
        private void btnGenQRCode_Click(object sender, EventArgs e)
        {
            try
            {
                var func = _luaScript.GetFunction("onClickGenQRCode");
                if (func != null)
                {
                    _luaScript.DoString("onClickGenQRCode()");
                }
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
                var func = _luaScript.GetFunction("onClickStartDoAct");
                if (func != null)
                {
                    _luaScript.DoString("onClickStartDoAct()");
                }
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
                var func = _luaScript.GetFunction("onClickStopDoAct");
                if (func != null)
                {
                    _luaScript.DoString("onClickStopDoAct()");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("btnStopCatch_Click error >> " + ex.Message);
            }
        }

        //是否显示网络数据日志
        private void check_btn_log_CheckedChanged(object sender, EventArgs e)
        {
            try{
                var func = _luaScript.GetFunction("onCheckNetLog");
                if (func != null){
                    var bShowLog = check_btn_log.Checked == true ? "1" : "0";
                    _luaScript.DoString("onCheckNetLog(" + bShowLog + ")");
                }
            }
            catch (Exception ex){
                Console.WriteLine("check_btn_log_CheckedChanged error >> " + ex.Message);
            }
        }

        //修改了延迟时间
        private void numUDDelay_ValueChanged(object sender, EventArgs e)
        {
            try
            {
                var func = _luaScript.GetFunction("onDelayTimeChanged");
                if (func != null)
                {
                    var num = (NumericUpDown)sender;
                    var value = num.Value.ToString();
                    _luaScript.DoString("onDelayTimeChanged("+ value + ")");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("numUDDelay_ValueChanged error >> " + ex.Message);
            }
        }

        //选中列表元素
        private void comboBoxActList_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                var func = _luaScript.GetFunction("onSelectActivityFromList");
                if (func != null)
                {
                    int selectIndex = comboBoxActList.SelectedIndex + 1;
                    _luaScript.DoString("onSelectActivityFromList(" + selectIndex + ")");
                }
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
                var func = _luaScript.GetFunction("onSelectPlayCound");
                if (func != null)
                {
                    var checkBox = (CheckBox)sender;
                    string isCheckdStr = checkBox.Checked == true ? "true" : "false";
                    var doStirng = "onSelectPlayCound(" + isCheckdStr + ")";
                    _luaScript.DoString(doStirng);
                }
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
                var func = _luaScript.GetFunction("onSelectAutoGraspCk");
                if (func != null) {
                    var checkBox = (CheckBox)sender;
                    string isCheckdStr = checkBox.Checked == true ? "true" : "false";
                    var doStirng = "onSelectAutoGraspCk(" + isCheckdStr + ")";
                    _luaScript.DoString(doStirng);
                }
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
                var func = _luaScript.GetFunction("onSelectAutoDoAct");
                if (func != null)
                {
                    var checkBox = (CheckBox)sender;
                    string isCheckdStr = checkBox.Checked == true ? "true" : "false";
                    _luaScript.DoString("onSelectAutoDoAct(" + isCheckdStr + ")");
                }
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
                var func = _luaScript.GetFunction("onSelectShowOutLog");
                if (func != null)
                {
                    var checkBox = (CheckBox)sender;
                    string isCheckdStr = checkBox.Checked == true ? "true" : "false";
                    _luaScript.DoString("onSelectShowOutLog(" + isCheckdStr + ")");

                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("checkAutoGraspCk_CheckedChanged error >> " + ex.Message);
            }
        }

        //做选中任务
        private void btnCatchSel_Click(object sender, EventArgs e)
        {
            try
            {
                var func = _luaScript.GetFunction("onClickDoSelAction");
                if (func != null)
                {
                    _luaScript.DoString("onClickDoSelAction()");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("btnCatchSel_Click error >> " + ex.Message);
            }
        }

        //点击使用代理
        private void btn_use_proxy_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                var func = _luaScript.GetFunction("onClickUseProxy");
                if (func != null)
                {
                    var checkBox = (CheckBox)sender;
                    string isCheckdStr = checkBox.Checked == true ? "true" : "false";
                    var doStirng = "onClickUseProxy(" + isCheckdStr + ")";
                    _luaScript.DoString(doStirng);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("btn_use_proxy_CheckedChanged error >> " + ex.Message);
            }
        }

        //点击验证代理
        private void btn_proxy_check_Click(object sender, EventArgs e)
        {
            try
            {
                var func = _luaScript.GetFunction("onClickCheckProxy");
                if (func != null)
                {
                    var doStirng = "onClickCheckProxy()";
                    _luaScript.DoString(doStirng);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("btn_proxy_check_Click error >> " + ex.Message);
            }
        }

        //点击代理IP tab页
        private void tab_proxy_ip_Click(object sender, EventArgs e)
        {

        }

        //点击接码 tab页
        private void tab_jiema_Click(object sender, EventArgs e)
        {

        }

        //点击查看网页日志
        private void text_link_label_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            try {
                this.text_link_label.Links[0].LinkData = this._proxyLogUrl;
                System.Diagnostics.Process.Start(e.Link.LinkData.ToString());
            } catch (Exception ex) {
                Console.WriteLine("text_link_label_LinkClicked error: " + ex.Message);
            }
        }
        
        //拷贝活动链接
        private void btnCopyLink_Click(object sender, EventArgs e)
        {
            try
            {
                var func = _luaScript.GetFunction("onClickCopyActivityLink");
                if (func != null)
                {
                    var doStirng = "onClickCopyActivityLink()";
                    _luaScript.DoString(doStirng);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("btnCopyLink_Click error: " + ex.Message);
            }
        }
    }
}
