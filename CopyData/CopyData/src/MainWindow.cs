using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using LuaInterface;
using System.IO;
using JinYiHelp.MediaHelp;

namespace CopyData
{
    public partial class HccWindowdGraspTool
    {
        //注册函数给lua使用
        void registLuaFunc()
        {
            //例：
            // 注册CLR对象方法到Lua，供Lua调用   typeof(TestClass).GetMethod("TestPrint")
            //lua.RegisterFunction("testLuaPrint", obj, obj.GetType().GetMethod("testLuaPrint"));
            // 注册CLR静态方法到Lua，供Lua调用
            //lua.RegisterFunction("testStaticLuaPrint", null, typeof(TestLuaCall).GetMethod("testStaticLuaPrint"));

            //类对象方法
            _luaScript.RegisterFunction("LogToken", this, GetType().GetMethod("LogToken")); //打印到token界面
            _luaScript.RegisterFunction("LogOut", this, GetType().GetMethod("LogOut")); //打印到输出界面
            _luaScript.RegisterFunction("LogLua", this, GetType().GetMethod("LogLua")); //打印到控制台
            _luaScript.RegisterFunction("GetFidderString", this, GetType().GetMethod("GetFidderString")); //传Fidder数据到lua
            _luaScript.RegisterFunction("SetTimeOut", this, GetType().GetMethod("SetTimeOut")); //延时函数

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

            string path = Environment.CurrentDirectory + "\\resources\\luaScript\\main.lua";
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
            //LuaCall.httpRequestAsync("www.baidu.com", 1,null,"","", "", null);
            //SetTimeOut(1);
            //var fileName = "hcc_test.json";
            //var curPath = LuaCall.GetCurDir() + "\\" + fileName;
            //LocalStorage.AppendText(curPath, "newlineasdfasdf");
            //LocalStorage.AppendLine(curPath, "newlineasdfasdf");

            //bool isSuccess = LocalStorage.WriteFile(fileName,"{hcc = you, 张双扣的了房间卡理发店}");
            //string content = LocalStorage.ReadFile(fileName);
            //Console.WriteLine(content);
            // var path = LuaCall.GetCurDir() + "\\resources\\sound\\ui_click.wav";
            //MediaHelper.ASyncPlayWAV(path);

            //var isEqual = StringUtils.StringCompare("中国人", "中国人啊");
            //Console.WriteLine(isEqual);
            //string str =  StringUtils.StringConvert("z看了决胜巅峰");
            //Console.WriteLine(str);
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

        // 导出给lua使用，打印字符串到token界面
        public void LogToken(string logStr)
        {
            if (richTextBoxFind != null)
            {
                if (!string.IsNullOrEmpty(logStr))
                {
                    richTextBoxFind.AppendText(logStr + "\n");
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

        //延时函数, delayTime:秒
        public void SetTimeOut(double delayTime, LuaFunction endFunc = null)
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
    }
}
