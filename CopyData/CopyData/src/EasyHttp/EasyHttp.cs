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
    string webUrl = "https://www.baidu.com";
    EasyHttp http = EasyHttp.With(webUrl);
    if (http != null){
        http.Data("code", "9405");//请求内容
        http.AddHeadersByDic(_reqHeaderDic);//添加请求头
        http.SetCookieHeader(cookie);//设置cookie
        var resStr = http.GetForString();//get请求
        var ret = http.GetForStringAsyc();//异步请求：
        var resStr = ret.Result;
    }
    */

    // 框架的核心类，自动处理cookie，并封装了很多简单的api
    public partial class EasyHttp
    {
        public enum Method {GET,POST}                   // HTTP请求方式
        private HttpWebRequest  _request;               // 请求对象
        private HttpWebResponse _response;              // 返回对象
        private HttpWebRequest  _defaultHeaderRequest;  // 默认请求对象
        private string          _customePostData;       // post data, 固定是放在body里面的
        private string          _baseUrl;               //
        private string          _url;                   //
        private string          _urlBody;               // url 参数，追加在Url后面的，post,get都能用，格式：code=123&name=hcc&sex=1
        private Encoding        _responseEncoding   = Encoding.UTF8;
        private Encoding        _postEncoding       = Encoding.UTF8;
        private WebHeaderCollection _headers        = new WebHeaderCollection();   //自定义请求头
        private CookieContainer _cookieContainer    = new CookieContainer();       //cookie 容器

        private EasyHttp(){
            
        }

        // 通过url开启一个EasyHttp
        public static EasyHttp With(string url)
        {
            if (StringUtils.CheckIsUrlFormat(url))
            {
                string tmpurl = StringUtils.CheckIsWithHttp(url);
                try
                {
                    //通过url创建一个全新无任何cookie的EasyHttp
                    EasyHttp http = new EasyHttp();
                    http.initNewRequest(tmpurl);
                    return http;
                }
                catch (Exception e)
                {
                    Console.WriteLine("url error:{0}" + e.Message);
                    return null;
                }
            }
            else
            {
                Console.WriteLine("error:url is empty or incorrect!");
                return null;
            }
        }

        // 重新定义一个网络请求，这个操作将会清空以前设定的参数
        // 创建一个新请求,并使用之前请求获取或者手动设置的Cookie，并在请求完后保存cookie
        private void initNewRequest(string url)
        {
            Uri tmpUri = new Uri(url);
            _url = tmpUri.ToString();
            if (_defaultHeaderRequest == null)
            {
                _defaultHeaderRequest = WebRequest.Create(this._url) as HttpWebRequest;
                _defaultHeaderRequest.ServicePoint.Expect100Continue = false;
            }
            _headers.Clear();
            _urlBody = null;
            _request = null;
            _response = null;
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

        //get CookieContainer
        public CookieContainer GetCookieContainer()
        {
            return _cookieContainer;
        }

        // get cookies as CookieHeader by url
        public string GetCookieHeaderByUrl(string url)
        {
            Uri uri = new Uri(url);
            return _cookieContainer.GetCookieHeader(uri);
        }

        // 获取http Header中cookie的值
        public string GetCookieHeader()
        {
            string url = string.Empty;
            if (_response == null)
                url = _baseUrl;
             else 
                url = _response.ResponseUri.Scheme + "://" + _response.ResponseUri.Host;
            return GetCookieHeaderByUrl(url);
        }

        // 添加一个cookie，之后可用添加的cookie来请求网页
        public EasyHttp AddCookie(string name, string value)
        {
            if(string.IsNullOrEmpty(name) || string.IsNullOrEmpty(value)){
                return this;
            }
            try
            {
                _cookieContainer.Add(new Uri(_baseUrl), new Cookie(name, value));
            }
            catch (Exception e)
            {
                Console.WriteLine("添加Cookie出错," + e.Message);
            }
            return this;
        }

        // 设置请求的Cookie，例如:a=avlue;c=cvalue
        public EasyHttp SetCookieHeader(string cookieHeader)
        {
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
                            AddCookie(key,value);
                        }
                    }
                }
            }
            return this;
        }

        //根据指定的方法，获取返回内容的stream
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

        //设定post数据的编码
        public void SetPostEncoding(Encoding encoding)
        {
            this._postEncoding = encoding;
        }

        //写进请求头，带请求头请求
        private void WriteHeader()
        {
            foreach (string key in _headers.AllKeys)
            {
                if (!WebHeaderCollection.IsRestricted(key))
                {
                    _request.Headers.Add(key, _headers[key]);
                    if (_request.Headers.Get(key) != null)
                        _request.Headers.Set(key,_headers[key]);
                }else
                {
                    SetRestrictedHeader(key);
                }
            }
        }

        //设置被限制的请求头（add或set没用的情况下）
        private void SetRestrictedHeader(string headerKey)
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
            }
            else if (headerKey.Equals("Accept"))
            {
                _request.Accept = _headers[headerKey];
            }
            else if (headerKey.Equals("Proxy-Connection"))
            {
            }
            else if (headerKey.Equals("Content-Type"))  
            {
                _request.ContentType = _headers[headerKey];  //TODO
            }
            else if (headerKey.Equals("Content-Length"))
            {
                //_request.ContentLength = long.Parse(_headers[headerKey]);
            }
            else if (headerKey.Equals("Connection"))
            {
                _request.KeepAlive = true;
            }
            else if (headerKey.Equals("Referer"))
            {
                _request.Referer = _headers[headerKey];
            }
        }

        //将_url从?后面删除掉
        private void UrlToQuery(string url)
        {
            Uri uri = new Uri(url);
            string query = uri.Query;
            if (!string.IsNullOrEmpty(query))
            {
                this._url = url.Remove(url.IndexOf('?'));
            }
            else {
                this._url = uri.ToString();
            }
            _baseUrl = uri.Scheme + "://" + uri.Host;
        }

        // 根据指定方法执行请求，并返回原始Response
        public HttpWebResponse Execute(Method method)
        {
            string url = string.Empty;
            //get方式直接拼接url
            if (method == Method.GET)
            {
                UrlToQuery(_url);
                url = this._url;
                //URL追加body
                if (!string.IsNullOrEmpty(_urlBody)){
                    url = this._url + "?" + _urlBody;
                }
                _request = WebRequest.Create(url) as HttpWebRequest;
                EasyHttpUtils.CopyHttpHeader(_defaultHeaderRequest, _request);
                _request.Method = "GET";
                _request.CookieContainer = _cookieContainer;
                WriteHeader();
            }
            else if (method == Method.POST)
            {
                UrlToQuery(_url);
                url = this._url;

                //URL追加body
                if (!string.IsNullOrEmpty(_urlBody))
                {
                    url = this._url + "?" + _urlBody;
                }

                _request = WebRequest.Create(url) as HttpWebRequest;
                _request.CookieContainer = _cookieContainer;
                _request.Method = "POST";
                EasyHttpUtils.CopyHttpHeader(_defaultHeaderRequest, _request);
                WriteHeader();

                if (!string.IsNullOrEmpty(_customePostData)){
                    using (var stream = _request.GetRequestStream())
                    {
                        byte[] postData = _postEncoding.GetBytes(_customePostData);
                        stream.Write(postData, 0, postData.Length);
                        stream.Close();
                    }
                }
            }
            try{
                _response = _request.GetResponse() as HttpWebResponse;
            }
            catch (WebException ex){
                Console.WriteLine("\n请求出错--------->:{0}"+ ex.Message);
                return null;
            }

            if(_response != null){
                _cookieContainer.Add(_response.Cookies);        //添加返回的cookie 到 cookieContainer
            }
            return _response;
        }

        //异步请求
        public async Task<string> ExecuteAsyc(Method method)
        {
            string url = string.Empty;
            if (method == Method.GET)
            {
                UrlToQuery(this._url);
                url = this._url;
                //URL追加body
                if (!string.IsNullOrEmpty(_urlBody)){
                    url = this._url + "?" + _urlBody;
                }
                _request = WebRequest.Create(url) as HttpWebRequest;
                EasyHttpUtils.CopyHttpHeader(_defaultHeaderRequest, _request);
                _request.Method = "GET";
                _request.CookieContainer = _cookieContainer;
                WriteHeader();
            }
            else if (method == Method.POST)
            {
                UrlToQuery(_url);
                url = this._url;

                //URL追加body
                if (!string.IsNullOrEmpty(_urlBody)){
                    url = this._url + "?" + _urlBody;
                }

                _request = WebRequest.Create(url) as HttpWebRequest; ;
                _request.CookieContainer = _cookieContainer;
                _request.Method = "POST";
                EasyHttpUtils.CopyHttpHeader(_defaultHeaderRequest, _request);
                WriteHeader();

                //将postData 写入body
                if (!string.IsNullOrEmpty(_customePostData)) {
                    //处理请求参数
                    var stream = await _request.GetRequestStreamAsync();
                    byte[] postData = _postEncoding.GetBytes(_customePostData);
                    stream.Write(postData, 0, postData.Length);
                    stream.Close();
                }
            }
            var ret = await SubmitRequestAsyc(_request);
            return ret;
        }

        //用_request 提交异步请求
        private async Task<string> SubmitRequestAsyc(HttpWebRequest request)
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
                return str;
            }
            catch (WebException ex)
            {
                Console.WriteLine("response error>>>>: " + ex.Message);
                _response = ex.Response as HttpWebResponse;
                if (_response != null)
                {
                    var str = EasyHttpUtils.ReadAllAsString(_response.GetResponseStream(), _responseEncoding);
                    statusCode = (ex.Response as HttpWebResponse).StatusCode;
                    return str;
                }
            }
            return string.Empty;
        }

        // 手动设置网页编码
        public EasyHttp SetResponseEncoding(Encoding responseEncoding)
        {
            _responseEncoding = responseEncoding;
            return this;
        }

        // 执行GET请求，获取返回的html
        public string GetForString()
        {
            var stream = ExecutForStream(Method.GET);
            string str = EasyHttpUtils.ReadAllAsString(stream, _responseEncoding);
            return str;
        }

        public Task<string> GetForStringAsyc()
        {
           return ExecuteAsyc(Method.GET);
        }

        // 执行Post请求，获取返回的html
        public string PostForString()
        {
            var str = EasyHttpUtils.ReadAllAsString(ExecutForStream(Method.POST), _responseEncoding);
            return str;
        }

        //异步请求
        public Task<string> PostForStringAsyc()
        {
            return ExecuteAsyc(Method.POST);
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
    }
}
