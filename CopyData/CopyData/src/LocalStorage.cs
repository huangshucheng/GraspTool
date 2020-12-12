using System;
using System.Text;
using System.IO;
using Newtonsoft.Json.Linq;

namespace CopyData
{
    class LocalStorage
    {
        public static bool saveJsonObjToFile(JObject obj,string fileName = null) {
            try {
                string json_str = StringUtils.json_encode(obj);
                string filePath = fileName == null ? LocalStorage.getFullFilePath(Define.FILE_SAVE_NAME) : LocalStorage.getFullFilePath(fileName);
                if (!File.Exists(filePath))
                {
                    FileStream cfs = File.Create(filePath);
                    cfs.Close();
                }
                File.WriteAllText(filePath, json_str, Encoding.UTF8);
                return true;
            }
            catch(Exception e) {
                Console.WriteLine("写文件出错:" + e.Message);
            }
            return false;
        }

        public static JObject getJsonObjFromFile(string fileName = null)
        {
            try
            {
                string filePath = fileName == null ? LocalStorage.getFullFilePath(Define.FILE_SAVE_NAME) : LocalStorage.getFullFilePath(fileName);
                if (!File.Exists(filePath)){
                    FileStream cfs = File.Create(filePath);
                    cfs.Close();
                }
                string filestr = File.ReadAllText(filePath,Encoding.UTF8);
                JObject obj = StringUtils.json_decode(filestr);
                return obj;
            }
            catch (Exception e)
            {
                Console.WriteLine("读取文件出错:" + e.Message);
            }
            return null;
        }

        private static string getFullFilePath(string path)
        {
            return Environment.CurrentDirectory + "\\" + path; //exe所在目录
            //return Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory) + "\\" + path; //桌面
        }

        private static string getAutoFullFilePath() {
            return Environment.CurrentDirectory + "\\" + LocalStorage.getAutoFileName();
        }

        //根据日期，自动生成文件名字
        private static string getAutoFileName()
        {
            var year = DateTime.Now.Year.ToString();
            var month = DateTime.Today.Month.ToString();
            var day = DateTime.Today.Day.ToString();
            var fileName = year + month + day + ".json";
            return fileName;
        }

    }
}
