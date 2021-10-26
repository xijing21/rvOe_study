### 刷机

1. 下载openEuler for D1的镜像：https://mirror.iscas.ac.cn/plct/openEuler-D1-wifi-hdmi-20210817.img.bz2

   ```text
   $ wget https://mirror.iscas.ac.cn/plct/openEuler-D1-20210731.img.bz2
   ```



2. 查看sd卡的盘符：


```text
sudo fdisk -l
```

Disk /dev/sda：29.74 GiB，31914983424 字节，62333952 个扇区
Disk model: Storage Device  
单元：扇区 / 1 * 512 = 512 字节
扇区大小(逻辑/物理)：512 字节 / 512 字节
I/O 大小(最小/最佳)：512 字节 / 512 字节
磁盘标签类型：gpt
磁盘标识符：EACEFD8D-68B3-493F-868A-5364E0A693D8

设备         起点     末尾     扇区  大小 类型
/dev/sda1   34784    35039      256  128K Linux 文件系统
/dev/sda2   35040    35295      256  128K Linux 文件系统
/dev/sda3   35296   100831    65536   32M Linux 文件系统
/dev/sda4  100832 62333918 62233087 29.7G Linux 文件系统



3. 使用dd命令将镜像烧录到sd卡中：

   ```text
   bzcat openEuler-D1-wifi-hdmi-20210817.img.bz2 | sudo dd of=/dev/sda bs=1M iflag=fullblock oflag=direct conv=fsync status=progress
   
   1341128704字节（1.3 GB，1.2 GiB）已复制，215 s，6.2 MB/s 
   记录了1279+0 的读入
   记录了1279+0 的写出
   1341128704字节（1.3 GB，1.2 GiB）已复制，215.102 s，6.2 MB/s
   
   ```



4. 使用fdisk进行扩容

   ```
   xijing@xijing-S1-Series:~/oE/D1$ sudo fdisk /dev/sda
   
   欢迎使用 fdisk (util-linux 2.34)。
   更改将停留在内存中，直到您决定将更改写入磁盘。
   使用写入命令前请三思。
   
   检测到混合 GPT。您需要手动同步混合 MBR (用专家命令“M”)
   
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
   /dev/sda4  100832 2619391 2518560  1.2G Linux 文件系统
   
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
   正在同步磁盘。
   
   ```

5. 对第四个分区执行resize2fs命令：

   ```
   sudo e2fsck -f -y /dev/sda4
   
   如出现提示，一路y
   
   
   xijing@xijing-S1-Series:~/oE/D1$ sudo resize2fs /dev/sda4
   resize2fs 1.45.5 (07-Jan-2020)
   文件系统已经为 31116540 个块（每块 1k）。无需进一步处理！
   
   ```

   

6. 将sd卡放入D1并开机

   第一次未能成功启动，刷第2次后增加执行resize2fs时提示需要先执行e2fsck，然后有提示，一路y，完成后再次能正常启动了

   hdmi依然需要插拔2次才有显示。
   
   
   
   经常出现的问题：
   
   - 刷机后，D1启动不能正常进入到输入用户名、密码界面：重刷
   - 进入系统后，df -h检查系统/容量，不是29G（一般是1.2G）则扩容不成功，建议重新执行扩容操作。否则后续会出现/空间不够的情况。
   
   



### 使用

1. 登录

   用户名：root

   密码：openEuler12#$

2. 检查磁盘空间:/ 的可用空间接近扩容的磁盘容量。

   **32G的sd卡，基本上在29G左右算是正常，否则就是扩容没有成功，建议重新执行扩容操作，否则后续会存在 / 空间不足的情况。**同样的操作，我尝试过，有时候成功，有时候/只有1.2G;

   必要时，先对SD卡进行格式化操作后再烧录。——》目前大部分情况我没有格式化sd卡，有时候也是能扩容成功的，所以格式化不是必须的。

   df -h

   ```
   [root@openEuler-RISCV-rare ~]# df -h
   Filesystem      Size  Used Avail Use% Mounted on
   /dev/root        29G  1.1G   27G   4% /
   devtmpfs        492M     0  492M   0% /dev
   tmpfs           496M     0  496M   0% /dev/shm
   tmpfs           496M  1.7M  495M   1% /run
   tmpfs           496M     0  496M   0% /sys/fs/cgroup
   tmpfs           496M     0  496M   0% /tmp
   tmpfs           100M     0  100M   0% /run/user/0
   
   ```

   

