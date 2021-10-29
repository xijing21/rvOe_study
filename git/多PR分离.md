面临的问题：

1. plct/PLCT-Weekly  [master]——fork——》xijing21/PLCT-Weekly  [master]

2. xijing21/PLCT-Weekly  [master]之前提交了一个PR到   plct/PLCT-Weekly  [master]；但是由于一些原因，这个PR不打算合并，也不打算关闭，准备保持一种open的状态；

3. 过了一段时间，xijing21/PLCT-Weekly  又需要提交了一个PR到   plct/PLCT-Weekly  [master]；这个时候发现，提交的内容自动合入了原来的PR中，没有新建一个单独的pr请求。（就是只有一个pr请求，但是合并的内容和文件数已经更新到了原来的pr中，但是我想要的是在不影响原来pr的情况下，为本次的更新新建一个全新的pr）——》结果就是，上次的pr可以不合并，本次的pr希望得到合并；

   

解决思路：

xijing21/PLCT-Weekly 中以一个新的分支，向plct/PLCT-Weekly  [master] 提交PR即可解决。

我的思路是：

1. 从plct/PLCT-Weekly  [master]   clone到本地pc（local）
2. 在local新增remote：xijing21/PLCT-Weekly
3. local新建一个分支A
4. local切换分支A
5. 在A分支上，修改文档内容
6. 将local A分支提交到remote：xijing21/PLCT-Weekly
7. 从remote：xijing21/PLCT-Weekly 新建一个 A分支的pr 提交到plct/PLCT-Weekly  [master]



具体操作：

1. $ git clone https://github.com/plctlab/PLCT-Weekly.git

2. $ git remote add xijing21 https://github.com/xijing21/PLCT-Weekly.git

3. $ git remote -v
   origin  https://github.com/plctlab/PLCT-Weekly.git (fetch)
   origin  https://github.com/plctlab/PLCT-Weekly.git (push)
   xijing21        https://github.com/xijing21/PLCT-Weekly.git (fetch)
   xijing21        https://github.com/xijing21/PLCT-Weekly.git (push)

4. $ git branch -a
   * master
     remotes/origin/HEAD -> origin/master
     remotes/origin/master

5. $ git branch report202111

6. $ git branch -a
   * master
     report202111
     remotes/origin/HEAD -> origin/master
     remotes/origin/master

7. $ git checkout report202111
   Switched to branch 'report202111'

8. $ git branch -a
     master
   * report202111
     remotes/origin/HEAD -> origin/master
     remotes/origin/master

9. 修改文档内容

10. $ git status
    On branch report202111
    Changes not staged for commit:
      (use "git add <file>..." to update what will be committed)
      (use "git restore <file>..." to discard changes in working directory)
            modified:   2021/2021-11-01.md

    no changes added to commit (use "git add" and/or "git commit -a")

11. $ git add 2021/2021-11-01.md

12. $ git commit -m "update openeuler riscv"
    [report202111 ea3a6ef] update openeuler riscv
     1 file changed, 51 insertions(+)

13. $ git push xijing21 report202111
    Enumerating objects: 7, done.
    Counting objects: 100% (7/7), done.
    Delta compression using up to 8 threads
    Compressing objects: 100% (4/4), done.
    Writing objects: 100% (4/4), 1.61 KiB | 822.00 KiB/s, done.
    Total 4 (delta 3), reused 0 (delta 0), pack-reused 0
    remote: Resolving deltas: 100% (3/3), completed with 3 local objects.
    remote:
    remote: Create a pull request for 'report202111' on GitHub by visiting:
    remote:      https://github.com/xijing21/PLCT-Weekly/pull/new/report202111
    remote:
    To https://github.com/xijing21/PLCT-Weekly.git

     * [new branch]      report202111 -> report202111

14. 在xijing21/PLCT-Weekly上，新建PR。注意分支选择新建的report202111 向plct/PLCT-Weekly的master提交即可。

    

结论：

操作成功；

方法是多样的，我这个可能不是最简单的，但是主要是通过自己稍微熟悉一点的命令去解决问题。先把问题解决了再说。

但是遗留了一个小问题，就是之前xijing21/PLCT-Weekly [master] 上提交pr的内容增加了，还得恢复到之前的情况，这个简单。就是删减相关内容后再次提交一次pr即可。


