using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

//全局定义
namespace CopyData
{

    public delegate void DataDelegateHander(string message); //声明一个委托

    public delegate void httpDataReturnHandler(object sender, string data);//定义一个http请求返回的委托

     /*
     事件的使用：
     * 声明事件：public event DataDelegateHander _dataChangedEvent;
     * 派送事件：_dataChangedEvent（data）; 或者_dataChangedEvent.Invoke(data);
     * 对象接收事件：
     *  _dealHeaderReq = new DealHeaderReq();
        //监听_dealHeaderReq对象的事件，onHeaderFindData回调
        _dealHeaderReq._dataChangedEvent += new DataDelegateHander(onHeaderFindData);
     */
    class Define
    {
    }
}
