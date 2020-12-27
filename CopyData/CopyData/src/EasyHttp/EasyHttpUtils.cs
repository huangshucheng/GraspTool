using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Net;
using System.Text;

namespace CopyData
{
  public  class EasyHttpUtils
    {
        public static string NameValuesToQueryParamString(NameValueCollection nameValueCollection)
        {
            StringBuilder builder = new StringBuilder();
            if (nameValueCollection == null || nameValueCollection.Count == 0)
            {
                return string.Empty;
            }

            foreach (string key in nameValueCollection.Keys)
            {
                var value = nameValueCollection[key];
                builder.Append(key).Append('=').Append(nameValueCollection[key]).Append("&");
            }
            builder.Remove(builder.Length - 1, 1);
            return builder.ToString();
        }

        //_defaultHeaderRequest, _request
        //从_defaultHeaderRequest拷贝到_request
        public static void CopyHttpHeader(HttpWebRequest defaultRequest, HttpWebRequest toRequest)
        {
            //设置头部信息
            if (!string.IsNullOrEmpty(defaultRequest.Accept)) 
                toRequest.Accept = defaultRequest.Accept;

            if (!string.IsNullOrEmpty(defaultRequest.ContentType))
                toRequest.ContentType = defaultRequest.ContentType;

            if (!string.IsNullOrEmpty(defaultRequest.Referer))
                toRequest.Referer = defaultRequest.Referer;

            if (!string.IsNullOrEmpty(defaultRequest.UserAgent))
                toRequest.UserAgent = defaultRequest.UserAgent;

            if (toRequest.AutomaticDecompression != defaultRequest.AutomaticDecompression)
                toRequest.AutomaticDecompression = defaultRequest.AutomaticDecompression;

            toRequest.ClientCertificates = defaultRequest.ClientCertificates;
            toRequest.Connection = defaultRequest.Connection;
            toRequest.AllowWriteStreamBuffering = defaultRequest.AllowWriteStreamBuffering;
            toRequest.ContinueDelegate = defaultRequest.ContinueDelegate;
            toRequest.Credentials = defaultRequest.Credentials;
            toRequest.UseDefaultCredentials = defaultRequest.UseDefaultCredentials;
            toRequest.Expect = defaultRequest.Expect;
            toRequest.IfModifiedSince = defaultRequest.IfModifiedSince;

            if (toRequest.KeepAlive != defaultRequest.KeepAlive)
                toRequest.KeepAlive = defaultRequest.KeepAlive;

            toRequest.TransferEncoding = defaultRequest.TransferEncoding;
            if (toRequest.AllowAutoRedirect != defaultRequest.AllowAutoRedirect)
                toRequest.AllowAutoRedirect = defaultRequest.AllowAutoRedirect;

            if (toRequest.Timeout != defaultRequest.Timeout) 
                toRequest.Timeout = defaultRequest.Timeout;

            if (toRequest.ServicePoint.Expect100Continue != defaultRequest.ServicePoint.Expect100Continue)
                toRequest.ServicePoint.Expect100Continue = defaultRequest.ServicePoint.Expect100Continue;
        }

        public static string NameValuesToQueryParamString(List<KeyValue> nameValueCollection)
        {
            StringBuilder builder = new StringBuilder();
            if (nameValueCollection == null || nameValueCollection.Count == 0)
            {
                return string.Empty;
            }
            foreach (KeyValue keyValue in nameValueCollection)
            {
                builder.Append(keyValue.Key).Append('=').Append(keyValue.Value).Append('&');
            }
            if (builder.Length > 0)

                builder.Remove(builder.Length - 1, 1);
            return builder.ToString();
        }
        
        public static string ReadAllAsString(Stream stream, Encoding encoding)
        {
            if(stream == null || encoding == null){
                return string.Empty;
            }
            string html = string.Empty;
            using (var responseStream = new StreamReader(stream, encoding))
            {
                html = responseStream.ReadToEnd();
            }
            return html;
        }

        public static long ReadAllAsFile(Stream stream, long length, string filePath)
        {
            long currentTotal = 0;
            byte[] buffer = null;
            //判断文件大小，如果大于1m的，则buffer大小为10k，否则为1k
            if (length > 1 * 1024)
            {
                buffer = new byte[10 * 1024];
            }
            else
            {
                buffer = new byte[1024];
            }

            using (BinaryReader reader = new BinaryReader(stream,Encoding.UTF8,true))
            {
                using (FileStream lxFS = new FileStream(filePath, FileMode.Create))
                {
                    int size = -1;
                    while ((size = reader.Read(buffer, 0, buffer.Length)) > 0)
                    {
                        lxFS.Write(buffer, 0, size);
                        currentTotal += size;
                    }
                }
            }
            return currentTotal;
        }
    }
}
