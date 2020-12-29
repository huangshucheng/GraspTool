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
        public enum Method {GET,POST}                   // HTTP请求方式
        private HttpWebRequest  _request;               // 请求对象
        private HttpWebRequest  _defaultHeaderRequest;  // 默认请求对象
        private Encoding        _postEncoding           = Encoding.UTF8; // 请求体编码格式
        private Encoding        _responseEncoding       = Encoding.UTF8; // 返回体编码格式
        private WebHeaderCollection _headers            = new WebHeaderCollection();   //自定义请求头
        private CookieContainer _cookieContainer        = new CookieContainer();       //cookie 容器
        private string          _customePostData;       // post data, 固定是放在body里面的
        private string          _baseUrl;               // https://+域名，例如: https://hbz.qrmkt.cn
        private string          _fullUrl;               // 全部url, 带urlBody,例如： https://hbz.qrmkt.cn/hbact/hyr/home/queryActCode
        private string          _urlBody;               // url 参数，追加在Url后面的，post,get都能用，格式：code=123&name=hcc&sex=1
        private string          _proxyAddress;          // 代理IP端口如：https://www.baidu.com:8080

        private EasyHttp(){
        }

        // 同步GET请求
        public string GetForString(){
            return Execute(Method.GET);
        }

        //异步GET
        public Task<string> GetForStringAsyc(){
            return ExecuteAsyc(Method.GET);
        }

        //同步POST
        public string PostForString(){
            return Execute(Method.POST);
        }

        //异步GET请求
        public Task<string> PostForStringAsyc(){
            return ExecuteAsyc(Method.POST);
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
            _baseUrl = tmpUri.Scheme + "://" + tmpUri.Host;
            initDefaultHeaderRequest();
        }

        //初始化默认参数
        private void initDefaultHeaderRequest() {
            SetDefaultContentType("application/x-www-form-urlencoded; charset=UTF-8");
            SetDefaultUserAgent("Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13G34 MicroMessenger/7.0.9(0x17000929) NetType/WIFI Language/zh_CN");
            SetDefaultAcceptEncoding("br, gzip, deflate");
            SetDefaultAcceptLanguage("zh-cn");
            SetDefaultAccept("application/json,text/javascript,text/html,text/plain,application/xhtml+xml,application/xml, */*; q=0.01");
            SetDefaultKeepAlive(false);
            SetDefaultTimeOut(5);
            SetDefaultAllowAutoRedirect(false);
        }

        //设置代理地址,如：http://proxy.domain.com:3128
        public void SetProxy(string address) {
            _proxyAddress = StringUtils.CheckIsWithHttp(address);
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
                _cookieContainer.Add(new Uri(_baseUrl), new Cookie(name, value));
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
                _request.ContentType = _headers[headerKey];  //TODO
            }
            else if (headerKey.Equals("Content-Length")) {
                //_request.ContentLength = long.Parse(_headers[headerKey]);
            }
            else if (headerKey.Equals("Connection")) {
                _request.KeepAlive = true;
            }
            else if (headerKey.Equals("Referer")) {
                _request.Referer = _headers[headerKey];
            }
        }

        //将_url从?后面删除掉
        //给_baseUrl赋值
        private void UrlToQuery(string url){
            Uri uri = new Uri(url);
            string query = uri.Query;
            if (!string.IsNullOrEmpty(query)){
                this._fullUrl = url.Remove(url.IndexOf('?'));
            }
            else {
                this._fullUrl = uri.ToString();
            }
            _baseUrl = uri.Scheme + "://" + uri.Host;
        }

        //同步执行Http请求，会卡住
        public string Execute(Method method){
            UrlToQuery(this._fullUrl);
            string tmpUrl = this._fullUrl;
            //URL追加body
            if (!string.IsNullOrEmpty(_urlBody)){
                tmpUrl = this._fullUrl + "?" + _urlBody;
            }
            System.GC.Collect();    //强制进行即时垃圾回收。
            _request = WebRequest.Create(tmpUrl) as HttpWebRequest;
            EasyHttpUtils.CopyHttpHeader(_defaultHeaderRequest, _request);
            _request.CookieContainer = _cookieContainer;
            WriteHeader();
            InitProxy();

            //get方式直接拼接url
            if (method == Method.GET){
                _request.Method = "GET";
            }
            else if (method == Method.POST)
            {
                _request.Method = "POST";
                if (!string.IsNullOrEmpty(_customePostData)){
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
                    _request.Abort();
                    _request = null;
                    responseStream.Close();
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
        public async Task<string> ExecuteAsyc(Method method){
            UrlToQuery(this._fullUrl);
            string tmpUrl = this._fullUrl;
            //URL追加body
            if (!string.IsNullOrEmpty(_urlBody)){
                tmpUrl = this._fullUrl + "?" + _urlBody;
            }
            System.GC.Collect();    //强制进行即时垃圾回收。
            _request = WebRequest.Create(tmpUrl) as HttpWebRequest;
            EasyHttpUtils.CopyHttpHeader(_defaultHeaderRequest, _request);
            _request.CookieContainer = _cookieContainer;
            WriteHeader();
            InitProxy();
            if (method == Method.GET){
                _request.Method = "GET";
            }
            else{
                _request.Method = "POST";
                //将postData 写入body,//处理请求参数
                if (!string.IsNullOrEmpty(_customePostData)) {
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
