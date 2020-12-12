using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml;
using System.IO;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

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

        //unicode 转中文
        public static string UnicodeDencode(string str)
        {
            if (string.IsNullOrWhiteSpace(str))
                return str;
            string tmpstr = str;
            try
            {
                tmpstr = Regex.Unescape(str);
            }
            catch (Exception e)
            {
                Console.WriteLine("UnicodeDencode error:{0}"+ e.Message);
            }
            return tmpstr;
        }
        //中文转unicode
        public static string UnicodeEncode(string str)
        {
            if (string.IsNullOrWhiteSpace(str))
                return str;
            StringBuilder strResult = new StringBuilder();
            if (!string.IsNullOrEmpty(str))
            {
                for (int i = 0; i < str.Length; i++)
                {
                    strResult.Append("\\u");
                    strResult.Append(((int)str[i]).ToString("x4"));
                }
            }
            return strResult.ToString();
        }

        //转html
        public static string toHtml(string content)
        {
            if (string.IsNullOrEmpty(content))
            {
                return string.Empty;
            }
            Regex re = new Regex("(\r*\n[ \t\r\n]*\n){1,}", RegexOptions.Compiled);
            content = re.Replace(content, "\n");
            return content;
        }

        public static string toXml(string content)
        {
            if (string.IsNullOrEmpty(content))
            {
                return string.Empty;
            }
            try
            {
                XmlDocument xd = new XmlDocument();
                xd.LoadXml(content);
                StringBuilder sb = new StringBuilder();
                StringWriter sw = new StringWriter(sb);
                XmlTextWriter xtw = null;
                try
                {
                    xtw = new XmlTextWriter(sw);
                    xtw.Formatting = System.Xml.Formatting.Indented;
                    xtw.Indentation = 4;
                    xtw.IndentChar = ' ';
                    xd.WriteTo(xtw);
                }
                finally
                {
                    if (xtw != null)
                        xtw.Close();
                }
                return sb.ToString();
            }
            catch (Exception e)
            {
                return e.Message;
            }
        }

        public static string toJson(string content)
        {
            if (string.IsNullOrEmpty(content))
            {
                return string.Empty;
            }
            return content;
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

        //比较两个dictionary是否相等
        public static bool isDictionaryEqule(Dictionary<string, string> first, Dictionary<string, string> second)
        {
            if (first.Count() != second.Count())
            {
                return false;
            }

            foreach (var obj1 in first)
            {
                var k1 = obj1.Key;
                var v1 = obj1.Value;
                foreach (var obj2 in second)
                {
                    var k2 = obj2.Key;
                    var v2 = obj2.Value;
                    if (!first.ContainsKey(k2))
                    {
                        return false;
                    }
                    if (k1.Equals(k2) && !v1.Equals(v2))
                    {
                        return false;
                    }
                }
            }
            return true;
        }

        //合并两个字典，返回一个新字典,第二个字典的内容会覆盖第一个的
        public static Dictionary<string, string> mergeDictionary(Dictionary<string, string> first, Dictionary<string, string> second)
        {
            var newDic = new Dictionary<string, string>(first);
            if (first == null) return newDic;
            if (second == null) return newDic;
            foreach (var item in second){
                newDic[item.Key] = item.Value;
            }
            return newDic;
        }

        public static Dictionary<string, string> parseHttpHeader(string dataStr)
        {
            Dictionary<string, string> dataDic = new Dictionary<string, string>();
             string[] sArray = Regex.Split(dataStr, "\n", RegexOptions.IgnoreCase);
             for (var index = 0; index < sArray.Length; index++)
             {
                 string lineString = StringUtils.RemoveSpace(StringUtils.ReplaceNewline(sArray[index], string.Empty));
                 if (lineString == string.Empty){
                     continue;
                 }

                 Regex reg = new Regex(":", RegexOptions.IgnoreCase);
                 string[] splitLine = reg.Split(lineString,2); //只拆分两次，用:将字符串分开
                 if (splitLine.Length > 1){
                     dataDic[splitLine[0]] = splitLine[1];
                 }
             }
             return dataDic;
        }

        //对象转json string
        public static string json_encode(object obj){
            try{
                string json_string = JsonConvert.SerializeObject(obj);
                return json_string;
            }
            catch (Exception e)
            {
                Console.WriteLine("json_encode error:{0}"+ e.Message);
                return null;
            }
        }

        //json string 转JObject对象,对象可用["xx"]访问, 也可以用GetValue("value")访问，数组可用foreach遍历
        public static JObject json_decode(string json_string)
        {
            try{
                object rt = JsonConvert.DeserializeObject(json_string);
                return (JObject)rt;
            }
            catch (Exception e){
                Console.WriteLine("json_decode error:{0}"+ e.Message);
                return null;
            }
        }

        public string base64_encode(string normalText)
        {
            var plainTextBytes = Encoding.UTF8.GetBytes(normalText);
            var base64 = Convert.ToBase64String(plainTextBytes).Replace('+', '-').Replace('/', '_').TrimEnd('=');
            return base64;
        }


        public string base64_decode(string base64UrlStr)
         {
             base64UrlStr = base64UrlStr.Replace('-', '+').Replace('_', '/');
             switch (base64UrlStr.Length % 4)
             {
                 case 2:
                     base64UrlStr += "==";
                     break;
                 case 3:
                     base64UrlStr += "=";
                     break;
             }
             var bytes = Convert.FromBase64String(base64UrlStr);
             return Encoding.UTF8.GetString(bytes);
         }
    }
}
