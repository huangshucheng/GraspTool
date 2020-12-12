using System;
using System.Collections.Generic;
using System.Linq;
using Newtonsoft.Json.Linq;

//处理HTTP请求头
namespace CopyData
{
    class DealHeaderReq
    {

        public List<Dictionary<string,string>> _dataList = new List<Dictionary<string,string>>(); //查找列表
        public event DataDelegateHander _dataChangedEvent;//声明一个事件

        //解析请求头数据
        public bool parseData(string dataStr){
            var parseDic = StringUtils.parseHttpHeader(dataStr);
            if (parseDic.Count() <= 0) {
                return false;
            }

            var tmpDic = new Dictionary<string, string>();
            for (int idx = 0; idx < GlobalData.DATA_TO_FIND_ARRAY.Length; idx++) { //TODO 做成lua配置
                string key = GlobalData.DATA_TO_FIND_ARRAY[idx];
                if (parseDic.ContainsKey(key)){
                    string findValue = parseDic[key];
                    if (!string.IsNullOrEmpty(findValue)){
                        tmpDic[key] = findValue;
                    }
                }
            }

            if (tmpDic.Count() > 0 && !isIndexOfDic(_dataList,tmpDic)){
                _dataList.Add(tmpDic);
                writeDataListToLocal();
                reportUI(tmpDic);
                return true;
            }
            return false;
        }

        //找到了token,通知 UI
        void reportUI(Dictionary<string,string> dic) { 
           if(dic.Count() > 0){
               string cstr = "";
               foreach (var o in dic)
               {
                   cstr = cstr + "[" + o.Key + "]:" + o.Value + "\n";
               }
               string outStr = "【" + _dataList.Count() + "】" + cstr + "\n";
               if (_dataChangedEvent != null)
               {
                   _dataChangedEvent.Invoke(outStr); //发送事件
               }
           }
        }

        //将token保存到本地
        void writeDataListToLocal() {
            try {
                var bigObj = new JObject();
                for(var index = 0; index < _dataList.Count(); index++){
                    var dic = _dataList[index];
                    JObject jo = new JObject();
                    if(dic.Count() > 0){
                        foreach(var d in dic){
                            jo.Add(d.Key, d.Value);
                        }
                        bigObj.Add(index.ToString(),jo);
                    }
                }
                if (bigObj.Count > 0){
                    LocalStorage.saveJsonObjToFile(bigObj);
                }
            }catch(Exception e){
                Console.WriteLine("writeDataListToLocal error:" + e.Message);
            }
        }

        //读取本地存储的token
        public void readDataListFromLocal() {
            try {
                JObject bigObj = LocalStorage.getJsonObjFromFile();
                if(bigObj != null){
                   foreach(var obj in bigObj){
                       var dic = new Dictionary<string, string>();
                       var vl = (JObject)obj.Value;
                       if(vl != null){
                           foreach(var v in vl){
                               dic.Add((string)v.Key, (string)v.Value);
                           }
                       }
                       if(dic.Count() > 0){
                            _dataList.Add(dic);
                            reportUI(dic);
                       }
                   }
                }
            }
            catch(Exception e){
                Console.WriteLine("readDataListFromLocal error:" + e.Message);
            }
        }

        //列表里是否有指定字典
        bool isIndexOfDic(List<Dictionary<string,string>>dicList, Dictionary<string,string>dic) {
            if(dicList.Count() <=0){
                return false;
            }

            foreach (var d in dicList){
                if (StringUtils.isDictionaryEqule(d, dic)){
                    return true;
                }
            }

            return false;
        }

        public List<Dictionary<string,string>> getFindList(){
            return _dataList;
        }

        public void clearList() {
            _dataList.Clear();
        }
    }
}
