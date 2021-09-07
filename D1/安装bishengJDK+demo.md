1. 检查或安装jdk环境

   ```
   [root@openEuler-RISCV-rare ~]# java -version
   openjdk version "11.0.11" 2021-04-20
   OpenJDK Runtime Environment Bisheng (build 11.0.11+9)
   OpenJDK 64-Bit Server VM Bisheng (build 11.0.11+9, mixed mode, sharing)
   [root@openEuler-RISCV-rare ~]#     
   
   ```

   

2. 运行jar包

   ```
   git clone https://gitee.com/blesschess/LuckyLudii.git
   cd LuckyLudii/libs
   java -jar LuckyLudii3.3.jar
   ```




wget错误：

```
[root@openEuler-RISCV-rare d1]# wget https://gitee.com/blesschess/LuckyLudii/blob/master/libs/LuckyLudii3.3.jar
--2021-09-07 18:26:51--  https://gitee.com/blesschess/LuckyLudii/blob/master/libs/LuckyLudii3.3.jar
Illegal instruction (core dumped)


[root@openEuler-RISCV-rare d1]# wget https://files.cnblogs.com/files/xiaochina/simsun.zip
--2021-09-07 19:30:51--  https://files.cnblogs.com/files/xiaochina/simsun.zip
Illegal instruction (core dumped)
[root@openEuler-RISCV-rare d1]# ls

```





## 解决中文问题

```
[root@openEuler-RISCV-rare d1]# wget https://files.cnblogs.com/files/xiaochina/simsun.zip
--2021-09-07 19:30:51--  https://files.cnblogs.com/files/xiaochina/simsun.zip
Illegal instruction (core dumped)
[root@openEuler-RISCV-rare d1]# ls
LuckyLudii
[root@openEuler-RISCV-rare d1]# ls
LuckyLudii  simsun.zip
[root@openEuler-RISCV-rare d1]# unzip simsun.zip 
Archive:  simsun.zip
  inflating: simsun.ttc              
[root@openEuler-RISCV-rare d1]# ls
LuckyLudii  simsun.ttc  simsun.zip
[root@openEuler-RISCV-rare d1]# cp simsun.ttc /usr/share/fonts/
[root@openEuler-RISCV-rare d1]# mkfontscale
-bash: mkfontscale: command not found
[root@openEuler-RISCV-rare d1]# mkfontscale
-bash: mkfontscale: command not found
[root@openEuler-RISCV-rare d1]# yum install mkfontscale
Last metadata expiration check: 0:57:50 ago on Tue Sep  7 18:48:23 2021.
Dependencies resolved.
==================================================================================================================================
 Package                                Architecture               Version                           Repository              Size
==================================================================================================================================
Installing:
 xorg-x11-font-utils                    riscv64                    1:7.5-43.oe1                      obs                     83 k

Transaction Summary
==================================================================================================================================
Install  1 Package

Total download size: 83 k
Installed size: 338 k
Is this ok [y/N]: y
Downloading Packages:
xorg-x11-font-utils-7.5-43.oe1.riscv64.rpm                                                        310 kB/s |  83 kB     00:00    
----------------------------------------------------------------------------------------------------------------------------------
Total                                                                                             288 kB/s |  83 kB     00:00     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                          1/1 
  Installing       : xorg-x11-font-utils-1:7.5-43.oe1.riscv64                                                                 1/1 
  Running scriptlet: xorg-x11-font-utils-1:7.5-43.oe1.riscv64                                                                 1/1 
/sbin/ldconfig: /lib64/lp64d/libhunspell-1.6.so.0 is not a symbolic link


  Verifying        : xorg-x11-font-utils-1:7.5-43.oe1.riscv64                                                                 1/1 

Installed:
  xorg-x11-font-utils-1:7.5-43.oe1.riscv64                                                                                        

Complete!
[root@openEuler-RISCV-rare d1]# mkfontscale
[root@openEuler-RISCV-rare d1]# ls       
LuckyLudii  fonts.scale  simsun.ttc  simsun.zip
[root@openEuler-RISCV-rare d1]# mkfontdir
[root@openEuler-RISCV-rare d1]# ls
LuckyLudii  fonts.dir  fonts.scale  simsun.ttc  simsun.zip
[root@openEuler-RISCV-rare d1]# cd
[root@openEuler-RISCV-rare ~]# ll
total 2.0K
drwxr-xr-x 2 root root 1.0K Sep  7 18:38 Desktop
drwxr-xr-x 3 root root 1.0K Sep  7 19:47 d1
[root@openEuler-RISCV-rare ~]# mkfontdir
[root@openEuler-RISCV-rare ~]# ls
Desktop  d1  fonts.dir
[root@openEuler-RISCV-rare ~]# fc-cache -fv
/usr/share/fonts: caching, new cache contents: 2 fonts, 2 dirs
/usr/share/fonts/cantarell: caching, new cache contents: 5 fonts, 0 dirs
/usr/share/fonts/dejavu: caching, new cache contents: 42 fonts, 0 dirs
/usr/share/X11/fonts/Type1: skipping, no such directory
/usr/share/X11/fonts/TTF: skipping, no such directory
/usr/local/share/fonts: skipping, no such directory
/root/.local/share/fonts: skipping, no such directory
/root/.fonts: skipping, no such directory
/usr/share/fonts/cantarell: skipping, looped directory detected
/usr/share/fonts/dejavu: skipping, looped directory detected
/usr/lib/fontconfig/cache: cleaning cache directory
/root/.cache/fontconfig: not cleaning non-existent cache directory
/root/.fontconfig: not cleaning non-existent cache directory
/usr/bin/fc-cache-64: succeeded
[root@openEuler-RISCV-rare ~]# 

```

