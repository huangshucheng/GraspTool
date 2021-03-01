using System;
using System.IO;
using System.Net;
using System.Text;
using System.IO.Compression;
using System.Threading.Tasks;

namespace CopyData
{
    public partial class EasyHttp
    {
        public enum Method {GET,POST,PUT,DELETE,OPTIONS}                   // HTTP请求方式
        private HttpWebRequest  _request;               // 请求对象
        private HttpWebRequest  _defaultHeaderRequest;  // 默认请求对象
        private Encoding        _postEncoding           = Encoding.UTF8; // 请求体编码格式
        private Encoding        _responseEncoding       = Encoding.UTF8; // 返回体编码格式
        private WebHeaderCollection _headers            = new WebHeaderCollection();   //自定义请求头
        private CookieContainer _cookieContainer        = new CookieContainer();       //cookie 容器
        private string          _customePostData;       // post data, 固定是放在body里面的
        private string          _fullUrl;               // 全部url, 带urlBody,例如： https://hbz.qrmkt.cn/hbact/hyr/home/queryActCode
        private string          _urlBody;               // url 参数，追加在Url后面的，post,get都能用，格式：code=123&name=hcc&sex=1
        private string          _proxyAddress;          // 代理IP端口如：https://www.baidu.com:8080

        private EasyHttp(){
        }

        // 同步请求
        public string GetForString(){
            return Execute(Method.GET);
        }

        public string PostForString(){
            return Execute(Method.POST);
        }

        public string PutForString(){
            return Execute(Method.PUT);
        }

        public string DeleteForString(){
            return Execute(Method.DELETE);
        }

        public string OptionsForString()
        {
            return Execute(Method.OPTIONS);
        }

        //异步请求
        public Task<string> GetForStringAsyc(){
            return ExecuteAsyc(Method.GET);
        }

        public Task<string> PostForStringAsyc(){
            return ExecuteAsyc(Method.POST);
        }

        public Task<string> PutForStringAsyc()
        {
            return ExecuteAsyc(Method.PUT);
        }

        public Task<string> DeleteForStringAsyc()
        {
            return ExecuteAsyc(Method.DELETE);
        }

        public Task<string> OptionsForStringAsyc()
        {
            return ExecuteAsyc(Method.OPTIONS);
        }

        // 通过url获取 一个EasyHttp对象
        public static EasyHttp With(string url){
            if (StringUtils.CheckIsUrlFormat(url)){
                string tmpurl = StringUtils.CheckIsWithHttp(url);
                try{
                    EasyHttp http = new EasyHttp();
                    http.initNewRequest(tmpurl);
                    return http;
                }
                catch (Exception e){
                    Console.WriteLine("url error:{0}" + e.Message);
                }
            }
            else{
                Console.WriteLine("error:url is empty or incorrect!");
            }
            return null;
        }

        // 重新定义一个网络请求，这个操作将会清空以前设定的参数
        // 创建一个新请求,并使用之前请求获取或者手动设置的Cookie，并在请求完后保存cookie
        private void initNewRequest(string url){
            Uri tmpUri = new Uri(url);
            this._fullUrl = tmpUri.ToString();
            if (_defaultHeaderRequest == null){
                _defaultHeaderRequest = WebRequest.Create(this._fullUrl) as HttpWebRequest;
                _defaultHeaderRequest.ServicePoint.Expect100Continue = false;
            }
            _headers.Clear();
            _urlBody = null;
            _request = null;
            _proxyAddress = null;
            _customePostData = null;
            initDefaultHeaderRequest();
        }

        //初始化默认参数
        private void initDefaultHeaderRequest() {
            //SetDefaultContentType("application/x-www-form-urlencoded; charset=UTF-8");
            //SetDefaultUserAgent("Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13G34 MicroMessenger/7.0.9(0x17000929) NetType/WIFI Language/zh_CN");
            //SetDefaultAcceptEncoding("br, gzip, deflate");
            //SetDefaultAcceptLanguage("zh-cn");
            //SetDefaultAccept("application/json,text/javascript,text/html,text/plain,application/xhtml+xml,application/xml, */*; q=0.01");
            SetDefaultAccept("*/*");
            //SetDefaultKeepAlive(false);
            SetDefaultTimeOut(60000); //默认60秒延迟
            SetDefaultAllowAutoRedirect(false);
        }

        //设置代理地址,如：http://proxy.domain.com:3128, 此方法自动给加上http://前缀
        public void SetProxy(string address) {
            if (address.Length < 8){
                _proxyAddress = address;
                return;
            }
            if ((address.Substring(0, 7) != "http://") && (address.Substring(0, 8) != "https://"))
            {
                address = "http://" + address;
            }
            _proxyAddress = address;
        }

