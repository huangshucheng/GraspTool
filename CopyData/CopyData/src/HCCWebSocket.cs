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

        Thread _thread = null;
        bool _isRunning = true;

        public HCCWebSocket(string url) {
            if (string.IsNullOrEmpty(url)){
                return;
            }
            try{
                _webSocket = new WebSocket(url);
                _webSocket.NoDelay = true;
                _webSocket.AutoSendPingInterval = 5;
                _webSocket.EnableAutoSendPing = true;

                _webSocket.Opened += new EventHandler(websocket_Opened);
                _webSocket.Error += new EventHandler<ErrorEventArgs>(websocket_Error);
                _webSocket.Closed += new EventHandler(websocket_Closed);
                _webSocket.DataReceived += new EventHandler<DataReceivedEventArgs>(websocket_DataReceived);
                _webSocket.MessageReceived += new EventHandler<MessageReceivedEventArgs>(websocket_MessageReceived);
                _webSocket.Open();
                Start();
            }
            catch (Exception ex)
            {
                Console.WriteLine("connectWebSocket error " + ex.Message);
                _webSocket = null;
            }
        }

        public bool Start()
        {
            bool result = true;
            try
            {
                this._isRunning = true;
                this._thread = new Thread(new ThreadStart(CheckConnection));
                this._thread.Start();
            }
            catch (Exception ex)
            {
               Console.WriteLine("webSocket start error " + ex.ToString());
                result = false;
            }
            return result;
        }

        // 检查重连线程
        private void CheckConnection()
        {
            do{
                try{
                    if (this._webSocket.State != WebSocket4Net.WebSocketState.Open && this._webSocket.State != WebSocket4Net.WebSocketState.Connecting)
                    {
                        Console.WriteLine(" Reconnect websocket WebSocketState: " + this._webSocket.State);
                        this._webSocket.Close();
                        this._webSocket.Open();
                        Console.WriteLine("正在重连...");
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.ToString());
                }
                System.Threading.Thread.Sleep(5000);
            } while (this._isRunning);
        }

        private void websocket_Opened(object sender, EventArgs e)
        {
            _webSocket.Send("Hello webSocket server!");
            //Console.WriteLine("cc>>websocket_Opened");
            _webSocketeEvent?.Invoke("wesocket opened");
        }

        private void websocket_Error(object sender, ErrorEventArgs e)
        {
            //Console.WriteLine("cc>>websocket_Error, e: " + e.ToString());
            _webSocketeEvent?.Invoke("wesocket error");
        }

        private void websocket_Closed(object sender, EventArgs e)
        {
            //Console.WriteLine("cc>>websocket_Closed Code>> " + e.ToString());
            _webSocketeEvent?.Invoke("wesocket closed");
        }

        private void websocket_DataReceived(object sender, DataReceivedEventArgs args)
        {
            var data = args.Data;
            var decodeData = Encoding.UTF8.GetString(data);
            if (decodeData != null){
                //Console.WriteLine("cc>>websocket_DataReceived decodeData:>> " + decodeData);
                _webSocketeEvent?.Invoke("wesocket data: " + decodeData);
            }
        }

        private void websocket_MessageReceived(object sender, MessageReceivedEventArgs args)
        {
            var message = args.Message;
            //Console.WriteLine("cc>>websocket_MessageReceived>> " + message);
            _webSocketeEvent?.Invoke("wesocket data: " + message);
        }

        public void websocket_SendMessage(string message) {
            Task.Factory.StartNew(() =>{
                if (_webSocket != null && _webSocket.State == WebSocket4Net.WebSocketState.Open){
                    this._webSocket.Send(message);
                }
            });
        }

        public void Dispose()
        {
            if (this._webSocket == null) {
                return;
            }
            this._isRunning = false;
            try{
                if (_thread != null) {
                    _thread.Abort();
                    _thread = null;
                }
                this._webSocket.Close();
                this._webSocket.Dispose();
                this._webSocket = null;
                _isRunning = false;
            }
            catch{
            }
        }
    }
}
