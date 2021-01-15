using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Drawing;
using System.Windows.Forms;
using WebSocket4Net;
using SuperSocket.ClientEngine;
using System.IO.Compression;
using System.ComponentModel;

//webSocket
namespace CopyData
{
    

    public partial class HccWindowdGraspTool
    {
        private HCCWebSocket _webSocket = null;
        private string _webSocketDataCache = "";
        //test
        private void registWebSocket() {
            //var test_url = "ws://hccfun.com:8002/do-not-proxy";
            //_webSocket = new HCCWebSocket("ws://localhost:8005");//本地调试
            //_webSocket = new HCCWebSocket("ws://121.41.0.245:8005");//使用外网IP
            //_webSocket = new HCCWebSocket("ws://hccfun.com:8005"); //使用域名
            //_webSocket = new HCCWebSocket("ws://hccfun.com:8002/do-not-proxy"); //anyproxy 自带websocket端口
            /*
            _webSocket._webSocketeEvent += (string message) => {
                if (richTextBoxLog.InvokeRequired)
                {
                    //利用代理操作UI
                    //DataDelegateHander _myInvoke = new DataDelegateHander(setText);
                    //this.Invoke(_myInvoke, new object[] { message });
                }
                else {
                    //LogOut(message);
                }
            };
            */
            _luaScript.RegisterFunction("WebSocket_CreateSocket", this, GetType().GetMethod("WebSocket_CreateSocket"));
            _luaScript.RegisterFunction("WebSocket_SendMessage", this, GetType().GetMethod("WebSocket_SendMessage"));
            _luaScript.RegisterFunction("WebSocket_GetSocketData", this, GetType().GetMethod("WebSocket_GetSocketData")); //传webSocket数据到lua
            _luaScript.RegisterFunction("WebSocket_IsConnected", this, GetType().GetMethod("WebSocket_IsConnected"));
            _luaScript.RegisterFunction("WebSocket_DoReConnect", this, GetType().GetMethod("WebSocket_DoReConnect"));
            _luaScript.RegisterFunction("WebSocket_Close", this, GetType().GetMethod("WebSocket_Close"));
            //test
            //CreateWebSocket(test_url);
        }

        public string WebSocket_CreateSocket(string wsUrl) {
            if (_webSocket != null) {
                return "websocket is already created!";
            }
            _webSocket = new HCCWebSocket(wsUrl);
            var ret_str = _webSocket.StartSocket();
            _webSocket._webSocketeEvent += (string message) => {
                this._webSocketDataCache = message;
                try{
                    var func = _luaScript.GetFunction("WebSocket_OnSocketData");
                    if (func != null) {
                        _luaScript.DoString("WebSocket_OnSocketData()");
                    }
                }catch (Exception ex){
                    Console.WriteLine("_webSocketeEvent error >> " + ex.Message);
                }
            };
            return ret_str;
        }

        public void WebSocket_SendMessage(string message) {
            if (_webSocket != null && !string.IsNullOrEmpty(message)){
                this._webSocket.WebSocket_SendMessage(message);
            }
        }

        public string WebSocket_GetSocketData() {
            return this._webSocketDataCache;
        }

        public bool WebSocket_IsConnected() {
            if (_webSocket == null) {
                return false;
            }
            return _webSocket.IsConnected();
        }

        public void WebSocket_DoReConnect() {
            if (_webSocket == null){
                return;
            }
            _webSocket.DoReConnect();
        }

        public void WebSocket_Close() {
            if (_webSocket == null){
                return;
            }
            _webSocket.Dispose();
        }

    }
}
