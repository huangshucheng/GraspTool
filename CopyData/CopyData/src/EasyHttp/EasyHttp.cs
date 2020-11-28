using System;
using System.CodeDom;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Drawing;
using System.IO;
using System.Net;
using System.Text;
using System.Web;
using System.Windows;
using System.IO.Compression;
using System.Threading.Tasks;

namespace CopyData
{
    /*
     简单使用：
            Dictionary<string, string> _reqHeaderDic = new Dictionary<string, string>();
            _reqHeaderDic.Add("Proxy-Connection", "keep-alive");
            _reqHeaderDic.Add("X-Requested-With", "XMLHttpRequest");
            _reqHeaderDic.Add("Accept-Encoding", "gzip, deflate");
            _reqHeaderDic.Add("Accept-Language", "zh-cn");
            _reqHeaderDic.Add("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");      //发送的数据格式
            _reqHeaderDic.Add("Connection", "keep-alive");
            _reqHeaderDic.Add("User-Agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13G34 MicroMessenger/6.6.1 NetType/WIFI Language/zh_CN");
            //test
            string webUrl = "https://www.baidu.com";
            EasyHttp http = EasyHttp.With(webUrl);
            if (http != null)
            {
                http.LogLevel(EasyHttp.EasyHttpLogLevel.Header);
                //http.Data("code", "9405");//请求内容
                http.AddHeadersByDic(_reqHeaderDic);//添加请求头
                //http.SetCookieHeader(cookie);//设置cookie
                
                //get请求
                var resStr = http.GetForString();
                _bgMeet.ReportProgress(100,StringUtils.UnicodeDencode(resStr));
                
               //异步请求：
               var ret = http.GetForStringAsyc();
                var resStr = ret.Result;
            }
     */
    /// 框架的核心类，自动处理cookie，并封装了很多简单的api
    public partial class EasyHttp
    {
        /// HTTP请求方式
        public enum Method {GET,POST,PUT,DELETE}
        //log方式
        public enum EasyHttpLogLevel {None,Header,Body,All}
        //body格式
        public enum BodyType {RAW,HTML,JSON,XML}
        private HttpWebRequest  _request;   
        private HttpWebResponse _response;
        private HttpWebRequest  _defaultHeaderRequest;
        private HttpWebRequest  _tempRequest;
        private string          _customePostData;
        private string          _baseUrl;
        private string          _url;
        private EasyHttpLogLevel _logLevel          = EasyHttpLogLevel.None;
        private EasyHttpLogLevel _defaultLogLevel   = EasyHttpLogLevel.None;
        private Encoding _responseEncoding          = Encoding.UTF8;
        //private Encoding _responseEncoding          = Encoding.Unicode;
        private bool _isMultpart                    = false;
        private Encoding _postEncoding              = Encoding.UTF8;
        private readonly WebHeaderCollection _headers        = new WebHeaderCollection();   //自定义请求头
        private readonly CookieContainer _cookieContainer    = new CookieContainer();       //cookie 容器
        private readonly WebHeaderCollection _defaultHeaders = new WebHeaderCollection();   //默认请求头
        private readonly List<KeyValue> _keyValues           = new List<KeyValue>();        //请求参数

        private EasyHttp()
        {
        }

        public string getResponseString(string rstr)
        {
            if(_response ==null || string.IsNullOrEmpty(rstr)){
                return string.Empty;
            }
            string contentType = _response.ContentType;
            Console.WriteLine("返回字符编码格式:" + contentType);
            if (contentType.IndexOf("application/json") > -1 || contentType.IndexOf("text/json") > -1)
            {
                return StringUtils.toJson(rstr);
            }
            else if (contentType.IndexOf("application/xml") > -1 || contentType.IndexOf("text/xml") > -1)
            {
                return StringUtils.toXml(rstr);
            }
            else
            {
                return StringUtils.toHtml(rstr);
            }
        }

        /// 以Multpart方式提交参数或文件
        public EasyHttp AsMultiPart()
        {
            _isMultpart = true;
            return this;
        }
        /// set LogLell
        public EasyHttp LogLevel(EasyHttpLogLevel logLevel)
        {
            _logLevel = logLevel;
            return this;
        }

