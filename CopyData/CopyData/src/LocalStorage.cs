using System;
using System.Text;
using System.IO;
using System.Collections.Generic;

namespace CopyData
{
    class LocalStorage
    {

        //文件是否存在
        public static bool IsFileExist(string filePath) {
            return File.Exists(filePath);
        }

        //写入文件，不存在会创建
        public static bool WriteFile(string filePath, string content) {
            try {
                if (!File.Exists(filePath))
                {
                    FileStream cfs = File.Create(filePath);
                    cfs.Close();
                }
                File.WriteAllText(filePath, content, Encoding.UTF8);
                return true;
            } catch (Exception e) {
                Console.WriteLine("WriteFile error: " + e.Message);
            }
            return false;
        }

        //读取文件内容，不存在会创建
        public static string ReadFile(string filePath) {
            try
            {
                if (!File.Exists(filePath)){
                    FileStream cfs = File.Create(filePath);
                    cfs.Close();
                }
                return File.ReadAllText(filePath, Encoding.UTF8);
            }
            catch (Exception e)
            {
                Console.WriteLine("ReadFile error: " + e.Message);
            }
            return string.Empty;
        }

        //追加文本，不存在会创建
        public static bool AppendText(string filePath, string content) {
            try
            {
                if (!File.Exists(filePath))
                {
                    FileStream cfs = File.Create(filePath);
                    cfs.Close();
                }
                File.AppendAllText(filePath, content, Encoding.UTF8);
                return true;
            }
            catch (Exception e)
            {
                Console.WriteLine("AppendText error: " + e.Message);
            }
            return false;
        }

        //追加一行文本，不存在会创建
        public static bool AppendLine(string filePath, string content) {
            try
            {
                if (!File.Exists(filePath))
                {
                    FileStream cfs = File.Create(filePath);
                    cfs.Close();
                }
                File.AppendAllText(filePath, "\n" + content , Encoding.UTF8);
                return true;
            }
            catch (Exception e)
            {
                Console.WriteLine("AppendLine error: " + e.Message);
            }
            return false;
        }

        //创建文件
        public static bool CreateFile(string filePath) {
            try {
                if (!File.Exists(filePath))
                {
                    FileStream cfs = File.Create(filePath);
                    cfs.Close();
                    return true;
                }
            } catch (Exception e)
            {
                Console.WriteLine("CreateFile error: " + e.Message);
            }
            return false;
        }

    }
}
