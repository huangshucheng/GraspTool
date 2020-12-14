using System;
using System.Text;
using System.IO;
using Newtonsoft.Json.Linq;

namespace CopyData
{
    class LocalStorage
    {
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