        /// set default loglevl
        public EasyHttp DefaultLogLevel(EasyHttpLogLevel defaultLogLevel)
        {
            _logLevel = defaultLogLevel;
            _defaultLogLevel = defaultLogLevel;
            return this;
        }
        /// 获取当前网站的cookie
        public Dictionary<string, string> Cookies()
        {
            Dictionary<string,string> dic = new Dictionary<string, string>();
            var cookieCollection = _cookieContainer.GetCookies(new Uri(_baseUrl));
            foreach (Cookie c in cookieCollection)
            {
                if(!dic.ContainsKey(c.Name))
                    dic.Add(c.Name,c.Value);
                else
                    dic[c.Name] = c.Value;
            }
            return dic;
        }
        /// get CookieContainer
        public CookieContainer CookieContainer()
        {
            return _cookieContainer;
        }
        /// get cookies as CookieHeader by url
        public string CookieHeaderByUrl(string url)
        {
            Uri uri = new Uri(url);
            return _cookieContainer.GetCookieHeader(uri);
        }
        /// 获取http Header中cookie的值
        public string CookieHeader()
        {
            string url = string.Empty;
            if (_response == null)
                url = _baseUrl;
             else 
                url = _response.ResponseUri.Scheme + "://" + _response.ResponseUri.Host;
            return CookieHeaderByUrl(url);
        }
        /// 添加一个请求参数
        public EasyHttp Data(string key, string value)
        {
            KeyValue keyValue = new KeyValue(key, value);
            _keyValues.Add(keyValue);
            return this;
        }
        /// 获取请求的Cookie行
        public string RequestCookieHeader()
        {
            if (_request == null) return string.Empty;
            return _request.Headers["Cookie"];
        }

