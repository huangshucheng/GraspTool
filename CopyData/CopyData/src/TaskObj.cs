//http任务请求所需的参数
namespace CopyData
{
    class TaskObj
    {
        string _url = "";//url ，需要带域名，可不带https://
        EasyHttp.Method _method = EasyHttp.Method.POST; //请求方法

        string _urlBody = ""; //放在URL后面的请求体,get,post都能用, 例：shareCode=123&code=abc
        string _postBody = ""; //post请求的参数，只有post能用到
        string _curTaskName = ""; //当前任务名字
        string _preTaskName = ""; //前置任务名字：如果有前置任务名字，则需要等到前置任务做好后才去调用此任务
        int _reqCount = 1;  //请求次数

        // get,post 通用
        public TaskObj(string url, EasyHttp.Method method, string taskName = "")
        {
            _url = url;
            _method = method;
            _curTaskName = taskName;
        }

        public string getUrl(){
            return _url;
        }

        public EasyHttp.Method getMethod() {
            return _method;
        }

        //不是放在url后面的body
        public string getBody() {
            return _postBody;
        }

        //追加postBody，不是放在url后面的
        public TaskObj addBody(string postBody) {
            _postBody = postBody;
            return this;
        }

        //body追加到url,放在url后面
        public TaskObj addUrlBody(string urlBody) {
            _urlBody = urlBody;
            return this;
        }

        //放在url后面的参数
        public string getUrlBody() {
            return _urlBody;
        }

        //获取当前任务名字
        public string getTaskName(){
            return _curTaskName;
        }

        //设置前置任务名字
        public TaskObj addPreTaskName(string preTaskName) {
            _preTaskName = preTaskName;
            return this;
        }

        //获取前置任务名
        public string getPreTaskName() {
            return _preTaskName;
        }

        //次数
        public TaskObj setReqCount(int count) {
            _reqCount = count;
            return this;
        }

        public int getReqCount() {
            return _reqCount;
        }

    }
}
