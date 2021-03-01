using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml;
using System.IO;
using System.Security.Cryptography;

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

        //base64加密
        public static string Base64Encode(string sourceStr)
        {
            if (string.IsNullOrEmpty(sourceStr)) {
                return sourceStr;
            }
            byte[] encbuff = Encoding.UTF8.GetBytes(sourceStr);
            return Convert.ToBase64String(encbuff);
        }

        //base64解密
        public static string Base64Decode(string sourceStr)
        {
            if (string.IsNullOrEmpty(sourceStr)) {
                return sourceStr;
            }
            byte[] decbuff = Convert.FromBase64String(sourceStr);
            return Encoding.UTF8.GetString(decbuff, 0, decbuff.Length);
        }

        //md5加密
        public static string MD5Encode(string strText)
        {
            MD5 md5 = MD5.Create();
            byte[] md5buffer = md5.ComputeHash(System.Text.Encoding.UTF8.GetBytes(strText));
            string str = "";
            // 通过使用循环，将字节类型的数组转换为字符串，此字符串是常规字符格式化所得
            foreach (byte b in md5buffer)
            {
                //得到的字符串使用十六进制类型格式。格式后的字符是小写的字母，如果使用大写（X）则格式后的字符是大写字符 
                //但是在和对方测试过程中，发现我这边的MD5加密编码，经常出现少一位或几位的问题；
                //后来分析发现是 字符串格式符的问题， X 表示大写， x 表示小写， 
                //X2和x2表示不省略首位为0的十六进制数字；
                str += b.ToString("x2");
            }
            return str;
        }

        //sha1 加密
        public static string Sha1Encode(string str)
         {
             var buffer = Encoding.UTF8.GetBytes(str);
             var data = SHA1.Create().ComputeHash(buffer);
             var sb = new StringBuilder();
             foreach (var t in data)
             {
                 sb.Append(t.ToString("x2"));
             }
             return sb.ToString();
         }

        //字符转unicode
        public static string String2Unicode(string source)
        {
            var bytes = Encoding.Unicode.GetBytes(source);
            var stringBuilder = new StringBuilder();
            for (var i = 0; i < bytes.Length; i += 2)
            {
                stringBuilder.AppendFormat("\\u{0}{1}", bytes[i + 1].ToString("x").PadLeft(2, '0'), bytes[i].ToString("x").PadLeft(2, '0'));
            }
            return stringBuilder.ToString();
        }

        //Unicode转字符串
        public static string Unicode2String(string source)
        {
            return new Regex(@"\\u([0-9A-F]{4})", RegexOptions.IgnoreCase | RegexOptions.Compiled).Replace(source, x => Convert.ToChar(Convert.ToUInt16(x.Result("$1"), 16)).ToString());
        }
    }
}