        public string ResponseCookieHeader()
        {
            if (_response == null) return string.Empty;
            return _response.Headers["Set-Cookie"];
        }
        /// 添加一个multipart内容
        public EasyHttp Data(string key, string fileName, string filePath)
        {
            _isMultpart = true;
            KeyValue multiPartContent = new KeyValue();
            multiPartContent.Key = key;
            multiPartContent.Value = fileName;
            multiPartContent.FilePath = filePath;
            _keyValues.Add(multiPartContent);
            return this;
        }
        /// 设置超时时间
        public EasyHttp TimeOut(int timeout)
        {
            _tempRequest.Timeout = timeout;
            return this;
        }
        /// 设置默认超时时间
        public EasyHttp DefaultTimeOut(int timeout)
        {
            _defaultHeaderRequest.Timeout = timeout;
            return this;
        }
        /// 添加一系列参数(body)
        public EasyHttp Data(List<KeyValue> keyValues)
        {
            this._keyValues.AddRange(keyValues);
            return this;
        }
        /// 重新定义一个网络请求，这个操作将会清空以前设定的参数
        public EasyHttp NewRequest(string url)
        {
            return NewRequest(new Uri(url));
        }
        /// 创建一个新请求,并使用之前请求获取或者手动设置的Cookie，并在请求完后保存cookie
        public EasyHttp NewRequest(Uri uri)
        {
            _url = uri.ToString();
            if (_defaultHeaderRequest == null)
            {
                _defaultHeaderRequest = WebRequest.Create(_url) as HttpWebRequest;
                _defaultHeaderRequest.ServicePoint.Expect100Continue = false;
            }
            _headers.Clear();
            _keyValues.Clear();
            _keyValues.Clear();
            _logLevel        = _defaultLogLevel;
            _isMultpart      = false;
            _customePostData = null;
            _baseUrl         = uri.Scheme+"://"+uri.Host;
            //创建temprequest
            _request        = null;
            _response       = null;
            _tempRequest    = WebRequest.Create(this._url) as HttpWebRequest;
            return this;
        }
        /// 通过url开启一个EasyHttp
        public static EasyHttp With(string url)
        {
            if (StringUtils.CheckIsUrlFormat(url))
            {
                string tu = StringUtils.CheckIsWithHttp(url);
                try {
                    Uri uri = new Uri(tu);
                    return With(uri);
                }
                catch(Exception e)
                {
                    Console.WriteLine("url error:{0}",e.Message);
                    return null;
                }
            }
            else{
                Console.WriteLine("error:url is empty or incorrect!");
                return null;
            }
        }
        /// 通过url创建一个全新无任何cookie的EasyHttp
        public static EasyHttp With(Uri url)
        {
            EasyHttp http = new EasyHttp();
            http.NewRequest(url);
            return http;
        }
        /// 获取请求的原始<see cref="HttpWebRequest"/>对象
        public HttpWebRequest Request()
        {
            return this._request ?? _tempRequest;
        }
        /// 获取请求的原始<see cref="HttpWebResponse"/>对象
        public HttpWebResponse Response()
        {
            return _response;
        }
        /// 添加一个cookie，之后可用添加的cookie来请求网页
        public EasyHttp Cookie(string name, string value)
        {
            if(string.IsNullOrEmpty(name) || string.IsNullOrEmpty(value)){
                return this;
            }
            try
            {
                System.Net.Cookie cookie = new Cookie();
                cookie.Name = name;
                cookie.Value = value;
                _cookieContainer.Add(new Uri(_baseUrl), cookie);
            }
            catch (Exception e)
            {
                Console.WriteLine("添加Cookie出错," + e.Message);
            }
            return this;
        }
        /// 设置请求的Cookie，例如:<c>a=avlue;c=cvalue</c>
        public EasyHttp SetCookieHeader(string cookieHeader)
        {
            //Console.WriteLine("\n请求cookies: ");
            if (string.IsNullOrEmpty(cookieHeader)) return this;
            var substr = cookieHeader.Split(';');
            foreach (string str in substr)
            {
                var cookieLines = str.Split(',');
                foreach (string cookieLine in cookieLines)
                {
                    if (cookieLine.Contains("="))
                    {
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
                            Cookie(key,value);
                        }
                    }
                }
            }
            return this;
        }
        /// 碰到302等状态时，是否自动转入新网址
        public EasyHttp AllowAutoRedirect(bool allowAutoRedirect)
        {
            _tempRequest.AllowAutoRedirect = allowAutoRedirect;
            return this;
        }
        //
        public EasyHttp DefaultAllowAutoRedirect(bool allowAutoRedirect)
        {
            _defaultHeaderRequest.AllowAutoRedirect = allowAutoRedirect;
            return this;
        }
        /// 根据指定的方法，获取返回内容的stream
        public Stream ExecutForStream(Method method)
        {
            HttpWebResponse webResponse = Execute(method);
            this._response = webResponse;
            if (webResponse != null){
                Stream responseStream = _response.GetResponseStream();
                if (_response.ContentEncoding.ToLower().Contains("gzip"))
                    responseStream = new GZipStream(responseStream, CompressionMode.Decompress);
                else if (_response.ContentEncoding.ToLower().Contains("deflate"))
                    responseStream = new DeflateStream(responseStream, CompressionMode.Decompress);
                return responseStream;
            }
            return null;
        }
        /// 设定post数据的编码
        public void PostEncoding(Encoding encoding)
        {
            this._postEncoding = encoding;
        }
        //写进请求头，带请求头请求
        private void WriteHeader()
        {
            Console.WriteLine("\n");
            foreach (string key in _defaultHeaders.AllKeys)
            {
                if (!WebHeaderCollection.IsRestricted(key))
                {
                    _request.Headers.Add(key, _defaultHeaders[key]);
                }
            }

            foreach (string key in _headers.AllKeys)
            {
                if (!WebHeaderCollection.IsRestricted(key))
                {
                    _request.Headers.Add(key, _headers[key]);
                    if (_request.Headers.Get(key) != null)
                        _request.Headers.Set(key,_headers[key]);
                }else
                {
                    setRestrictedHeader(key);
                }
            }
        }

