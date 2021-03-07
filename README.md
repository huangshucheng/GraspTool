# GraspTool

项目介绍：https数据包接收和发送工具。支持代理抓包，Fidder抓包，抓包后的数据发送至本软件，软件通过抓到的数据包，可通过lua脚本修改数据包参数，请求头，请求数据等，重新提交到远程服务器。

软件用途：不管是PC还是手机端, 可抓包修改数据， 修改游戏排行榜，秒杀，抓微信CK抢自动红包等等，理论上只要有https请求的数据都可行。

HCCFidderExtension项目：FD的插件， 请求数据通过copyData发送至软件，可在本机抓包，速度极快，将HCCFidderExtension项目下的HCCFidderExtension.dll， Newtonsoft.Json.dll 两个文件拷贝到Fidder安装目录下的Script文件夹下，软件就能收到数据包。

python_proj项目： 手机设置代理后数据包通过anyproxy代理发送至本软件，软件收到数据包后可自行修改数据再次请求。



技术栈：winform,  lua脚本, Fidder插件，anyproxy 代理工具 。

软件c# 写的，接口导至lua脚本，lua脚本写请求逻辑，很方便。

欢迎交流!

QQ:827773271