        //初始化代理
        private void InitProxy() {
            try{
                if (!string.IsNullOrEmpty(_proxyAddress)){
                    if ("false".Equals(_proxyAddress)){ //关闭代理,即使FD也看不到日志
                        _request.Proxy = null;
                    }
                    else if ("true".Equals(_proxyAddress)){ //开启代理，默认开启不设置
                    }
                    else{
                        WebProxy proxy = new WebProxy();//指定的ip和端口
                        proxy.Address = new Uri(_proxyAddress);
                        _request.Proxy = proxy;
                    }
                }
            }
            catch (Exception e){
                Console.WriteLine("SetProxy error>> " + e.Message);
            }
        }

        //设置url参数,如：token=123&code=345
        public void SetUrlBody(string urlBody){
            _urlBody = urlBody;
        }

        //获取URL参数
        public string GetUrlBody() {
            return _urlBody;
        }

        //设置postBody参数，为字符串
        public void SetPostBody(string postBody) {
            _customePostData = postBody;
        }

        //获取postBody参数
        public string GetPostBody() {
            return _customePostData;
        }

        //设定post数据的编码
        public void SetPostEncoding(Encoding encoding){
            _postEncoding = encoding;
        }

        // 手动设置网页编码
        public void SetResponseEncoding(Encoding responseEncoding){
            _responseEncoding = responseEncoding;
        }

        // 添加一个cookie，之后可用添加的cookie来请求网页
        public void AddCookie(string name, string value){
            if(string.IsNullOrEmpty(name) || string.IsNullOrEmpty(value)){
                return;
            }
            try{
                _cookieContainer.Add(new Uri(this._fullUrl),new Cookie(name, value));
            }
            catch (Exception e){
                Console.WriteLine("添加Cookie出错," + e.Message);
            }
        }

        // 设置请求的Cookie，例如:a=avlue;c=cvalue
        public void SetCookieHeader(string cookieHeader){
            if (string.IsNullOrEmpty(cookieHeader)) return;
            var substr = cookieHeader.Split(';');
            foreach (string str in substr){
                var cookieLines = str.Split(',');
                foreach (string cookieLine in cookieLines){
                    if (cookieLine.Contains("=")){
                        var cookieKeyValue = cookieLine.Split('=');
                        var key = cookieKeyValue[0].Trim();
                        var value = cookieKeyValue[1].Trim();
                        var toLowerKey = key.ToLower();
                        if (toLowerKey != "expires" &&
                            toLowerKey != "path" && 
                            toLowerKey != "domain" && 
                            toLowerKey != "max-age"&& 
                            toLowerKey != "HttpOnly")
                        {
                            AddCookie(key,value);
                        }
                    }
                }
            }
        }

        //写进请求头，带请求头请求
        private void WriteHeader(){
            foreach (string key in _headers.AllKeys){
                if (!WebHeaderCollection.IsRestricted(key)){
                    _request.Headers.Add(key, _headers[key]);
                    if (_request.Headers.Get(key) != null)
                        _request.Headers.Set(key,_headers[key]);
                }else{
                    SetRestrictedHeader(key);
                }
            }
        }

        //设置被限制的请求头（add或set没用的情况下）
        private void SetRestrictedHeader(string headerKey){
            if (string.IsNullOrEmpty(headerKey)){
                return;
            }
            if (headerKey.Equals("User-Agent")) {
                _request.UserAgent = _headers[headerKey];
            }
            else if (headerKey.Equals("Host")) {
            }
            else if (headerKey.Equals("Accept")) {
                _request.Accept = _headers[headerKey];
            }
            else if (headerKey.Equals("Proxy-Connection")) {
            }
            else if (headerKey.Equals("Content-Type")) {
                _request.ContentType = _headers[headerKey];
            }
            else if (headerKey.Equals("Connection")) {
                _request.KeepAlive = true;
            }
            else if (headerKey.Equals("Referer")) {
                _request.Referer = _headers[headerKey];
            }
        }