        //设置被限制的请求头（add或set没用的情况下）
        private void setRestrictedHeader(string headerKey)
        {
            if (string.IsNullOrEmpty(headerKey))
            {
                return;
            }
            if (headerKey.Equals("User-Agent"))
            {
                _request.UserAgent = _headers[headerKey];
            }
            else if (headerKey.Equals("Host"))
            {
                //_request.Host = _headers[headerKey];  //会崩溃
            }
            else if (headerKey.Equals("Accept"))
            {
                _request.Accept = _headers[headerKey];
            }
            else if (headerKey.Equals("Proxy-Connection"))
            {
                //_request.Connection = _headers[headerKey];      //会崩溃
            }
            else if (headerKey.Equals("Content-Type"))
            {
                _request.ContentType = _headers[headerKey];
            }
            else if (headerKey.Equals("Content-Length"))
            {
                //_request.ContentLength = long.Parse(_headers[headerKey]);
            }
            else if (headerKey.Equals("Connection"))
            {
                //_request.Connection = _headers[headerKey];        //会崩溃 
                _request.KeepAlive = true;
            }
            else if (headerKey.Equals("Referer"))
            {
                _request.Referer = _headers[headerKey];
            }
        }

        //请求头被限制情况
        public static void SetHeaderValue(WebHeaderCollection header, string name, string value)
        {
            var property = typeof(WebHeaderCollection).GetProperty("InnerCollection",
                System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.NonPublic);
            if (property != null)
            {
                var collection = property.GetValue(header, null) as NameValueCollection;
                collection[name] = value;
            }
        }

