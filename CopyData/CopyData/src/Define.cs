﻿using System;
using System.Runtime.InteropServices;
using LuaInterface;

//全局定义
namespace CopyData
{
    /*
    事件的使用：
    * 声明事件：public event DataDelegateHander _dataChangedEvent;
    * 派送事件：_dataChangedEvent（data）; 或者_dataChangedEvent.Invoke(data);
    * 对象接收事件：
    *  _dealHeaderReq = new DealHeaderReq();
       //监听_dealHeaderReq对象的事件，onHeaderFindData回调
       _dealHeaderReq._dataChangedEvent += new DataDelegateHander(onHeaderFindData);
    */
    public delegate void DataDelegateHander(string message); //声明一个委托

    public delegate void httpDataReturnHandler(object sender, string data);//定义一个http请求返回的委托

    //COPYDATASTRUCT结构,用于其他软件传数据
    public struct COPYDATASTRUCT
    {
        public IntPtr dwData;
        public int cData;
        [MarshalAs(UnmanagedType.LPStr)]
        public string lpData;
    }
    
    public class Define
    {
        public const int WM_COPYDATA = 0x004A; //copydata的域
    }
}
