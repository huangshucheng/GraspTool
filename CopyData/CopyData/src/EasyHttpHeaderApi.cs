using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;

namespace CopyData
{
 public   partial class EasyHttp
    {
        /// 设置自定义头部键值对
        public EasyHttp HeaderCustome(string name, string value)
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
                HeaderCustome(item.Key, item.Value);
            }
            return this;
        }
        /// 设置一个默认头信息
        public EasyHttp DefaultHeaderCustome(string name, string value)
        {
            _defaultHeaders.Add(name, value);
            return this;
        }

        /// 设置当前请求的UserAgent头为指定的值
        public EasyHttp UserAgent(string userAgent)
        {
            _tempRequest.UserAgent = userAgent;
            return this;
        }

        /// 设置默认的UserAgent头，当没有设置UserAgent时(<see cref="UserAgent"/>),使用的UserAgent值
        public EasyHttp DefaultUserAgent(string userAgent)
        {
            _defaultHeaderRequest.UserAgent = userAgent;
            return this;
        }

        /// 设置Http请求中的Refer行值
        public EasyHttp Referer(string referer)
        {
            _tempRequest.Referer = referer;
            return this;
        }

        /// 默认Refer值
        public EasyHttp DefaultReferer(string referer)
        {
            _defaultHeaderRequest.Referer = referer;
            return this;
        }
        /// 设置请求的<c>Accept-Encoding</c>行的值
        public EasyHttp AcceptEncoding(string acceptEncoding)
        {
            _headers.Add("Accept-Encoding", acceptEncoding);
            return this;
        }
        /// 设置请求的<c>Accept-Encoding</c>行的值
        public EasyHttp DefaultAcceptEncoding(string acceptEncoding)
        {
            _defaultHeaders.Add("Accept-Encoding", acceptEncoding);
            return this;
        }
        /// 设置请求的<c>Accept-Language</c>的值
        public EasyHttp AcceptLanguage(string acceptLanguage)
        {
            _headers.Add("Accept-Language", acceptLanguage);
            return this;
        }
        /// 设置默认的<c>Accept-Language</c>的值
        public EasyHttp DefaultAcceptLanguage(string acceptLanguage)
        {
            _defaultHeaders.Add("Accept-Language", acceptLanguage);
            return this;
        }
        /// 设置<c>Accept</c>值
        public EasyHttp Accept(string accept)
        {
            _tempRequest.Accept = accept;
            return this;
        }

        /// 设置默认<c>Accept</c>值
        public EasyHttp DefaultAccept(string accept)
        {
            _defaultHeaderRequest.Accept = accept;
            return this;
        }
        /// 设置请求的<c>Content-Type</c>值
        public EasyHttp ContentType(string contentType)
        {
            _tempRequest.ContentType = contentType;
            return this;
        }
        /// 设置默认请求的<c>Content-Type</c>值
        public EasyHttp DefaultContentType(string contentType)
        {
            _defaultHeaderRequest.ContentType = contentType;
            return this;
        }

        /// 设置请求是否KeepAlive
        public EasyHttp KeepAlive(bool keepAlive)
        {
            _tempRequest.KeepAlive = keepAlive;
            return this;
        }
        /// 设置默认请求是否KeepAlive
        public EasyHttp DefaultKeepAlive(bool keepAlive)
        {
            _defaultHeaderRequest.KeepAlive = keepAlive;
            return this;
        }
        /// 设置请求是否带上<c>Expect100Continue</c>
        public EasyHttp Expect100Continue(bool expect100Continue)
        {
            _tempRequest.ServicePoint.Expect100Continue = expect100Continue;
            return this;
        }
        /// 设置默认请求是否带上<c>Expect100Continue</c>
        public EasyHttp DefaultExpect100Continue(bool defaultExpect100Continue)
        {
            _defaultHeaderRequest.ServicePoint.Expect100Continue = defaultExpect100Continue;
            return this;
        }
        public EasyHttp AutomaticDecompression(DecompressionMethods decompressionMethods)
        {
            _tempRequest.AutomaticDecompression = decompressionMethods;
            return this;
        }
        public EasyHttp DefaultAutomaticDecompression(DecompressionMethods decompressionMethods)
        {
            _defaultHeaderRequest.AutomaticDecompression = decompressionMethods;
            return this;
        }
    }
}