        private void UrlToQuery(string url)
        {
            Uri uri = new Uri(url);
            string query = uri.Query;
            //分解query参数
            if (!string.IsNullOrEmpty(query))
            {
                NameValueCollection nameValueCollection = HttpUtility.ParseQueryString(query);
                foreach (string key in nameValueCollection.Keys)
                {
                    if (key == null) _keyValues.Add(new KeyValue(nameValueCollection[key], key));
                    else _keyValues.Add(new KeyValue(key, nameValueCollection[key]));
                }
                this._url = url.Remove(url.IndexOf('?'));
            }
            else 
                this._url = uri.ToString();
            _baseUrl = uri.Scheme + "://" + uri.Host;
        }
        /// 根据指定方法执行请求，并返回原始Response
        public HttpWebResponse Execute(Method method)
        {
            string url = string.Empty;
            //get方式直接拼接url
            if (method == Method.GET)
            {
                UrlToQuery(_url);
                url = this._url;
                if (_keyValues.Count > 0)
                {
                    //分解参数
                    url = url + "?" + EasyHttpUtils.NameValuesToQueryParamString(_keyValues);
                }
                _request = WebRequest.Create(url) as HttpWebRequest;
                EasyHttpUtils.CopyHttpHeader(_tempRequest,_defaultHeaderRequest, _request);
                _request.Method = "GET";
                _request.CookieContainer = _cookieContainer;
                WriteHeader();
            }
            //post方式需要写入
            else if (method == Method.POST)
            {
                url = _url;
                _request = _tempRequest;
                _request.CookieContainer = _cookieContainer;
                _request.Method = "POST";
                EasyHttpUtils.CopyHttpHeader(_tempRequest, _defaultHeaderRequest, _request);
                WriteHeader();
                if (_isMultpart)
                {
                    EasyHttpUtils.WriteFileToRequest(_request, _keyValues);
                }
                else
                {
                    if (string.IsNullOrEmpty(_request.ContentType))
                    {
                        _request.ContentType = "application/x-www-form-urlencoded; charset=UTF-8";
                    }
                    string querystring = EasyHttpUtils.NameValuesToQueryParamString(_keyValues);
                    if (_customePostData != null) 
                        querystring = _customePostData;
                    using (var stream = _request.GetRequestStream())
                    {
                        byte[] postData = _postEncoding.GetBytes(querystring);
                        stream.Write(postData, 0, postData.Length);
                        stream.Close();
                    }
                }
            }
            else if (method == Method.PUT)
            {
                UrlToQuery(_url);
                 url = this._url;
                if (_keyValues.Count > 0)
                {
                    url = url + "?" + EasyHttpUtils.NameValuesToQueryParamString(_keyValues);
                }
                _request = WebRequest.Create(url) as HttpWebRequest;
                _request.CookieContainer = _cookieContainer;
                
                WriteHeader();
                EasyHttpUtils.CopyHttpHeader(_tempRequest, _defaultHeaderRequest, _request);
                _request.Method = "PUT";
            }
            else if (method == Method.DELETE)
            {
                UrlToQuery(_url);
                 url = this._url;
                if (_keyValues.Count > 0)
                {
                    url = url + "?" + EasyHttpUtils.NameValuesToQueryParamString(_keyValues);
                }
                _request = WebRequest.Create(url) as HttpWebRequest;
                
                _request.CookieContainer = _cookieContainer;
                EasyHttpUtils.CopyHttpHeader(_tempRequest, _defaultHeaderRequest, _request);
                _request.Method = "DELETE";
                WriteHeader();
            }

            try{
                _response = _request.GetResponse() as HttpWebResponse;
            }
            catch (WebException ex){
                Console.WriteLine("\n请求出错--------->:{0}", ex.Message);
                return null;
            }

            if(_response != null){
                _cookieContainer.Add(_response.Cookies);        //添加返回的cookie 到 cookieContainer
            }
            if (_logLevel!= EasyHttpLogLevel.None){
                try{
                    LogRequet();
                    LogRespose();
                }
                catch (Exception e){
                    Console.WriteLine("\nlog出错:" + e.Message);
                }
            }
            return _response;
        }
        //异步请求
        public async Task<string> ExecuteAsyc(Method method)
        {
            string url = string.Empty;
            if (method == Method.GET)
            {
                UrlToQuery(_url);
                url = this._url;
                if (_keyValues.Count > 0) { 
                    url = url + "?" + EasyHttpUtils.NameValuesToQueryParamString(_keyValues);
                }
                _request = WebRequest.Create(url) as HttpWebRequest;
                EasyHttpUtils.CopyHttpHeader(_tempRequest, _defaultHeaderRequest, _request);
                _request.Method = "GET";
                _request.CookieContainer = _cookieContainer;
                WriteHeader();
            }
            else if (method == Method.POST)
            {
                url = _url;
                _request = _tempRequest;
                _request.CookieContainer = _cookieContainer;
                _request.Method = "POST";
                EasyHttpUtils.CopyHttpHeader(_tempRequest, _defaultHeaderRequest, _request);
                WriteHeader();
                if (_isMultpart)
                {
                    EasyHttpUtils.WriteFileToRequest(_request, _keyValues);
                }
                else
                {
                    if (string.IsNullOrEmpty(_request.ContentType))
                    {
                        _request.ContentType = "application/x-www-form-urlencoded; charset=UTF-8";
                    }
                    string querystring = EasyHttpUtils.NameValuesToQueryParamString(_keyValues);
                    //如果有自定义post内容，则写入自定义post数据，否则写入form（form优先）
                    if (!string.IsNullOrEmpty(_customePostData))
                        querystring = _customePostData;
                    //处理请求参数
                    using (var stream = _request.GetRequestStream())
                    {
                        byte[] postData = _postEncoding.GetBytes(querystring);
                        stream.Write(postData, 0, postData.Length);
                        stream.Close();
                    }
                }
            }
            return await submitRequestAsyc(_request);
        }
        //用_request 提交异步请求
        private async Task<string> submitRequestAsyc(HttpWebRequest request)
        {
            if (_request == null){
                return string.Empty;
            }
            HttpStatusCode statusCode = HttpStatusCode.NotFound;
            try {
                _response = (await request.GetResponseAsync()) as HttpWebResponse;
                Stream responseStream = _response.GetResponseStream();
                if (_response.ContentEncoding.ToLower().Contains("gzip"))
                    responseStream = new GZipStream(responseStream, CompressionMode.Decompress);
                else if (_response.ContentEncoding.ToLower().Contains("deflate"))
                    responseStream = new DeflateStream(responseStream, CompressionMode.Decompress);

                var str = EasyHttpUtils.ReadAllAsString(responseStream, _responseEncoding);
                statusCode = _response.StatusCode;
                _cookieContainer.Add(_response.Cookies);
                _response.Close();
                LogHtml(str);
                return StringUtils.UnicodeDencode(str);
            }
            catch (WebException ex)
            {
                _response = ex.Response as HttpWebResponse;
                if (_response != null)
                {
                    var str = EasyHttpUtils.ReadAllAsString(_response.GetResponseStream(), _responseEncoding);
                    statusCode = (ex.Response as HttpWebResponse).StatusCode;
                    LogHtml(str);
                    return StringUtils.UnicodeDencode(str);
                }
            }
            return string.Empty;
        }

