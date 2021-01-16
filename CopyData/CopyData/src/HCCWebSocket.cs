using System;
using System.Text;
using System.Threading.Tasks;
using WebSocket4Net;
using SuperSocket.ClientEngine;
using System.Threading;

namespace CopyData
{
    class HCCWebSocket
    {
        public event Action<string> _webSocketeEvent;
        private WebSocket _webSocket = null;
        private bool _webSocketIsConnected = false;
        private string _wsUrl = "";

        //构造，传入url
        public HCCWebSocket(string url) {
            this._wsUrl = url;
        }

        public string StartSocket() {
            if (string.IsNullOrEmpty(this._wsUrl)){
                return "create cc_websocket failed, url is null";
            }
            try
            {
                _webSocket = new WebSocket(this._wsUrl);
                _webSocket.NoDelay = true;
                _webSocket.AutoSendPingInterval = 5;
                _webSocket.EnableAutoSendPing = true;

                _webSocket.Opened += new EventHandler(WebSocket_Opened);
                _webSocket.Error += new EventHandler<ErrorEventArgs>(WebSocket_Error);
                _webSocket.Closed += new EventHandler(WebSocket_Closed);
                _webSocket.DataReceived += new EventHandler<DataReceivedEventArgs>(WebSocket_DataReceived);
                _webSocket.MessageReceived += new EventHandler<MessageReceivedEventArgs>(WebSocket_MessageReceived);
                _webSocket.Open();
            }
            catch (Exception ex)
            {
                _webSocket = null;
                return "create cc_websocket failed: " + ex.Message;
            }
            return "cc_websocket create success at: " + this._wsUrl;
        }

        //是否已经连接
        public bool IsConnected() {
            if (_webSocket == null) {
                return false;
            }
            if (this._webSocket.State != WebSocket4Net.WebSocketState.Open && this._webSocket.State != WebSocket4Net.WebSocketState.Connecting) {
                return false;
            }

            if (_webSocketIsConnected == false) {
                return false;
            }

            return true;
        }

        //重新连接
        public void DoReConnect() {
            if (IsConnected() == true) {
                return;
            }
            if (_webSocket == null) {
                return;
            }
            try{
                this._webSocket.Close();
                this._webSocket.Open();
            }
            catch (Exception ex){
                Console.WriteLine("webSocket doReConnect error >>" + ex.Message);
            }
        }

        //socket已经连接上
        private void WebSocket_Opened(object sender, EventArgs e)
        {
            //Console.WriteLine("cc>>websocket_Opened");
            _webSocketeEvent?.Invoke("{\"cc_websocket\" : \"socket_opend\"}");
            _webSocketIsConnected = true;
        }

        //发生错误
        private void WebSocket_Error(object sender, ErrorEventArgs e)
        {
           // Console.WriteLine("cc>>websocket_Error, e: " + e.ToString());
            _webSocketeEvent?.Invoke("{\"cc_websocket\" : \"socket_error\"}");
            _webSocketIsConnected = false;
        }

        //被动关闭
        private void WebSocket_Closed(object sender, EventArgs e)
        {
            //Console.WriteLine("cc>>websocket_Closed Code>> " + e.ToString());
            _webSocketeEvent?.Invoke("{\"cc_websocket\" : \"socket_closed\"}");
            _webSocketIsConnected = false;
        }

        //接收字节数据
        private void WebSocket_DataReceived(object sender, DataReceivedEventArgs args)
        {
            var data = args.Data;
            var decodeData = Encoding.UTF8.GetString(data);
            if (decodeData != null){
                _webSocketeEvent?.Invoke(decodeData);
            }
        }

        //接收字符串数据
        private void WebSocket_MessageReceived(object sender, MessageReceivedEventArgs args)
        {
            var message = args.Message;
            _webSocketeEvent?.Invoke(message);
        }

        //发送消息
        public void WebSocket_SendMessage(string message) {
            if (_webSocket != null && _webSocket.State == WebSocket4Net.WebSocketState.Open){
                this._webSocket.Send(message);
            }
        }

        //主动断开
        public void Dispose()
        {
            if (this._webSocket == null) {
                return;
            }
            try{
                this._webSocket.Close();
                this._webSocket.Dispose();
                this._webSocket = null;
                _webSocketIsConnected = false;
            }
            catch(Exception ex){
                Console.WriteLine("webSocket Dispose error >>" + ex.Message);
            }
        }
    }
}