3. 检查和设置网络

   配置无线网络：nmtui

   查看ip地址：ifconfig

4. 远程ssh登录（为了方便操作建议ssh登录D1linux系统）

   ssh root@hostip

5. 检查时间，日期时间不对则进行修改

   查日期：date

   修改日期为当前的时间，如： date -s "2021-10-14 13:21"

6. 设置源：vim /etc/yum.repos.d/oe-rv.repo

   ```
   [webkit2gtk3]
   name=webkit2gtk3
   baseurl=http://121.36.3.168:82/home:/pandora:/webkit2gtk3/standard_riscv64/
   enabled=1
   gpgcheck=0
   
   [unresolvable2]
   name=unresolvable2
   baseurl=http://121.36.3.168:82/home:/pandora:/unresolvable2/standard_riscv64/
   enabled=1
   gpgcheck=0
   
   [lxde]
   name=lxde
   baseurl=http://121.36.3.168:82/home:/pandora:/lxde/lxde_riscv64/
   enabled=1
   gpgcheck=0
   
   [mainline]
   name=mainline
   baseurl=http://119.3.219.20:82/openEuler:/Mainline:/RISC-V/standard_riscv64/
   enabled=1
   gpgcheck=0
   
   [preview]
   name=preview
   baseurl=https://repo.openeuler.org/openEuler-preview/RISC-V/everything/
   enabled=1
   gpgcheck=0
   
   [base]
   name=base
   baseurl=https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/oe-RISCV-repo/
   enabled=1
   gpgcheck=0
   
   [oe-noarch]
   name=oe-noarch
   baseurl=http://repo.openeuler.org/openEuler-20.03-LTS/everything/aarch64
   enabled=1
   gpgcheck=0
   
   [oe2109]
   name=oe2109
   baseurl=http://repo.openeuler.org/openEuler-21.09/everything/aarch64
   enabled=0
   gpgcheck=0
   
   
   [fedora]
   name=fedora
   baseurl=http://fedora.riscv.rocks/repos/f33-build/latest/riscv64/
   enabled=1
   gpgcheck=0
   
   ```

   更新源：yum update

   需要时执行：yum clean all && yum makecache

   

   ### lxde安装

   参考lxde-install.sh 的顺利和备注。

   

   ### 结论

   

   1、按照https://www.linuxfromscratch.org/blfs/view/svn/lxde/lxde.html  这个网页中包顺序安装。

   在添加上述列表中fedora的源后，全部17个包都安装成功。但是D1开机依然没有可视化界面显示。

   

   2、对https://build.openeuler.org/project/show/home:pandora:lxde 罗列的38-17个包进行安装排查：

   检查之后，发现有：setools  samba  policycoreutils mozjs60 krb5  bind python-parameterized  python-cov-core  python-nose2 libstoragemgmt  selinux-policy

   这几个包没有被安装。说明以上这些包不是lxde桌面17个包所需的安装依赖，可以从obs-lxde列表中移除。

   

   3、由于D1启动没有进入可视化界面，对剩余的包进行安装尝试：

   可成功安装：

   第一轮：setools  samba  policycoreutils mozjs60 krb5  bind 

   第二轮：python-parameterized   python-nose2   

   按照python-cov-core提示引导成功安装：python3-gpgme

   最后成功安装了 selinux-policy ——》但是一旦安装这个包，D1镜像就启动不起来了（操作3次，每次都能复现）。
   
   ```
   [02.113][mmc]: MMC Device 2 not found
   [02.116][mmc]: mmc 2 not find, so not exit
   [    0.421237] uart uart0: get regulator failed
   [    0.427873] uart uart1: get regulator failed
   [    0.447779] sunxi-rfkill soc@3000000:rfkill@0: get gpio chip_en failed
   [    0.455388] sunxi-rfkill soc@3000000:rfkill@0: get gpio power_en failed
   [    0.612460] sunxi-mmc 4021000.sdmmc: smc 1 p1 err, cmd 52, RTO !!
   [    0.620453] sunxi-mmc 4021000.sdmmc: smc 1 p1 err, cmd 52, RTO !!
   [    0.640456] sunxi-mmc 4021000.sdmmc: smc 1 p1 err, cmd 5, RTO !!
   [    0.648295] sunxi-mmc 4021000.sdmmc: smc 1 p1 err, cmd 5, RTO !!
   [    0.655998] debugfs: Directory '203034c.dummy_cpudai' with parent 'audiocodec' already present!
   [    0.667295] sunxi-mmc 4021000.sdmmc: smc 1 p1 err, cmd 5, RTO !!
   [    0.675284] sunxi-mmc 4021000.sdmmc: smc 1 p1 err, cmd 5, RTO !!
   [    0.692592] ERROR: pinctrl_get for HDMI2.0 DDC fail
   [    0.743153] debugfs: Directory '2034000.daudio' with parent 'sndhdmi' already present!
   [    1.196523] [HDMI2 error]: sink do not support this mode:0
   [    1.712267] systemd[1]: Failed to load SELinux policy.
   [    1.737526] systemd[1]: Freezing execution.
   
   ```

   

   最终都没有成功安装的包：python-cov-core（python3-cov-core）、libstoragemgmt

   

   

   待解决问题：

   1. 每次安装 selinux-policy包后，D1重启就无法正常进入系统，报错：

   ![image-20211026230130601](images/image-20211026230130601.png)

   

   

   2. yum install的时候，总是提示：/sbin/ldconfig: /lib64/lp64d/libhunspell-1.6.so.0 is not a symbolic link

   3. 明明系统中已经安装了python2.7和python3.7.4  ，且python3-gpgme也安装成功；但是安装python3-cov-core 的时候，依然报错：
   
   ```
   [root@openEuler-RISCV-rare ~]# python --version
   Python 2.7.16
   [root@openEuler-RISCV-rare ~]# python3 --version
   Python 3.7.4
   [root@openEuler-RISCV-rare ~]# yum install python3-gpgme  2>&1|tee -a lxde-yum-install-1.log
   Last metadata expiration check: 0:44:34 ago on Tue Oct 26 13:15:23 2021.
   Package python3-gpgme-1.13.1-5.oe1.riscv64 is already installed.
   Dependencies resolved.
   ================================================================================
    Package              Architecture   Version              Repository       Size
   ================================================================================
   Upgrading:
    gpgme                riscv64        1.15.1-1.oe1         mainline        327 k
    python3-gpgme        riscv64        1.15.1-1.oe1         mainline        228 k
   
   Transaction Summary
   ================================================================================
   Upgrade  2 Packages
   
   Total download size: 556 k
   Is this ok [y/N]: y
   Downloading Packages:
   (1/2): python3-gpgme-1.15.1-1.oe1.riscv64.rpm   913 kB/s | 228 kB     00:00    
   (2/2): gpgme-1.15.1-1.oe1.riscv64.rpm           1.1 MB/s | 327 kB     00:00    
   --------------------------------------------------------------------------------
   Total                                           1.7 MB/s | 556 kB     00:00     
   Running transaction check
   Transaction check succeeded.
   Running transaction test
   Transaction test succeeded.
   Running transaction
     Preparing        :                                                        1/1 
     Upgrading        : gpgme-1.15.1-1.oe1.riscv64                             1/4 
     Upgrading        : python3-gpgme-1.15.1-1.oe1.riscv64                     2/4 
     Cleanup          : python3-gpgme-1.13.1-5.oe1.riscv64                     3/4 
     Cleanup          : gpgme-1.13.1-5.oe1.riscv64                             4/4 
     Running scriptlet: gpgme-1.13.1-5.oe1.riscv64                             4/4 
   /sbin/ldconfig: /lib64/lp64d/libhunspell-1.6.so.0 is not a symbolic link
   
   
   /sbin/ldconfig: /lib64/lp64d/libhunspell-1.6.so.0 is not a symbolic link
   
   
     Verifying        : gpgme-1.15.1-1.oe1.riscv64                             1/4 
     Verifying        : gpgme-1.13.1-5.oe1.riscv64                             2/4 
     Verifying        : python3-gpgme-1.15.1-1.oe1.riscv64                     3/4 
     Verifying        : python3-gpgme-1.13.1-5.oe1.riscv64                     4/4 
   
   Upgraded:
     gpgme-1.15.1-1.oe1.riscv64         python3-gpgme-1.15.1-1.oe1.riscv64        
   
   Complete!
   
   
   
   
   
   [root@openEuler-RISCV-rare ~]# yum install python3-cov-core  2>&1|tee -a lxde-yum-install-1.log
   Last metadata expiration check: 0:46:31 ago on Tue Oct 26 13:15:23 2021.
   Package python3-cov-core-1.15.0-1.oe1.noarch is already installed.
   Error: 
    Problem: problem with installed package python3-gpgme-1.15.1-1.oe1.riscv64
     - package python3-gpgme-1.15.1-1.oe1.riscv64 requires python(abi) = 3.7, but none of the providers can be installed
     - package python3-gpgme-1.13.1-5.oe1.riscv64 requires python(abi) = 3.7, but none of the providers can be installed
     - package python3-gpgme-1.13.1-5.riscv64 requires python(abi) = 3.7, but none of the providers can be installed
     - cannot install both python3-3.9.7-1.0.riscv64.fc33.riscv64 and python3-3.7.4-8.riscv64
     - package python3-cov-core-1.15.0-20.fc33.noarch requires python(abi) = 3.9, but none of the providers can be installed
     - cannot install the best candidate for the job
   (try to add '--allowerasing' to command line to replace conflicting packages or '--skip-broken' to skip uninstallable packages or '--nobest' to use not only best candidate packages)
   
   
   
   ```

   

   4. libstoragemgmt
   
   ```
   [root@openEuler-RISCV-rare ~]# yum install libstoragemgmt 2>&1|tee -a lxde-yum-install-1.log
   Last metadata expiration check: 0:29:12 ago on Tue Oct 26 13:15:23 2021.
   Error: 
    Problem: package python3-libstoragemgmt-1.8.0-6.oe1.noarch requires libstoragemgmt = 1.8.0-6.oe1, but none of the providers can be installed
     - package libstoragemgmt-1.8.2-1.0.riscv64.fc32.riscv64 requires python3-libstoragemgmt, but none of the providers can be installed
     - cannot install both libstoragemgmt-1.8.2-1.0.riscv64.fc32.riscv64 and libstoragemgmt-1.8.0-6.oe1.riscv64
     - cannot install the best candidate for the job
     - nothing provides libstoragemgmt = 1.8.0-3.oe1 needed by python3-libstoragemgmt-1.8.0-3.oe1.noarch
     - nothing provides python(abi) = 3.8 needed by python3-libstoragemgmt-1.8.2-1.0.riscv64.fc32.noarch
   (try to add '--allowerasing' to command line to replace conflicting packages or '--skip-broken' to skip uninstallable packages or '--nobest' to use not only best candidate packages)
   
   
   
   [root@openEuler-RISCV-rare ~]# yum install python3-libstoragemgmt 2>&1|tee -a lxde-yum-install-1.log
   Last metadata expiration check: 0:31:48 ago on Tue Oct 26 13:15:23 2021.
   Error: 
    Problem: cannot install the best candidate for the job
     - nothing provides python(abi) = 3.8 needed by python3-libstoragemgmt-1.8.2-1.0.riscv64.fc32.noarch
   (try to add '--skip-broken' to skip uninstallable packages or '--nobest' to use not only best candidate packages)
   ```

   
   
   

