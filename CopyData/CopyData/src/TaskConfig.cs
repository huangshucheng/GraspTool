using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

//一个请求任务的类，包含一个http任务请求所需的参数
namespace CopyData
{
    class TaskConfig
    {
        string _url = "";//url ，需要带域名，可不带https://
        EasyHttp.Method _method = EasyHttp.Method.POST; //请求方法
        List<KeyValue> _body = null;//请求body

        public TaskConfig(string url, EasyHttp.Method method, List<KeyValue> body)
        {
            _url = url;
            _method = method;
            _body = body;
        }

        public string getUrl(){
            return _url;
        }

        public EasyHttp.Method getMethod() {
            return _method;
        }

        public List<KeyValue> getBody(){
            return _body;
        }

    }
}
