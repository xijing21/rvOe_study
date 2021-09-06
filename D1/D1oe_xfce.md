# D1上刷openEuler+xfce镜像并进行测试

参考：

https://zhuanlan.zhihu.com/p/406132856

https://zhuanlan.zhihu.com/p/401285641



## 1. 将openEuler镜像烧录到D1-tf卡并对tf卡进行扩容



```
xx@xx-S1-Series:~$ lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 20.04.2 LTS
Release:	20.04
Codename:	focal

```



在ubuntu20.04下，执行sudo fdisk -l查看TF卡盘符

```
xx@xx-S1-Series:~$ sudo fdisk -l

设备          起点     末尾     扇区  大小 类型
/dev/sda1     2048  1435647  1433600  700M Linux 文件系统
/dev/sda2  1435648  1435711       64   32K HiFive Unleashed FSBL
/dev/sda3  1437696  1454079    16384    8M HiFive Unleashed BBL
/dev/sda4  1454080 20971486 19517407  9.3G Linux 文件系统
xx@xx-S1-Series:~$ 

```



a. 将TF卡放入读卡器，连接上ubuntu20.04_x86主机。

b. 下载或者拷贝oE镜像到ubuntu20.04上：

c. 使用`sudo fdisk -l`通过磁盘大小可以识别出TF卡的盘符，假设是/dev/sdb。

d. 使用dd命令将镜像烧录到TF卡：

```
xx@xx-S1-Series:~/oE/D1$ ll
总用量 843752
drwxrwxr-x 2 xx xx      4096 9月   6 16:45 ./
drwxrwxr-x 6 xx xx      4096 9月   6 16:45 ../
-rw-rw-r-- 1 xx xx 863988260 9月   6 16:46 openEuler-D1-xfce.img.bz2

xx@xx-S1-Series:~/oE/D1$ bzcat openEuler-D1-xfce.img.bz2 | sudo dd of=/dev/sda bs=1M iflag=fullblock oflag=direct conv=fsync status=progress
3245342720字节（3.2 GB，3.0 GiB）已复制，531 s，6.1 MB/s 
记录了3096+1 的读入
记录了3096+1 的写出
3247012352字节（3.2 GB，3.0 GiB）已复制，531.406 s，6.1 MB/s


xx@xx-S1-Series:~/oE/D1$ sudo fdisk -l
设备         起点    末尾    扇区  大小 类型
/dev/sda1   34784   35039     256  128K Linux 文件系统
/dev/sda2   35040   35295     256  128K Linux 文件系统
/dev/sda3   35296  100831   65536   32M Linux 文件系统
/dev/sda4  100832 6341820 6240989    3G Linux 文件系统

```



执行sudo fdisk /dev/sda，对TF卡中的最后一个分区进行扩容

