# 架构图


我们是怎么构建的呢，用什么工具构建的呢？基本原理又是怎样的呢？
这里我们先上个图：
![image.png](https://cdn.nlark.com/yuque/0/2021/png/12590933/1625210921922-8d6bd892-31c1-4913-91d7-ec0bbbb2931e.png#align=left&display=inline&height=1321&margin=%5Bobject%20Object%5D&name=image.png&originHeight=1321&originWidth=2560&size=2680235&status=done&style=none&width=2560)


# 基本概念
_为了大家更好的对应，下面的名称与上图是对应的，请仔细查看。_
_

- 上游开源社区
- openEuler社区源码仓
- OBS（这里对应图中的OBS server和OBS worker的概念）
- OBS Publish REPO
- openEuler REPO



主要的逻辑关系如下：

- openEuler社区源码仓，涵盖了OBS构建所需的所有源码包（至少是当前定义的所有需要构建的软件包的源码），obs构建的所有软件包的源码都从这里来。
- 如果想要在当前的系统构建中添加一个当前系统中没有的软件包：
   - 先去gitee源码仓找，源码仓有则将该软件配置到该系统对应的obs project中去
   - gitee源码仓没有的，就需要去上游的开源社区，将软件包的源码添加到gitee的源码仓中
- OBS构建的软件包的源码都是从gitee中来的，经由obs构建集群完成构建。
   - 构建成功：源码包和二进制包（rpm）将发布到OBS Publish REPO
   - 构建失败：不生成任何与包相关文件
- 软件包的构建过程由OBS完成
- [openEuler:Mainline:RISC-V](https://build.openeuler.org/project/show/openEuler:Mainline:RISC-V) project构建信息可在此查看：[https://build.openeuler.org/project/show/openEuler:Mainline:RISC-V](https://build.openeuler.org/project/show/openEuler:Mainline:RISC-V)



# 构建原理简述


todo




# OBS构建知识
## obs基础知识
[openEuler构建之OBS使用指导](https://www.bilibili.com/video/BV1YK411H7E2) 【新人适合，强烈推荐】
[视频学习笔记-OBS简介与在线使用说明](https://riscv-tarsier.yuque.com/docs/share/1056bbf8-8eef-481d-9203-9c2836d7d516?# 《OBS简介与在线使用说明》)
![openEuler OBS.png](https://cdn.nlark.com/yuque/0/2021/png/12590933/1627515802993-324d1ff2-51a8-4a49-a8e4-8b7a91060172.png#align=left&display=inline&height=1722&margin=%5Bobject%20Object%5D&name=openEuler%20OBS.png&originHeight=1722&originWidth=2166&size=495947&status=done&style=none&width=2166)

[Open Build Service User Guide](https://openbuildservice.org/help/manuals/obs-user-guide)




## [openEuler:Mainline:RISC-V](https://build.openeuler.org/project/show/openEuler:Mainline:RISC-V)的构建
### 1 包的构建简介
这里的构建，指的是OBS构建集群，对gitee中的所有源码包进行构建编译，从源码包生成rpm包的过程。
![](https://cdn.nlark.com/yuque/0/2021/png/12590933/1627467399826-a5f4832d-5667-40f9-943d-63da9cb3dd23.png#align=left&display=inline&height=663&margin=%5Bobject%20Object%5D&originHeight=663&originWidth=1262&status=done&style=none&width=1262)
①：是从gitee的源码库中，将源代码构建成rpm包的过程。
②：是直接将gitee的源码进行打包，生成源码包的过程。
上述①和②的是从执行上来说，是一个任务。构建成功则同时生成源码包和rpm包。失败则osb publish repo中没有该packages的任何包。
在OBS Publish REPO中，至少存在两种类型的包：

1. 源码包：.tar.gz  src.rpm
1. rpm包：.rpm 二进制包



### 2 构建信息查看
网址：[https://build.openeuler.org/project/show/openEuler:Mainline:RISC-V](https://build.openeuler.org/project/show/openEuler:Mainline:RISC-V)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/12590933/1627485447018-0b4dccd4-f0b3-4502-833e-08eb914f1e01.png#align=left&display=inline&height=1045&margin=%5Bobject%20Object%5D&name=image.png&originHeight=1045&originWidth=1531&size=182222&status=done&style=none&width=1531)

![image.png](https://cdn.nlark.com/yuque/0/2021/png/12590933/1627485566400-f8a1c83c-ffbf-4dca-a2d1-0d1b53676e25.png#align=left&display=inline&height=509&margin=%5Bobject%20Object%5D&name=image.png&originHeight=509&originWidth=1179&size=57316&status=done&style=none&width=1179)

### 3 如何解决构建失败问题
1、[如何查看构建失败的包？如何查看构建失败原因？](https://riscv-tarsier.yuque.com/docs/share/3b617b70-3aea-463d-aa15-bc4365aa524c?# 《查看构建失败原因》)
2、[如何解决RISC-V的构建失败问题？-思路篇](https://gitee.com/openeuler/RISC-V/issues/I1U0YD?from=project-issue)

- [操作篇：本地openEuler RISC-V 环境搭建-ubuntu20.04amd64](https://riscv-tarsier.yuque.com/docs/share/568fc7c8-637a-415e-b09b-7a205eb67e75?# 《本地openEuler RISC-V 环境搭建-ubuntu20.04amd64》)
- 本地构建：[https://docs.openeuler.org/zh/docs/20.09/docs/ApplicationDev/%E6%9E%84%E5%BB%BARPM%E5%8C%85.html](https://docs.openeuler.org/zh/docs/20.09/docs/ApplicationDev/%E6%9E%84%E5%BB%BARPM%E5%8C%85.html)
- 




### 问题
1、参考openEuler riscv发展历程，【第一版rootfs和kernel镜像 500+ packages】是怎么构建出来的？
>     1. 最初会有一个 rootfs（bootstrap 0） （100 个软件组成）
>     2. 基于 rootfs 编译 100 个（gcc binutils），生成二进制包 -> REPO ： HTTP STATIC SERVER
>     3. 用自迭代编译的 100 个包构建 rootfs（bootstrap 1）
>     4. 用 rootfs（bootstrap 1）编译构建更多的包 200+
>     5. 用rootfs（bootstrap 1）+ 200 ->  编译构建更多的包 1000+
> 后面每次构建成功的包（假设200+，比上一次更多），都会被添加到obs的依赖仓中去，然后再次构建的时候，因为依赖仓中的包已经变多了，会让更多的包构建成功（500+），再把新构建成功的500+包加入到依赖仓。。。。如此循环，会让更多的包构建成功。




2、我们现在为什么会有那么多包构建失败？
> 1. 依赖问题
> 1. 版本问题：版本不一致
> 1. 对 RISC-V 支持问题，x86_64 aarch64
> 
gcc / linux 都支持了
> golang / nodejs 部分支持 risc-v
> 4. spec 文件（rpm 构建配置，makefile）



3、我们是怎么决定哪些软件包需要被操作系统支持的？
> 目前来说并没有严格的定义，基本上是参考其它linux操作系统支持的软件包。
> 当前加入的软件包有4128个，这4128是openEuler （x86、aarch64）支持的一些软件包。
> 这些包如果能够构建成功，最终都是需要加入openEuler riscv的；如果构建失败，则按照问题解决的进度来考虑什么时候加入，在哪个版本加入；
> 软件包的需求是动态调整的，当有明确的需求需要加入一些未引进的包时，这个时候，我们就把这个包的源码引入进来。



4、我们如何将软件包添加到Project的构建任务中的？
> 在Project的某些配置文件定义。一般由专人维护，大家了解即可。



