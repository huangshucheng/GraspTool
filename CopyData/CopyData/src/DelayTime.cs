using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Threading;
using System.Runtime.InteropServices;

namespace CopyData
{
    class DelayTime
    {
        /// 开始一个延时任务
        /// delayTime 延时时长（秒）
        ///延时时间完毕之后执行的函数，支持lambda表达式
        public void startDelayTask(int delayTime, Action taskEndAction)
        {
            Task task = new Task(async () =>
            {
                try
                {
                    await Task.Delay(delayTime * 1000);
                    taskEndAction();
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                }
            });
            task.Start();
        }

        public void delay(int time, Action taskEndAction = null) {
            var task = Task.Run(async delegate
            {
                await Task.Delay(time * 1000);
                if (taskEndAction != null)
                {
                    taskEndAction();
                }
            });
        }

        //例：3秒后执行后面的任务
        /*
            DelayTime.StartDelayTask(3, () =>
            {
                Console.WriteLine("jhccccklklsdfklskdfjkld");
            });
         
         */

        [DllImport("kernel32.dll")]
        static extern uint GetTickCount();

        public void runOnce(uint ms, Action taskEndAction = null)
        {
            uint start = GetTickCount();
            while (GetTickCount() - start < ms) {
                if(taskEndAction != null){
                    taskEndAction();
                }
            }
        }
    }
}
