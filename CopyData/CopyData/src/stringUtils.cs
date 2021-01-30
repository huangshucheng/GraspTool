using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml;
using System.IO;

namespace CopyData
{
    class StringUtils
    {
        //去除空格字符
        public static string RemoveSpace(string content)
        {
            return new Regex(@"\s").Replace(content + "", string.Empty);
        }

        //替换换行
        public static string ReplaceNewline(string content, string newValue)
        {
            return (content + "").Replace("\n\r", newValue).Replace("\r\n", newValue).Replace("\r", newValue).Replace("\n", newValue).Replace("\t", newValue);
        }

        public static string CheckIsWithHttp(string Value)
        {
            if (Value.Length < 8)
            {
                return Value;
            }
            if ((Value.Substring(0, 7) != "http://") && (Value.Substring(0, 8) != "https://"))
            {
                Value = "https://" + Value;
            }
            return Value;
        }

        /// 检测串值是否为合法的网址格式
        public static bool CheckIsUrlFormat(string strValue)
        {
            string pattern = @"(https://)?([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?";
            return StringUtils.CheckIsFormat(pattern, strValue);
        }
        //检测串值是否为合法的格式
        public static bool CheckIsFormat(string strRegex, string strValue)
        {
            if (strValue != null && strValue.Trim() != "")
            {
                Regex re = new Regex(strRegex);
                if (re.IsMatch(strValue))
                    return true;
                else
                    return false;
            }
            return false;
        }

        //转码（utf8 -> default）
        public static string Utf8ToDefault(string str) {
            if (string.IsNullOrEmpty(str)) {
                return str;
            }

            byte[] buffer1 = Encoding.Default.GetBytes(str);
            byte[] buffer2 = Encoding.Convert(Encoding.UTF8, Encoding.Default, buffer1, 0, buffer1.Length);
            string strBuffer = Encoding.Default.GetString(buffer2, 0, buffer2.Length);
            return strBuffer;
        }

        //转码（default-> utf8）
        public static string DefaultToUtf8(string str) {
            if (string.IsNullOrEmpty(str)){
                return str;
            }
            byte[] buffer1 = Encoding.UTF8.GetBytes(str);
            byte[] buffer2 = Encoding.Convert(Encoding.Default, Encoding.UTF8, buffer1, 0, buffer1.Length);
            string strBuffer = Encoding.UTF8.GetString(buffer2, 0, buffer2.Length);
            return strBuffer;
        }

        //比较字符串是否相等
        public static bool StringCompare(string srcStr, string resStr){
            return string.Equals(srcStr, resStr);
        }

        //是否是子串
        public static bool IsSubString(string srcStr, string resStr) {
            return srcStr.Contains(resStr);
        }
    }
}