        //同步执行Http请求，会卡住
        public string Execute(Method method){
            string tmpUrl = this._fullUrl;
            if (!string.IsNullOrEmpty(_urlBody)){
                if (tmpUrl.IndexOf("/?") > 0 || tmpUrl.IndexOf("?") > 0){
                    tmpUrl = this._fullUrl + "&" + _urlBody;
                }
                else{
                    tmpUrl = this._fullUrl + "?" + _urlBody;
                }
            }
            System.GC.Collect();    //强制进行即时垃圾回收。
            _request = WebRequest.Create(tmpUrl) as HttpWebRequest;
            EasyHttpUtils.CopyHttpHeader(_defaultHeaderRequest, _request);
            _request.CookieContainer = _cookieContainer;
            WriteHeader();
            InitProxy();

            if (method == Method.GET)
            {
                _request.Method = "GET";
            }
            else if (method == Method.POST)
            {
                _request.Method = "POST";
            }
            else if (method == Method.PUT)
            {
                _request.Method = "PUT";
            }
            else if (method == Method.DELETE)
            {
                _request.Method = "DELETE";

            }
            else if (method == Method.OPTIONS)
            {
                _request.Method = "OPTIONS";
            }

            if (method == Method.POST || method == Method.PUT || method == Method.DELETE || method == Method.OPTIONS)
            {
                if (!string.IsNullOrEmpty(_customePostData))
                {
                    using (var stream = _request.GetRequestStream())
                    {
                        byte[] postData = _postEncoding.GetBytes(_customePostData);
                        stream.Write(postData, 0, postData.Length);
                        stream.Close();
                    }
                }
            }

            HttpWebResponse tmpResponse = null;
            try{
                tmpResponse = _request.GetResponse() as HttpWebResponse;
                if (tmpResponse != null){
                    Stream responseStream = tmpResponse.GetResponseStream();
                    if (tmpResponse.ContentEncoding.ToLower().Contains("gzip")){
                        responseStream = new GZipStream(responseStream, CompressionMode.Decompress);
                    }else if (tmpResponse.ContentEncoding.ToLower().Contains("deflate")) {
                        responseStream = new DeflateStream(responseStream, CompressionMode.Decompress);
                    }
                    string retStr = EasyHttpUtils.ReadAllAsString(responseStream, _responseEncoding);
                    tmpResponse.Close();
                    tmpResponse = null;
                    responseStream.Close();
                    _request.Abort();
                    _request = null;
                    return retStr;
                }
            }
            catch (WebException ex){
                Console.WriteLine("Execute>>response error>>>>: " + ex.Message);
                tmpResponse = ex.Response as HttpWebResponse;
                if (tmpResponse != null){
                    string retStr = EasyHttpUtils.ReadAllAsString(tmpResponse.GetResponseStream(), _responseEncoding);
                    tmpResponse.Close();
                    tmpResponse = null;
                    _request.Abort();
                    _request = null;
                    return retStr;
                }
            }
            return string.Empty;
        }

        //异步请求，不会卡住UI
        public async Task<string> ExecuteAsyc(Method method) {
            string tmpUrl = this._fullUrl;
            //URL追加body
            if (!string.IsNullOrEmpty(_urlBody)) {
                if (tmpUrl.IndexOf("/?") > 0 || tmpUrl.IndexOf("?") > 0) {
                    tmpUrl = this._fullUrl + "&" + _urlBody;
                }
                else {
                    tmpUrl = this._fullUrl + "?" + _urlBody;
                }
            }
            System.GC.Collect();    //强制进行即时垃圾回收。
            _request = WebRequest.Create(tmpUrl) as HttpWebRequest;
            EasyHttpUtils.CopyHttpHeader(_defaultHeaderRequest, _request);
            _request.CookieContainer = _cookieContainer;
            WriteHeader();
            InitProxy();

            if(method == Method.GET){
                _request.Method = "GET";
            }
            else if(method == Method.POST){
                _request.Method = "POST";
            }
            else if(method == Method.PUT){
                _request.Method = "PUT";
            }
            else if(method == Method.DELETE) {
                _request.Method = "DELETE";

            } else if(method == Method.OPTIONS) {
                _request.Method = "OPTIONS";
            }

            if (method == Method.POST || method == Method.PUT || method == Method.DELETE || method == Method.OPTIONS) {
                if (!string.IsNullOrEmpty(_customePostData))
                {
                    var stream = await _request.GetRequestStreamAsync();
                    byte[] postData = _postEncoding.GetBytes(_customePostData);
                    stream.Write(postData, 0, postData.Length);
                    stream.Close();
                }
            }

            HttpWebResponse tmpResponse = null;
            try{
                tmpResponse = (await _request.GetResponseAsync()) as HttpWebResponse;
                if (tmpResponse != null) {
                    Stream responseStream = tmpResponse.GetResponseStream();
                    if (tmpResponse.ContentEncoding.ToLower().Contains("gzip")){
                        responseStream = new GZipStream(responseStream, CompressionMode.Decompress);
                    }else if (tmpResponse.ContentEncoding.ToLower().Contains("deflate")) {
                        responseStream = new DeflateStream(responseStream, CompressionMode.Decompress);
                    }
                    string retStr = EasyHttpUtils.ReadAllAsString(responseStream, _responseEncoding);
                    tmpResponse.Close();
                    tmpResponse = null;
                    responseStream.Close();
                    _request.Abort();
                    _request = null;
                    return retStr;
                }
            }
            catch (WebException ex){
                Console.WriteLine("response error>>>>: " + ex.Message);
                tmpResponse = ex.Response as HttpWebResponse;
                if (tmpResponse != null){
                    string retStr = EasyHttpUtils.ReadAllAsString(tmpResponse.GetResponseStream(), _responseEncoding);
                    tmpResponse.Close();
                    tmpResponse = null;
                    _request.Abort();
                    _request = null;
                    return retStr;
                }
            }
            return string.Empty;
        }
    }
}
