### 刷机

1. 下载openEuler for D1的镜像：https://mirror.iscas.ac.cn/plct/openEuler-D1-wifi-hdmi-20210817.img.bz2

   ```text
   $ wget https://mirror.iscas.ac.cn/plct/openEuler-D1-wifi-hdmi-20210817.img.bz2
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

   备注：当扩容不成功的时候，可以先对SD卡进行格式化操作后再烧录和扩容。

   

6. 将sd卡放入D1并开机

   可能出现的问题：

   - 刷机后，D1启动不能正常显示：hdmi插拔几次试试。
   
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
   
   [xfce]
   name=xfce
   baseurl=http://121.36.3.168:82/home:/pandora:/xfce/standard_riscv64/
   enabled=1
   gpgcheck=0
   
   [xfce4]
   name=xfce4
   baseurl=http://121.36.3.168:82/home:/pandora:/xfce4/webkit2gtk3/
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
   
   [fedora]
   name=fedora
   baseurl=http://fedora.riscv.rocks/repos/f33-build/latest/riscv64/
   enabled=1
   gpgcheck=0
   ```
   
   


### 安装

./xfce-install.sh 2>&1|tee -a xfce-yum-install.log

安装的过程详情：xfce-yum-install.log

说明：安装过程是手动命令，sh脚本是后续按照执行顺利补充的，sh脚本目的是后续刷机的时候可以快速安装（sh后续继续完善）



### 结果

按照https://www.linuxfromscratch.org/blfs/view/svn/xfce/xfce.html 这个网页中包顺序安装。21个包全部安装成功，但是D1开机依然没有可视化界面显示。



