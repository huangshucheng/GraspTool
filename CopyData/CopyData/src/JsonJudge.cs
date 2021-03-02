﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CopyData
{
    /// <summary>
    /// 分隔Json字符串为字典集合。
    /// </summary>
    internal partial class JsonJudge
    {
        internal static bool IsJson(string json)
        {
            return IsJson(json, false);
        }
        internal static bool IsJson(string json, bool isStrictMode)
        {
            int errIndex;
            return IsJson(json, isStrictMode, out errIndex);
        }
        internal static bool IsJson(string json, bool isStrictMode, out int errIndex)
        {
            errIndex = 0;

            if (string.IsNullOrEmpty(json) || json.Length < 2 ||
                ((json[0] != '{' && json[json.Length - 1] != '}') && (json[0] != '[' && json[json.Length - 1] != ']')))
            {
                return false;
            }
            CharState cs = new CharState(isStrictMode);
            char c;
            for (int i = 0; i < json.Length; i++)
            {
                c = json[i];
                if (cs.IsKeyword(c) && cs.childrenStart)//设置关键符号状态。
                {
                    string item = json.Substring(i);
                    int err;
                    int length = GetValueLength(isStrictMode, item, true, out err);
                    cs.childrenStart = false;
                    if (err > 0)
                    {
                        errIndex = i + err;
                        return false;
                    }
                    i = i + length - 1;
                }
                if (cs.isError)
                {
                    errIndex = i;
                    return false;
                }
            }

            return !cs.arrayStart && !cs.jsonStart; //只要不是正常关闭，则失败
        }

        /// <summary>
        /// 解析Json
        /// </summary>
        /// <param name="json"></param>
        /// <param name="op">除了NO，其它项都会消掉转义符，默认是：YES</param>
        /// <returns></returns>
        internal static List<Dictionary<string, string>> Split(string json)
        {
            List<Dictionary<string, string>> result = new List<Dictionary<string, string>>();

            if (!string.IsNullOrEmpty(json))
            {
                Dictionary<string, string> dic = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                string key = string.Empty;
                StringBuilder value = new StringBuilder();
                CharState cs = new CharState(false);
                try
                {
                    #region 核心逻辑
                    char c;
                    for (int i = 0; i < json.Length; i++)
                    {
                        c = json[i];
                        if (!cs.IsKeyword(c))//设置关键符号状态。
                        {
                            if (cs.jsonStart)//Json进行中。。。
                            {
                                if (cs.keyStart > 0)
                                {
                                    key += c;
                                }
                                else if (cs.valueStart > 0)
                                {
                                    value.Append(c);
                                    //value += c;
                                }
                            }
                            else if (!cs.arrayStart)//json结束，又不是数组，则退出。
                            {
                                break;
                            }
                        }
                        else if (cs.childrenStart)//正常字符，值状态下。
                        {
                            string item = json.Substring(i);
                            int temp;
                            int length = GetValueLength(false, item, false, out temp);
                            //value = item.Substring(0, length);
                            value.Length = 0;
                            value.Append(item.Substring(0, length));
                            cs.childrenStart = false;
                            cs.valueStart = 0;
                            //cs.state = 0;
                            cs.setDicValue = true;
                            i = i + length - 1;
                        }
                        if (cs.setDicValue)//设置键值对。
                        {
                            if (!string.IsNullOrEmpty(key) && !dic.ContainsKey(key))
                            {
                                //if (value != string.Empty)
                                //{
                                string val = value.ToString();
                                bool isNull = json[i - 5] == ':' && json[i] != '"' && value.Length == 4 && val == "null";
                                if (isNull)
                                {
                                    val = "";
                                }

                                dic.Add(key, val);

                                //}
                            }
                            cs.setDicValue = false;
                            key = string.Empty;
                            value.Length = 0;
                        }

                        if (!cs.jsonStart && dic.Count > 0)
                        {
                            result.Add(dic);
                            if (cs.arrayStart)//处理数组。
                            {
                                dic = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                            }
                        }
                    }
                    #endregion
                }
                catch (Exception err)
                {
                    
                }
                finally
                {
                    key = null;
                    value.Length = 0;
                    value.Capacity = 16;
                    value = null;
                }
            }
            return result;
        }
        /// <summary>
        /// 获取值的长度（当Json值嵌套以"{"或"["开头时）
        /// </summary>
        private static int GetValueLength(bool isStrictMode, string json, bool breakOnErr, out int errIndex)
        {
            errIndex = 0;
            int len = json.Length - 1;
            if (!string.IsNullOrEmpty(json))
            {
                CharState cs = new CharState(isStrictMode);
                char c;
                for (int i = 0; i < json.Length; i++)
                {
                    c = json[i];
                    if (!cs.IsKeyword(c))//设置关键符号状态。
                    {
                        if (!cs.jsonStart && !cs.arrayStart)//json结束，又不是数组，则退出。
                        {
                            break;
                        }
                    }
                    else if (cs.childrenStart)//正常字符，值状态下。
                    {
                        int length = GetValueLength(isStrictMode, json.Substring(i), breakOnErr, out errIndex);//递归子值，返回一个长度。。。
                        cs.childrenStart = false;
                        cs.valueStart = 0;
                        //cs.state = 0;
                        i = i + length - 1;
                    }
                    if (breakOnErr && cs.isError)
                    {
                        errIndex = i;
                        return i;
                    }
                    if (!cs.jsonStart && !cs.arrayStart)//记录当前结束位置。
                    {
                        len = i + 1;//长度比索引+1
                        break;
                    }
                }
            }
            return len;
        }




    }
    internal partial class JsonJudge
    {
        /// <summary>
        /// 将json数组分成字符串List
        /// </summary>
        /// <param name="jsonArray">["a,","bbb,,"]</param>
        /// <returns></returns>
        internal static List<string> SplitEscapeArray(string jsonArray)
        {
            if (!string.IsNullOrEmpty(jsonArray))
            {
                jsonArray = jsonArray.Trim(' ', '[', ']');//["a,","bbb,,"]
                List<string> list = new List<string>();
                if (jsonArray.Length > 0)
                {
                    string[] items = jsonArray.Split(',');
                    string objStr = string.Empty;
                    foreach (string item in items)
                    {
                        if (objStr == string.Empty) { objStr = item; }
                        else { objStr += "," + item; }
                        char firstChar = objStr[0];
                        if (firstChar == '"' || firstChar == '\'')
                        {
                            //检测双引号的数量
                            if (GetCharCount(objStr, firstChar) % 2 == 0)//引号成双
                            {
                                list.Add(objStr.Trim(firstChar).Replace("\\" + firstChar, firstChar.ToString()));
                                objStr = string.Empty;
                            }
                        }
                        else
                        {
                            list.Add(item);
                            objStr = string.Empty;
                        }
                    }
                }
                return list;

            }
            return null;
        }
        /// <summary>
        /// 获取字符在字符串出现的次数
        /// </summary>
        /// <param name="c"></param>
        /// <returns></returns>
        private static int GetCharCount(string item, char c)
        {
            int num = 0;
            for (int i = 0; i < item.Length; i++)
            {
                if (item[i] == '\\')
                {
                    i++;
                }
                else if (item[i] == c)
                {
                    num++;
                }
            }
            return num;
        }
    }

    /// <summary>
    /// 字符状态
    /// </summary>
    internal class CharState
    {
        internal char lastKeywordChar = ' ';
        internal char lastChar = ' ';
        /// <summary>
        /// 是否格式格式【true属性必须双引号，false属性可以单引号和无引号。】
        /// </summary>
        internal bool isStrictMode = false;
        public CharState(bool isStrictMode)
        {
            this.isStrictMode = isStrictMode;
        }
        internal bool jsonStart = false;//以 "{"开始了...
        internal bool setDicValue = false;// 可以设置字典值了。
        internal bool escapeChar = false;//以"\"转义符号开始了
        /// <summary>
        /// 数组开始【仅第一开头才算】，值嵌套的以【childrenStart】来标识。
        /// </summary>
        internal bool arrayStart = false;//以"[" 符号开始了
        internal bool childrenStart = false;//子级嵌套开始了。
        /// <summary>
        /// 【-1 未初始化】【0取名阶段】【1 取值阶段】
        /// </summary>
        internal int keyValueState = -1;

        /// <summary>
        /// 【-2 已结束】【-1 未初始化】【0 未开始】【1 无引号开始】【2 单引号开始】【3 双引号开始】
        /// </summary>
        internal int keyStart = -1;
        /// <summary>
        /// 【-2 已结束】【-1 未初始化】【0 未开始】【1 无引号开始】【2 单引号开始】【3 双引号开始】
        /// </summary>
        internal int valueStart = -1;

        internal bool isError = false;//是否语法错误。

        internal void CheckIsError(char c)//只当成一级处理（因为GetLength会递归到每一个子项处理）
        {
            switch (c)
            {
                case '\r':
                case '\n':
                case '\t':
                    return;
                case '{'://[{ "[{A}]":[{"[{B}]":3,"m":"C"}]}]
                    isError = jsonStart && keyValueState == 0;//重复开始错误 同时不是值处理。
                    break;
                case '}':
                    isError = !jsonStart || (keyStart > 0 && keyValueState == 0);//重复结束错误 或者 提前结束。
                    if (!isError && isStrictMode)
                    {
                        isError = !((keyStart == 3 && keyValueState == 0) || (valueStart != 2 && keyValueState == 1) || valueStart == -2 || (jsonStart && keyStart == -1));
                    }
                    break;
                case '[':
                    isError = arrayStart && keyValueState == 0;//重复开始错误
                    break;
                case ']':
                    isError = (!arrayStart && valueStart != 3 && keyStart != 3) || (keyValueState == 1 && valueStart == 0);//重复开始错误[{},]1,0  正常：[111,222] 1,1 [111,"22"] 1,-2 
                    break;
                case '"':
                    isError = !jsonStart && !arrayStart;//未开始Json，同时也未开始数组。
                    break;
                case '\'':
                    isError = (!jsonStart && !arrayStart);//未开始Json
                    if (!isError && isStrictMode)
                    {
                        isError = !((keyStart == 3 && keyValueState == 0) || (valueStart == 3 && keyValueState == 1));
                    }
                    break;
                case ':':
                    isError = (!jsonStart && !arrayStart) || (jsonStart && keyStart < 2 && valueStart < 2 && keyValueState == 1);//未开始Json 同时 只能处理在取值之前。
                    break;
                case ',':
                    isError = (!jsonStart && !arrayStart)
                        || (!jsonStart && arrayStart && keyValueState == -1) //[,111]
                        || (jsonStart && keyStart < 2 && valueStart < 2 && keyValueState == 0);//未开始Json 同时 只能处理在取值之后。
                    break;
                //case 't'://true
                //case 'f'://false

                //  break;
                default: //值开头。。
                    isError = (!jsonStart && !arrayStart) || (keyStart == 0 && valueStart == 0 && keyValueState == 0);//
                    if (!isError && keyStart < 2)
                    {
                        //if ((jsonStart && !arrayStart) && state != 1)
                        if (jsonStart && keyValueState <= 0)//取名阶段
                        {
                            //不是引号开头的，只允许字母 {aaa:1}
                            isError = isStrictMode || (c < 65 || (c > 90 && c < 97) || c > 122);
                        }
                        else if (!jsonStart && arrayStart && valueStart < 2)//
                        {
                            switch (c)
                            {
                                case ' ':
                                case 'n'://null
                                case 'u':
                                case 'l':
                                case 't'://true
                                case 'r':
                                case 'e':
                                case 'f'://false
                                case 'a':
                                case 's':
                                    break;
                                default:
                                    //不是引号开头的，只允许数字[1] 空格、null,true,false
                                    isError = c < 48 || c > 57;
                                    break;
                            }

                        }
                    }
                    if (!isError && isStrictMode)
                    {
                        if (jsonStart && valueStart == 1)//检测值value:true 或value:false
                        {
                            switch (c)
                            {
                                case 'r'://true
                                    isError = lastChar != 't';
                                    break;
                                case 'u'://true,null
                                    isError = !((lastKeywordChar == 't' && lastChar == 'r') || (lastKeywordChar == 'n' && lastChar == 'n'));
                                    break;
                                case 'e'://true
                                    isError = !((lastKeywordChar == 't' && lastChar == 'u') || (lastKeywordChar == 'f' && lastChar == 's'));
                                    break;
                                case 'a'://false
                                    isError = lastChar != 'f';
                                    break;
                                case 'l'://false,null 
                                    isError = !((lastKeywordChar == 'f' && lastChar == 'a') || (lastKeywordChar == 'n' && (lastChar == 'u' || lastChar == 'l')));
                                    if (!isError && lastKeywordChar == 'n' && lastChar == 'l')
                                    {
                                        //取消关键字，避免出现 nulllll多个l
                                        lastKeywordChar = ' ';
                                    }
                                    break;
                                case 's'://false
                                    isError = lastChar != 'l';
                                    break;
                                case '.'://数字可以出现小数点，但不能重复出现
                                    isError = keyValueState != 1 || lastKeywordChar == '.';
                                    break;
                                case ' ':
                                    if (lastChar == '.') { isError = true; }
                                    else if (jsonStart && !arrayStart)
                                    {
                                        valueStart = -2;//遇到空格，结束取值。
                                    }
                                    break;
                                default:
                                    //不是引号开头的，只允许数字[1]
                                    isError = c < 48 || c > 57;
                                    break;
                            }
                        }
                        //值开头的，只能是：["xxx"] {[{}]
                    }
                    break;
            }
            if (isError)
            {
                //
            }
        }

        /// <summary>
        /// 设置字符状态(返回true则为关键词，返回false则当为普通字符处理）
        /// </summary>
        internal bool IsKeyword(char c)
        {
            bool isKeyword = false;
            switch (c)
            {
                case '{'://[{ "[{A}]":[{"[{B}]":3,"m":"C"}]}]
                    #region 大括号
                    if (keyStart <= 0 && valueStart <= 0)
                    {
                        if (jsonStart && keyValueState == 1)
                        {
                            valueStart = 0;
                            childrenStart = true;
                        }
                        else
                        {
                            keyValueState = 0;
                        }
                        jsonStart = true;//开始。
                        isKeyword = true;
                    }
                    #endregion
                    break;
                case '}':
                    #region 大括号结束
                    if (lastChar != '.')
                    {
                        if (keyStart <= 0 && valueStart < 2)
                        {
                            if (jsonStart)
                            {
                                jsonStart = false;//正常结束。
                                valueStart = -1;
                                keyValueState = 0;
                                setDicValue = true;
                            }
                            isKeyword = true;
                        }
                    }
                    #endregion
                    break;
                case '[':
                    #region 中括号开始
                    if (!jsonStart)
                    {
                        arrayStart = true;
                        isKeyword = true;
                    }
                    else if (jsonStart && keyValueState == 1 && valueStart < 2)
                    {
                        childrenStart = true;
                        isKeyword = true;
                    }
                    #endregion
                    break;
                case ']':

                    #region 中括号结束
                    if (lastChar != '.')
                    {
                        if (!jsonStart && (keyStart <= 0 && valueStart <= 0) || (keyStart == -1 && valueStart == 1))
                        {
                            if (arrayStart)// && !childrenStart
                            {
                                arrayStart = false;
                            }
                            isKeyword = true;
                        }
                    }
                    #endregion
                    break;
                case '"':
                case '\'':
                    // CheckIsError(c);
                    if (isStrictMode && c == '\'')
                    {
                        break;
                    }
                    #region 引号
                    if (jsonStart || arrayStart)
                    {
                        if (!jsonStart && arrayStart)
                        {
                            keyValueState = 1;//如果是数组，只有取值，没有Key，所以直接跳过0
                        }
                        if (keyValueState == 0)//key阶段
                        {
                            keyStart = (keyStart <= 0 ? (c == '"' ? 3 : 2) : -2);
                            isKeyword = true;
                        }
                        else if (keyValueState == 1)//值阶段
                        {
                            if (valueStart <= 0)
                            {
                                valueStart = (c == '"' ? 3 : 2);
                                isKeyword = true;
                            }
                            else if ((valueStart == 2 && c == '\'') || (valueStart == 3 && c == '"'))
                            {
                                if (!escapeChar)
                                {
                                    valueStart = -2;
                                    isKeyword = true;
                                }
                                else
                                {
                                    escapeChar = false;
                                }
                            }

                        }
                    }
                    #endregion
                    break;
                case ':':
                    // CheckIsError(c);
                    #region 冒号
                    if (jsonStart && keyStart < 2 && valueStart < 2 && keyValueState == 0)
                    {
                        keyStart = -2;//0 结束key
                        keyValueState = 1;
                        isKeyword = true;
                    }
                    #endregion
                    break;
                case ',':
                    #region 逗号 {"a": [11,"22", ], "Type": 2.}
                    if (lastChar != '.')
                    {
                        if (jsonStart && keyStart < 2 && valueStart < 2 && keyValueState == 1)
                        {
                            keyValueState = 0;
                            valueStart = 0;
                            setDicValue = true;
                            isKeyword = true;
                        }
                        else if (arrayStart && !jsonStart) //[a,b]  [",",33] [{},{}]
                        {
                            if ((keyValueState == -1 && valueStart == -1) || (valueStart < 2 && keyValueState == 1))
                            {
                                valueStart = 0;
                                isKeyword = true;
                            }
                        }
                    }
                    #endregion
                    break;
                case ' ':
                case '\r':
                case '\n':
                case '\t':
                    if (jsonStart && keyStart <= 0 && valueStart <= 0)
                    {
                        isKeyword = true;
                        // return true;//跳过空格。
                    }
                    break;
                case 't'://true
                case 'f'://false
                case 'n'://null
                case '-'://-388.8 //负的数字符号
                    if (lastKeywordChar != c && lastKeywordChar != '.')
                    {
                        if (valueStart <= 1 && ((arrayStart && !jsonStart && keyStart == -1) || (jsonStart && keyValueState == 1 && valueStart <= 0)))
                        {
                            //只改状态，不是关键字
                            valueStart = 1;
                            lastChar = c;
                            lastKeywordChar = c;
                            return false;//直接返回，不检测错误。
                        }
                    }
                    break;
                case '.':
                    if ((jsonStart || arrayStart) && keyValueState == 1 && valueStart == 1 && lastKeywordChar != c)
                    {
                        lastChar = c;
                        lastKeywordChar = c;//记录符号，数字只能有一个符号。
                        return false;//不检测错误。
                    }
                    break;
                default: //值开头。。
                    // CheckIsError(c);
                    if (c == '\\') //转义符号
                    {
                        if (escapeChar)
                        {
                            escapeChar = false;
                        }
                        else
                        {
                            escapeChar = true;
                        }
                    }
                    if (jsonStart)
                    {
                        if (keyStart <= 0 && keyValueState <= 0)
                        {
                            keyStart = 1;//无引号的
                        }
                        else if (valueStart <= 0 && keyValueState == 1)
                        {
                            valueStart = 1;//无引号的
                        }
                    }
                    else if (arrayStart)
                    {
                        keyValueState = 1;
                        if (valueStart < 1)
                        {
                            valueStart = 1;//无引号的
                        }
                    }
                    break;
            }
            if (escapeChar && c != '\\')
            {
                escapeChar = false;
            }
            if (!isKeyword)
            {
                CheckIsError(c);
            }
            else
            {
                lastKeywordChar = c;
            }
            lastChar = c;
            return isKeyword;
        }
    }
}
