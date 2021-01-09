using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Drawing;
using System.Windows.Forms;
using WebSocket4Net;
using SuperSocket.ClientEngine;

//webSocket for recv data
namespace CopyData
{
    public partial class HccWindowdGraspTool
    {
        
        private WebSocket _webSocket = null;
        private void initSocket() {
            Console.WriteLine("init webSocket!!");
            //var testUrl = "wss://socket.idcd.com:1443";
            var testUrl = "ws://127.0.0.1:8003";
            _webSocket = new WebSocket(testUrl);
            _webSocket.NoDelay = true;
            //_webSocket.AutoSendPingInterval = 1;
            _webSocket.EnableAutoSendPing = true;

            _webSocket.Opened += new EventHandler(websocket_Opened);
            _webSocket.Error += new EventHandler<ErrorEventArgs>(websocket_Error);
            _webSocket.Closed += new EventHandler(websocket_Closed);
            _webSocket.DataReceived += new EventHandler<DataReceivedEventArgs>(websocket_DataReceived);
            _webSocket.MessageReceived += new EventHandler<MessageReceivedEventArgs>(websocket_MessageReceived);
            _webSocket.Open();
        }

        private void websocket_Opened(object sender, EventArgs e)
        {
            _webSocket.Send("Hello World!");
            Console.WriteLine("cc>>websocket_Opened");
        }

        private void websocket_Error(object sender, EventArgs e)
        {
            Console.WriteLine("cc>>websocket_Error, e: " + e.ToString());
            
        }

        private void websocket_Closed(object sender, EventArgs e)
        {
            Console.WriteLine("cc>>websocket_Closed Code>> " + e.ToString());

        }

        private void websocket_DataReceived(object sender, DataReceivedEventArgs args)
        {
            var data = args.Data;
            Console.WriteLine("cc>>websocket_DataReceived");
        }

        private void websocket_MessageReceived(object sender, MessageReceivedEventArgs args)
        {
            var message = args.Message;
            Console.WriteLine("cc>>websocket_MessageReceived>> " + message);
        }

    }
}