        //打印请求参数
        private void LogRequestParams()
        {
            Console.WriteLine("\n");
            if (_keyValues.Count > 0)
            {
                foreach (KeyValue keyValue in _keyValues)
                {
                    Console.WriteLine("请求参数(Data)：{0} : {1} ", keyValue.Key, keyValue.Value);
                }
            }
            if (_customePostData != null)
            {
                Console.WriteLine("请求参数(custom)： " + _customePostData);
            }

            if (_keyValues.Count <= 0 && string.IsNullOrEmpty(_customePostData))
            {
                Console.WriteLine("无请求参数");
            }

        }
        //打印请求网页和请求头
        private void LogRequet()
        {
            if(_logLevel== EasyHttpLogLevel.None) return;
            Console.WriteLine("\n");
            Console.WriteLine("<<<--------请求网页-------->>>");
            Console.WriteLine("requestMethd: {0}, Url: {1}",_request.Method,_request.RequestUri); 

            if (_logLevel == EasyHttpLogLevel.Header || _logLevel==EasyHttpLogLevel.All)
            {
                var webHeaderCollection = _request.Headers;
                Console.WriteLine("<-----------请求头:----------->");
                foreach (string key in webHeaderCollection.Keys)
                {
                    Console.WriteLine("\t {0} : {1}",key,webHeaderCollection[key]);
                }
            }

            if (_logLevel == EasyHttpLogLevel.Body || _logLevel==EasyHttpLogLevel.All)
            {
                LogRequestParams();
            }
        }
        //打印返回
        private void LogRespose()
        {
            if (_logLevel == EasyHttpLogLevel.None) return;
            if (_logLevel == EasyHttpLogLevel.Header||_logLevel==EasyHttpLogLevel.All) {
                Console.WriteLine("\n");
                Console.WriteLine("<<<--------返回网页-------->>>");
                Console.WriteLine("Methd: {0}, Url: {1}, statusCode: {2}",_response.Method,_response.ResponseUri,_response.StatusCode);
                Console.WriteLine("<-----------返回头:----------->");
                if (_response == null) return;
                var webHeaderCollection = _response.Headers;
                foreach (string key in webHeaderCollection.Keys)
                {
                    Console.WriteLine("\t {0} : {1}", key, webHeaderCollection[key]);
                }
            }
        }
        /// 手动设置网页编码
        public EasyHttp ResponseEncoding(Encoding responseEncoding)
        {
            this._responseEncoding = responseEncoding;
            return this;
        }
        /// 执行GET请求，获取返回的html
        public string GetForString()
        {
            var stream = ExecutForStream(Method.GET);
            string str = EasyHttpUtils.ReadAllAsString(stream, _responseEncoding);
            LogHtml(str);
            return str;
        }
        public Task<string> GetForStringAsyc()
        {
           return ExecuteAsyc(Method.GET);
        }

        private bool IsResponseGzipCompress()
        {
            if (_response!= null && _response.ContentEncoding != null &&
                _response.ContentEncoding.Equals("gzip", StringComparison.InvariantCultureIgnoreCase))
            {
                return true;
            }
                return false;
        }
        /// 执行Post请求，获取返回的html
        public string PostForString()
        {
            var str = EasyHttpUtils.ReadAllAsString(ExecutForStream(Method.POST), _responseEncoding);
            LogHtml(str);
            return str;
        }
        //异步请求
        public Task<string> PostForStringAsyc()
        {
            return ExecuteAsyc(Method.POST);
        }

