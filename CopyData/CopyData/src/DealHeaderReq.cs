using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.RegularExpressions;


//处理HTTP请求头
namespace CopyData
{
    class DealHeaderReq
    {

        public List<Dictionary<string,string>> _dataList = new List<Dictionary<string,string>>(); //查找列表
        public event DataDelegateHander _dataChangedEvent;//声明一个事件
        public bool parseData(string dataStr){
            var parseDic = StringUtils.parseHttpHeader(dataStr);
            bool isFind = false;
            
            var tmpDic = new Dictionary<string, string>();
            for (int idx = 0; idx < GlobalData.DATA_TO_FIND_ARRAY.Length; idx++) {
                string key = GlobalData.DATA_TO_FIND_ARRAY[idx];
                if (parseDic.ContainsKey(key)){
                    string findValue = parseDic[key];
                    if (findValue != null && findValue != string.Empty){
                        tmpDic[key] = findValue;
                    }
                }
            }

            if (tmpDic.Count() > 0 && !isIndexOfDic(_dataList,tmpDic)){
                _dataList.Add(tmpDic);
                isFind = true;
            }
            
            if(isFind == true){
                string cstr = "";
                foreach(var o in tmpDic){
                    cstr = cstr + "[" + o.Key + "]:" + o.Value + "\n";
                }
                string outStr = "【" + _dataList.Count() + "】" + cstr + "\n";
                if (_dataChangedEvent != null) {
                    _dataChangedEvent.Invoke(outStr); //发送事件
                }
            }
            return isFind;
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
