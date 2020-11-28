using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

//处理请求体
namespace CopyData
{
    class DealReqBody
    {
        private Dictionary<string, string> _dataDic = new Dictionary<string, string>();
        //public event DataDelegateHander _dataChangedEvent;//声明一个事件
        public bool parseData(string dataStr)
        {
            return false;
        }

        public Dictionary<string, string> getDataDic()
        {
            return this._dataDic;
        }
        public string getValueByKey(string key)
        {
            return this._dataDic[key];
        }

    }
}
