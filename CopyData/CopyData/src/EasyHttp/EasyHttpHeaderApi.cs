using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;

namespace CopyData
{
    public partial class EasyHttp
    {
        // 设置自定义头部键值对
        public EasyHttp AddHeaderCustome(string name, string value)
        {
            if(string.IsNullOrEmpty(name) || string.IsNullOrEmpty(value)){
                return this;
            }
            _headers.Add(name, value);
            return this;
        }

        public EasyHttp AddHeadersByDic(Dictionary<string, string> dic)
        {
            if(dic.Count() == 0 || dic == null){
                return this;
            }
            foreach (var item in dic)
            {
                AddHeaderCustome(item.Key, item.Value);
            }
            return this;
        }

        //获取或设置一个值，该值指示请求是否应跟随重定向响应。
        public EasyHttp SetDefaultAllowAutoRedirect(bool allowAutoRedirect)
        {
            _defaultHeaderRequest.AllowAutoRedirect = allowAutoRedirect;
            return this;
        }

        // 设置默认超时时间
        public EasyHttp SetDefaultTimeOut(int timeout)
        {
            _defaultHeaderRequest.Timeout = timeout;
            return this;
        }

        // 设置默认的UserAgent头，当没有设置UserAgent时(<see cref="UserAgent"/>),使用的UserAgent值
        public EasyHttp SetDefaultUserAgent(string userAgent)
        {
            _defaultHeaderRequest.UserAgent = userAgent;
            return this;
        }

        // 默认Refer值
        public EasyHttp SetDefaultReferer(string referer)
        {
            _defaultHeaderRequest.Referer = referer;
            return this;
        }

        // 设置请求的<c>Accept-Encoding</c>行的值 TODO
        public EasyHttp SetDefaultAcceptEncoding(string acceptEncoding)
        {
            return AddHeaderCustome("Accept-Encoding", acceptEncoding);
        }

        // 设置默认的<c>Accept-Language</c>的值 TODO
        public EasyHttp SetDefaultAcceptLanguage(string acceptLanguage)
        {
            return AddHeaderCustome("Accept-Language", acceptLanguage);
        }

        // 设置默认<c>Accept</c>值
        public EasyHttp SetDefaultAccept(string accept)
        {
            _defaultHeaderRequest.Accept = accept;
            return this;
        }
    
        // 设置默认请求的<c>Content-Type</c>值
        public EasyHttp SetDefaultContentType(string contentType)
        {
            _defaultHeaderRequest.ContentType = contentType;
            return this;
        }

        // 设置默认请求是否KeepAlive
        public EasyHttp SetDefaultKeepAlive(bool keepAlive)
        {
            _defaultHeaderRequest.KeepAlive = keepAlive;
            return this;
        }
      
        // 设置默认请求是否带上<c>Expect100Continue</c>
        public EasyHttp SetDefaultExpect100Continue(bool defaultExpect100Continue)
        {
            _defaultHeaderRequest.ServicePoint.Expect100Continue = defaultExpect100Continue;
            return this;
        }
        
        //自动解压
        public EasyHttp SetDefaultAutomaticDecompression(DecompressionMethods decompressionMethods)
        {
            _defaultHeaderRequest.AutomaticDecompression = decompressionMethods;
            return this;
        }
    }
}
