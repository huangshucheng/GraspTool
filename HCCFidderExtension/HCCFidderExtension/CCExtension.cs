using System;
using Fiddler;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using System.Diagnostics;

namespace HCCFidderExtension
{

    public class CCExtension: IFiddlerExtension,IAutoTamper
    {
        public void OnLoad() { 
            TabPage page = new TabPage("解包工具");
            FiddlerApplication.UI.tabsViews.TabPages.Add(page);
            FiddlerApplication.DoNotifyUser("抓包快乐！","欢迎你！");
        }

        public void OnBeforeUnload() { 
            
        }

        public void AutoTamperRequestBefore(Session onSession) {
        }

        public void AutoTamperRequestAfter(Session onSession)
        {
        }

        public void AutoTamperResponseBefore(Session onSession)
        {
            sendSessionDataToFidder(onSession);
        }

        public void AutoTamperResponseAfter(Session onSession)
        {
            
        }

        public void OnBeforeReturningError(Session onSession)
        { 
            
        }

        public void sendSessionDataToFidder(Session onSession)
        {
            string host = onSession.host;
            string fullUrl = onSession.fullUrl;
            string reqBody = onSession.GetRequestBodyAsString();
            string resBody = onSession.GetResponseBodyAsString();

            string reqHeader = onSession.RequestHeaders.ToString(true, true, true);
            string resHeader = onSession.ResponseHeaders.ToString(true, true);

            FiddlerObject.log("<<<<<<<<<<<<<<<【" + host + "】<<<<<<<<<<<<<<<<<start");
            //FiddlerObject.log("hcc>>host: " + host);
            //FiddlerObject.log("hcc>>path: " + path);
            //FiddlerObject.log("hcc>>mthd: " + mthd);
            //FiddlerObject.log("hcc>>reqHeader:  " + reqHeader);
            //FiddlerObject.log("hcc>>resHeader:  " + resHeader);
            //FiddlerObject.log("hcc>>reqBody: " + reqBody);
            //FiddlerObject.log("hcc>>resBody: " + resBody);
            FiddlerObject.log(reqHeader + "\n");
            FiddlerObject.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>end\n");

            string dataHeader = "\n" + "[reqHeader<" + host + ">] \n" + reqHeader;
            string dataReqBody = "\n" + "[reqBody<" + host + ">] \n" + reqBody;
            string dataResHeader = "\n" + "[resHeader<" + host + ">] \n" + resHeader;
            string dataResBody = "\n" + "[resBody<" + host + ">] \n" + resBody + "\n";

            string tmpReqBody = string.IsNullOrEmpty(reqBody) ? "" : "[postBody]\n" + reqBody + "\n";
            string tmpResBody = string.IsNullOrEmpty(resBody) ? "" : "[resBody]\n" + resBody + "\n";
            string allAppendString = DateTime.Now.ToString("yyyy-MM-dd") + " " + DateTime.Now.ToString("hh:mm:ss") + "\n"
                                    + "[host<" + host + ">]\n"
                                    + "[url] " + fullUrl + "\n"
                                    + "[method] " + onSession.RequestMethod + "\n"
                                    + tmpReqBody
                                    + tmpResBody;

            Process[] processes = Process.GetProcesses();
            foreach (Process p in processes)
            {
                try
                {
                    //这两个进程的某些属性一旦访问就抛出没有权限的异常
                    if (p.ProcessName != "System" && p.ProcessName != "Idle")
                    {
                        //if (p.ProcessName == "HccWindowdGraspTool.vshost" || p.ProcessName == "HccWindowdGraspTool") //
                        if (p.ProcessName.Contains("HccWindowdGraspTool"))
                        {
                            //接收端的窗口句柄  
                            IntPtr hwndRecvWindow = p.MainWindowHandle;
                            //自己的进程句柄
                            //IntPtr hwndSendWindow = Process.GetCurrentProcess().Handle;
                            Send_message(hwndRecvWindow, dataHeader);
                            Send_message(hwndRecvWindow, dataReqBody);
                            Send_message(hwndRecvWindow, dataResHeader);
                            //Send_message(hwndRecvWindow, dataResBody);
                            Send_message(hwndRecvWindow, allAppendString);
                        }
                    }
                }
                catch (Exception ex)
                {
                   // MessageBox.Show(ex.Message);
                }
            }
        
        }

        ///////////////////////////////////////////
        //数据发送给其他进程
        ///////////////////////////////////////////

        const int WM_COPYDATA = 0x004A;

        //启用非托管代码  
        [StructLayout(LayoutKind.Sequential)]
        public struct COPYDATASTRUCT
        {
            public IntPtr dwData;
            public int cData;
            [MarshalAs(UnmanagedType.LPStr)]
            public string lpData;
        }

        [DllImport("User32.dll", EntryPoint = "FindWindow")]
        private static extern int FindWindow(string lpClassName, string lpWindowName);

        [DllImport("Kernel32.dll", EntryPoint = "GetConsoleWindow")]
        public static extern IntPtr GetConsoleWindow();

        //系统SendMessage方法  SendMessage为阻塞方法
        [DllImport("User32.dll", EntryPoint = "SendMessage")]

        private static extern int SendMessage(
            IntPtr hWnd, // handle to destination window
            int Msg, // message
            int wParam, // first message parameter
            ref COPYDATASTRUCT lParam // second message parameter
        );

        //自己封装的方法
        public int Send_message(IntPtr handle, string message)
        {
            byte[] arr = System.Text.Encoding.Default.GetBytes(message);
            int len = arr.Length;
            COPYDATASTRUCT cdata;//打开结构体
            cdata.dwData = (IntPtr)100;//对结构体赋值
            cdata.lpData = message;//对结构体赋值
            cdata.cData = len + 1;//对结构体赋值
            return SendMessage(handle, WM_COPYDATA, 0, ref cdata);//调用SendMessage
        }
       
    }
}
