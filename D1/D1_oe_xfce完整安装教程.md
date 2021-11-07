# D1上刷openEuler+xfce镜像并进行测试

## 1. 镜像烧录

```
$ lsb_release -a
```

在ubuntu20.04下，执行sudo fdisk -l查看TF卡盘符

```
$ sudo fdisk -l
```

a. 将TF卡放入读卡器，连接上ubuntu20.04_x86主机。

b. 下载或者拷贝oE镜像到ubuntu20.04上：

c. 使用`sudo fdisk -l`通过磁盘大小可以识别出TF卡的盘符，假设是/dev/sdb。

d. 使用dd命令将镜像烧录到TF卡：

```
$ bzcat openEuler-D1-xfce.img.bz2 | sudo dd of=/dev/sda bs=1M iflag=fullblock oflag=direct conv=fsync status=progress

$ sudo fdisk -l
```



执行sudo fdisk /dev/sda，对TF卡中的最后一个分区进行扩容

```
$ sudo fdisk /dev/sda

p
d
4
n
4
100832
回车
n
w
```



## 2.分区扩容

对最后一个分区执行resize2fs命令来调整分区大小

```
$ sudo e2fsck -f /dev/sda4
$ sudo resize2fs /dev/sda4
```

注意，resize2fs一次可能不起作用，可以把TF卡拔出重插，再使用`sudo fdisk -l`和`df -Th`查看磁盘大小，再次resize2fs一下，按照提示，也可能要求执行e2fsck -f /dev/sdb4.

现在烧录完成，之后将TF卡放入D1并开机。



## 3.更新内核

1. 将k1包拷贝到u盘

2. 将u盘插入D1

3. fdisk -l

   查到u盘为：/dev/sda1

4. 挂载u盘，将带更新的k1.tar.gz拷贝到D1上（/mypkgs）

   ```
   mkdir upan   #pwd:/upan
   mkdir mypkgs   #pwd:/mypkgs
   
   mount /dev/sda1 /upan    #将u盘挂载到/upan下
   
   cd /upan  #就能访问U盘中的文件了
   
   cp k1.tar.gz /mypkgs
   umount /upan   #卸载
   ```

5. 更新前准备：

   ```
   cd /mypkgs
   
   mkdir k1
   tar -xzvf k1.tar.gz -C k1
   
   cd k1
   ls -l
   ```

5. 更新boot.img:

   ```
   # 挂载boot分区:
   mount /dev/mmcblk0p3 /mnt
   
   # 更新boot.img
   cp /mypkgs/k1/boot.img /mnt
    
   # 卸载
   umount /mnt
   ```

6. 更新驱动: 

   ```
   cp -rf /mypkgs/k1/rootfs/lib/ /usr/lib/
   ```

8. 断电重启D1

   > 发现分辨率有明显提升。



## 4.系统完善

1. wifi设置

   nmtui

2. 检查时间

   date

3. 支持ping

   yum install iputils

4. 支持中文

   ```
   #wget https://files.cnblogs.com/files/xiaochina/simsun.zip
   curl -o simsun.zip -L https://files.cnblogs.com/files/xiaochina/simsun.zip
   unzip simsun.zip
   cp simsun.ttc /usr/share/fonts/
   mkfontscale
   mkfontdir
   fc-cache -fv
   ```

5. 中文输入法

   在https://repo.openeuler.org/openEuler-preview/RISC-V/everything/rpms/ 查了一下ibus和fcitx，有ibus的安装包。试试是否能够安装并使用

   ```
   [root@openEuler-RISCV-rare ~]# yum install ibus-libpinyin
   Last metadata expiration check: 1:05:22 ago on Tue Sep  7 15:46:48 2021.
   Error: 
    Problem: cannot install the best candidate for the job
     - nothing provides libibus-1.0.so.5()(64bit) needed by ibus-libpinyin-1.10.0-6.riscv64
     - nothing provides liblua-5.4.so()(64bit) needed by ibus-libpinyin-1.10.0-6.riscv64
     - nothing provides ibus >= 1.5.11 needed by ibus-libpinyin-1.10.0-6.riscv64
   (try to add '--skip-broken' to skip uninstallable packages or '--nobest' to use not only best candidate packages)
   [root@openEuler-RISCV-rare ~]# 
   ```

   

## 5.java环境

安装java环境并运行下棋游戏demo

1. 检查或安装jdk环境

   ```
   $ java -version
   ```
   
2. 运行jar包

   ```
   git clone https://gitee.com/blesschess/LuckyLudii.git
   cd LuckyLudii/libs
   java -jar LuckyLudii3.3.jar
   ```




