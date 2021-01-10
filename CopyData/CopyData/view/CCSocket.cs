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
        private void initSocket() {
            _webSocket = new HCCWebSocket("ws://127.0.0.1:8003");
            _webSocket._webSocketeEvent += (string message) => {
                if (richTextBoxLog.InvokeRequired) {
                    //利用代理操作UI
                    DataDelegateHander _myInvoke = new DataDelegateHander(setText);
                    this.Invoke(_myInvoke, new object[] {message});
                }
            };
        }

        //显示在 UI上
        private void setText(string sss) {
            LogOut(sss);
        }

    }
}