```
xx@xx-S1-Series:~/oE/D1$ sudo fdisk /dev/sda

欢迎使用 fdisk (util-linux 2.34)。
更改将停留在内存中，直到您决定将更改写入磁盘。
使用写入命令前请三思。

检测到混合 GPT。您需要手动同步混合 MBR (用专家命令“M”)

命令(输入 m 获取帮助)： m

帮助：

  GPT
   M   进入 保护/混合 MBR

  常规
   d   删除分区
   F   列出未分区的空闲区
   l   列出已知分区类型
   n   添加新分区
   p   打印分区表
   t   更改分区类型
   v   检查分区表
   i   打印某个分区的相关信息

  杂项
   m   打印此菜单
   x   更多功能(仅限专业人员)

  脚本
   I   从 sfdisk 脚本文件加载磁盘布局
   O   将磁盘布局转储为 sfdisk 脚本文件

  保存并退出
   w   将分区表写入磁盘并退出
   q   退出而不保存更改

  新建空磁盘标签
   g   新建一份 GPT 分区表
   G   新建一份空 GPT (IRIX) 分区表
   o   新建一份的空 DOS 分区表
   s   新建一份空 Sun 分区表


命令(输入 m 获取帮助)： p

Disk /dev/sda：29.74 GiB，31914983424 字节，62333952 个扇区
Disk model: Storage Device  
单元：扇区 / 1 * 512 = 512 字节
扇区大小(逻辑/物理)：512 字节 / 512 字节
I/O 大小(最小/最佳)：512 字节 / 512 字节
磁盘标签类型：gpt
磁盘标识符：EACEFD8D-68B3-493F-868A-5364E0A693D8

设备         起点    末尾    扇区  大小 类型
/dev/sda1   34784   35039     256  128K Linux 文件系统
/dev/sda2   35040   35295     256  128K Linux 文件系统
/dev/sda3   35296  100831   65536   32M Linux 文件系统
/dev/sda4  100832 6341820 6240989    3G Linux 文件系统

命令(输入 m 获取帮助)： d
分区号 (1-4, 默认  4): 4

分区 4 已删除。

命令(输入 m 获取帮助)： n
分区号 (4-128, 默认  4): 4
第一个扇区 (100832-62333918, 默认 102400): 100832
Last sector, +/-sectors or +/-size{K,M,G,T,P} (100832-62333918, 默认 62333918): 

创建了一个新分区 4，类型为“Linux filesystem”，大小为 29.7 GiB。
分区 #4 包含一个 ext4 签名。

您想移除该签名吗？ 是[Y]/否[N]： n

命令(输入 m 获取帮助)： w
该设备包含混合 MBR -- 将只写入 GPT。您需要手动同步 MBR。

分区表已调整。
将调用 ioctl() 来重新读分区表。
正在同步磁盘。

xx@xx-S1-Series:~/oE/D1$ 

```





对最后一个分区执行resize2fs命令来调整分区大小

```
xx@xx-S1-Series:~/oE/D1$ sudo resize2fs /dev/sda4
resize2fs 1.45.5 (07-Jan-2020)
请先运行“e2fsck -f /dev/sda4”。


xx@xx-S1-Series:~/oE/D1$ sudo e2fsck -f /dev/sda4
e2fsck 1.45.5 (07-Jan-2020)
第 1 步：检查inode、块和大小
第 2 步：检查目录结构
第 3 步：检查目录连接性
第 4 步：检查引用计数
第 5 步：检查组概要信息
rootfs：69611/774192 文件（1.3% 为非连续的）， 2932348/3120494 块


xx@xx-S1-Series:~/oE/D1$ sudo resize2fs /dev/sda4
resize2fs 1.45.5 (07-Jan-2020)
将 /dev/sda4 上的文件系统调整为 31116540 个块（每块 1k）。
/dev/sda4 上的文件系统现在为 31116540 个块（每块 1k）。


```

注意，resize2fs一次可能不起作用，可以把TF卡拔出重插，再使用`sudo fdisk -l`和`df -Th`查看磁盘大小，再次resize2fs一下，按照提示，也可能要求执行e2fsck -f /dev/sdb4.

现在烧录完成，之后将TF卡放入D1并开机。





在开机的过程中，建议开启串口进行观察，方便分析问题。

windows上的串口我之前已经安装了，具体的步骤可以参考：[参考文档](https://zhuanlan.zhihu.com/p/406132856)  中的相关内容。



启动过程中的问题：

1.串口提示login后2-3分钟后，HDMI还是未如期显示操作系统的界面

> 解决办法：重新拔插hdmi
>
> 而且曾经在启动过程中插拔hdmi，等到窗口显示login后，还是没有显示，重插拔后好了

 

2.我使用的usbhub+鼠标+键盘 ，鼠标键盘都无法动（操作时是在系统启动后接入的鼠标键盘），等待2-3分钟依然如此。

> 重新插拔usbhub的u口——》未解决问题
>
> 重新插拔鼠标键盘——》未解决问题
>
> 先查好鼠标键盘，重启D1——》ok



显示、鼠标键盘都好了，接下来就开始使用系统了。

