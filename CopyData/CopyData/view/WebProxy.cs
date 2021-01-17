using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Drawing;
using System.Windows.Forms;
//using Titanium.Web.Proxy;
//using Titanium.Web.Proxy.Http;
using System.Net;
//using Titanium.Web.Proxy.EventArguments;
//using Titanium.Web.Proxy.Models;
//using System.Collections.ObjectModel;
//using Titanium.Web.Proxy.Helpers;

//TODO 不能监听手机端消息
//偶先监听不到resBody情况
//https://github.com/justcoding121/Titanium-Web-Proxy

namespace CopyData
{
    public partial class HccWindowdGraspTool
    {
        //int EXPLICIT_PORT = 8111;
       // int TRANSPARENT_PORT = 8112;

        /*
        private ProxyServer proxyServer;
        private ExplicitProxyEndPoint explicitEndPoint;

        public void testWebProxy() {
            //initHttpProxy();
            //startHttpProsy();
            //stopHttpProxy();
        }

        //设置代理，增加监听事件
        private void initHttpProxy() {
            Console.WriteLine("start http proxy!!");
            proxyServer = new ProxyServer();

            // 此代理使用的本地信任根证书 
            //proxyServer.CertificateManager.TrustRootCertificate(true);
            proxyServer.CertificateManager.CertificateEngine = Titanium.Web.Proxy.Network.CertificateEngine.DefaultWindows;
            proxyServer.CertificateManager.EnsureRootCertificate();

            proxyServer.TcpTimeWaitSeconds = 10;
            proxyServer.ConnectionTimeOutSeconds = 15;
            proxyServer.ReuseSocket = false;
            proxyServer.EnableConnectionPool = false;
            proxyServer.ForwardToUpstreamGateway = true;
            proxyServer.CertificateManager.SaveFakeCertificates = true;
        }

        public void startHttpProsy() {
            // 可选地设置证书引擎
            proxyServer.BeforeRequest += OnRequest;
            proxyServer.BeforeResponse += OnBeforeResponse;
            proxyServer.AfterResponse += OnAfterResponse;
            proxyServer.ServerCertificateValidationCallback += OnCertificateValidation;
            proxyServer.ClientCertificateSelectionCallback += OnCertificateSelection;

            explicitEndPoint = new ExplicitProxyEndPoint(IPAddress.Any, EXPLICIT_PORT, true)
            {
                // 在所有https请求上使用自颁发的通用证书
                // 通过不为每个启用http的域创建证书来优化性能
                // 当代理客户端不需要证书信任时非常有用
                //GenericCertificate = new X509Certificate2(Path.Combine(System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location), "genericcert.pfx"), "password")
            };

            // 当接收到连接请求时触发
            explicitEndPoint.BeforeTunnelConnectRequest += OnBeforeTunnelConnectRequest;

            // explicit endpoint 是客户端知道代理存在的地方
            // 因此，客户端以代理友好的方式发送请求
            proxyServer.AddEndPoint(explicitEndPoint);
            proxyServer.Start();

            // 透明endpoint 对于反向代理很有用(客户端不知道代理的存在)
            // 透明endpoint 通常需要一个网络路由器端口来转发HTTP(S)包或DNS
            // 发送数据到此endpoint 
            var transparentEndPoint = new TransparentProxyEndPoint(IPAddress.Any, TRANSPARENT_PORT, true)
            {
                // 要使用的通用证书主机名,当SNI被客户端禁用时
                GenericCertificateName = "google.com"
            };

            proxyServer.AddEndPoint(transparentEndPoint);
            //proxyServer.UpStreamHttpProxy = new ExternalProxy() { HostName = "localhost", Port = 8888 };
            //proxyServer.UpStreamHttpsProxy = new ExternalProxy() { HostName = "localhost", Port = 8888 };

            foreach (var endPoint in proxyServer.ProxyEndPoints)
            {
                Console.WriteLine("Listening on '{0}' endpoint at Ip {1} and port: {2} ", endPoint.GetType().Name, endPoint.IpAddress, endPoint.Port);
            }

            // 只有显式代理可以设置为系统代理!
            if (RunTime.IsWindows)
            {
                //proxyServer.SetAsSystemHttpProxy(explicitEndPoint);
                proxyServer.SetAsSystemProxy(explicitEndPoint, ProxyProtocolType.AllHttp);
            }

        }

        // 停止使用代理（如果直接关掉软件的话，代理不会自动去掉，无法上网）
        public void stopHttpProxy() {
            explicitEndPoint.BeforeTunnelConnectRequest -= OnBeforeTunnelConnectRequest;
            proxyServer.BeforeRequest -= OnRequest;
            proxyServer.BeforeResponse -= OnBeforeResponse;
            proxyServer.AfterResponse -= OnAfterResponse;
            proxyServer.ServerCertificateValidationCallback -= OnCertificateValidation;
            proxyServer.ClientCertificateSelectionCallback -= OnCertificateSelection;
            proxyServer.Stop();
        }

        //请求时出发
        public async Task OnRequest(object sender, SessionEventArgs e)
        {
            string method = e.HttpClient.Request.Method.ToUpper();
            //if (method == "GET" || method == "POST" || method == "PUT" || method == "PATCH")
            {
                if (e.HttpClient.Request.HasBody) {
                    
                    byte[] bodyBytes = await e.GetRequestBody();
                    e.SetRequestBody(bodyBytes);
                    
                    string bodyString = await e.GetRequestBodyAsString();
                    e.SetRequestBodyString(bodyString);
                    
                    // 这样设置后，能从响应处理器中找到它
                    //e.UserData = e.HttpClient.Request;
                }
            }
        }

        //返回时触发
        public async Task OnBeforeResponse(object sender, SessionEventArgs e)
        {

            string method = e.HttpClient.Request.Method.ToUpper();
            HeaderCollection requestHeaders = e.HttpClient.Request.Headers;
            ReadOnlyDictionary<string, HttpHeader> hds = requestHeaders.Headers;
            //Console.WriteLine("hcc>>OnRequest: url: " + e.HttpClient.Request.Url);
            Console.WriteLine("hcc>>OnRequest: host: " + e.HttpClient.Request.Host + " ,Method: " + method);
            Console.WriteLine("hcc>>Header: " + e.HttpClient.Request.HeaderText);

           // if (method == "GET" || method == "POST" || method == "PUT" || method == "PATCH")
            {
                try
                {
                    if (e.HttpClient.Request.HasBody)
                    {
                        var reqbody = await e.GetRequestBodyAsString();
                        Console.WriteLine("reqBody>>>: " + reqbody);
                    }

                    var respObj = e.HttpClient.Response;
                    //if (respObj != null && respObj.StatusCode == (int)HttpStatusCode.OK)
                    if (respObj != null && respObj.StatusCode == (int)HttpStatusCode.OK && respObj.HasBody)
                        {
                        string respTrim = respObj.ContentType.Trim().ToLower();
                        if (respObj.ContentType != null && respObj.ContentLength > 0)
                        {
                            //if (respTrim.Contains("text") || respTrim.Contains("html") || respTrim.Contains("json") || respTrim.Contains("xml") || respTrim.Contains("xhtml"))
                            {
                                string resBody = await e.GetResponseBodyAsString();
                                Console.WriteLine("resBody>>>: " + resBody);
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("OnAfterResponse>>error>>>> " + ex.Message);
                }
            }


            if (e.UserData != null)
            {
                // 从存储在RequestHandler中的UserData属性的访问请求
               // var request = (Request)e.UserData;
            }
        }

        public async Task OnAfterResponse(object sender, SessionEventArgs e)
        {
        }

        // 允许重写默认的证书验证逻辑
        public Task OnCertificateValidation(object sender, CertificateValidationEventArgs e)
        {
            // 根据证书错误，设置IsValid为真/假
            if (e.SslPolicyErrors == System.Net.Security.SslPolicyErrors.None)
                e.IsValid = true;

            return Task.CompletedTask;
        }

        // 允许在相互身份验证期间重写默认客户端证书选择逻辑
        public Task OnCertificateSelection(object sender, CertificateSelectionEventArgs e)
        {
            return Task.CompletedTask;
        }

        // 当接收到连接请求时触发
        private async Task OnBeforeTunnelConnectRequest(object sender, TunnelConnectSessionEventArgs e)
        {
            string hostname = e.HttpClient.Request.RequestUri.Host;

            if (hostname.Contains("dropbox.com"))
            {
                // 排除您不想代理的Https地址
                // 对于使用证书固定的客户端很有用
                // for example dropbox.com
                e.DecryptSsl = false;
            }
        }
        */
    }
}