        /// 用指定的post内容执行post请求
        public string PostForString(string postData)
        {
            _customePostData = postData;
            var str = EasyHttpUtils.ReadAllAsString(ExecutForStream(Method.POST), _responseEncoding);
            LogHtml(str);
            return str;
        }
        //异步带参数
        public Task<string> PostForStringAsyc(string postData)
        {
            _customePostData = postData;
            return ExecuteAsyc(Method.POST);
        }

        /// 执行Put请求，获取返回的html
        public string PutForString()
        {
            var str = EasyHttpUtils.ReadAllAsString(ExecutForStream(Method.PUT), _responseEncoding);
            LogHtml(str);
            return str;
        }
        //打印html
        public void LogHtml(string html)
        {
            if (_logLevel == EasyHttpLogLevel.Body || _logLevel==EasyHttpLogLevel.All)
            {
                if (string.IsNullOrEmpty(html))
                {
                    Console.WriteLine("网页返回空");
                }
                else
                {
                    Console.WriteLine("\n");
                    Console.WriteLine("网页返回值:");
                    Console.WriteLine(StringUtils.UnicodeDencode(html));
                }
            }
        }
        /// 执行DELETE请求，获取返回的html
        public string DeleteForString()
        {
            return EasyHttpUtils.ReadAllAsString(ExecutForStream(Method.DELETE), _responseEncoding);
        }
        /// 执行Get请求，并把返回内容作为文件保存到指定路径
        public void GetForFile(string filePath)
        {
             ExecuteForFile(filePath, Method.GET);
        }
        /// 执行Post请求，并把返回内容作为文件保存到指定路径
        public void PostForFile(string filePath)
        {
             ExecuteForFile(filePath, Method.POST);
        }
        /// 执行Put请求，并把返回内容作为文件保存到指定路径
        public void PutForFile(string filePath)
        {
             ExecuteForFile(filePath, Method.PUT);
        }
        /// 执行Delete请求，并把返回内容作为文件保存到指定路径
        public void DeleteForFile(string filePath)
        {
             ExecuteForFile(filePath, Method.DELETE);
        }
        /// 以Get方式快速请求，舍弃返回内容
        public void GetForFastRequest()
        {
          ExecuteForFastRequest(Method.GET);
        }
        /// 以Post方法快速请求，舍弃返回内容
        public void PostForFastRequest()
        {
            ExecuteForFastRequest(Method.POST);
        }
        /// 以PUT方式快速请求，舍弃返回内容
        public void PutForFastRequest()
        {
            ExecuteForFastRequest(Method.PUT);
        }
        /// 以Delete方式快速请求，舍弃返回内容
        public void DeleteForFastRequest()
        {
            ExecuteForFastRequest(Method.DELETE);
        }
        ///以指定的Http Methond 执行快速请求，舍弃返回内容
        public void ExecuteForFastRequest(Method method)
        {
            var webResponse = Execute(method);
            _response = webResponse;
        }
        /// 执行指定方法的请求，将返回内容保存在指定路径的文件中
        public long ExecuteForFile(string filePath, Method method)
        {
            var stream = ExecutForStream(method);
            long total = _response.ContentLength;
            return EasyHttpUtils.ReadAllAsFile(stream, total, filePath);
        }
        /// 根据指定的方法执行请求，并把返回内容序列化为Image对象
        public Image ExecuteForImage(Method method)
        {
            Stream stream = ExecutForStream(method);
            return Image.FromStream(stream);
        }
        /// 执行Get方法，并把返回内容序列化为Image对象
        public Image GetForImage()
        {
            return ExecuteForImage(Method.GET);
        }
        /// 执行Post方法，并把返回内容序列化为Image对象
        public Image PostForImage()
        {
            return ExecuteForImage(Method.POST);
        }
        /// 执行Put方法，并把返回内容序列化为Image对象
        public Image PutForImage()
        {
            return ExecuteForImage(Method.PUT);
        }
        /// 执行Delete方法，并把返回内容序列化为Image对象
        public Image DeleteForImage()
        {
            return ExecuteForImage(Method.DELETE);
        }
    }
}
