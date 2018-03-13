## 文件要求：

```
1、私钥文件（id_rsa）属性为600；

2、公钥文件（id_rsa.pub）属性为644；
```

## 操作步骤：

```
1、将config/config拷贝至~/.ssh/下，git使用gitkey文件对应的ssh-key，其他使用id_rsa默认文件；

2、将id_rsa、id_rsa.pub拷贝至~/.ssh/下；

3、进入~/.ssh目录，调整文件属性为600和644；

4、执行ssh-add，输出为Identity added: /home/donglei/.ssh/id_rsa (/home/donglei/.ssh/id_rsa)，则增加key成功；

5、连接hover的wifi;

6、执行ssh root@192.168.1.1登陆；

7、执行“/home/linaro/adb/change_mode 1”或“/home/linaro/adb/change_mode 0”来开关adb。
```

## 注意：

```
1、/mnt/persist/adb_flag为当前的adb开关状态，在升级、重置时根据此数据来初始化adb的配置；

2、执行/home/linaro/adb/change_mode时，若没有/mnt/persist/adb_flag文件，则会自动创建。
```

## 问题：

```
1、出现"WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED"问题
   解决方法：
   1）连接hover的wifi；
   2）执行ssh-keygen -R 192.168.1.1；
   3）执行ssh root@192.168.1.1，Are you sure you want to continue (yes/no)?选yes，并回车即可访问飞机了;

2、发现"adb被打开后，重新启动系统adb又被关闭了"问题
   背景：
   一批在2016年10月18日至2016年11月12日出厂的机器未关adb，因此在应用程序中，判断在这期间的机器重启后均强制关闭adb。

   机器电源插口的S/N号说明：
   FFB2US：固定，源定义为富士康生产发往美国的机器；
   第7位： 年，M为2016，因此N为2017；
   第8位： 月，1-12分别为1-9，X,Y,Z；
   第9位： 日，1-31分别为1-9，A-V；
   后4位： 当天的生产台数；

   解决方法：
   1、重新开启adb；
   2、adb shell进入板级linux系统后，将/home/linaro/manage/set_env中的/home/linaro/manage/check_adb这一行注释掉；
```

