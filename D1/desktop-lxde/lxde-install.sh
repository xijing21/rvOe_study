#!/bin/bash
set -v

df -h  2>&1|tee -a lxde-yum-install.log
fdisk -l 2>&1|tee -a lxde-yum-install.log
date 2>&1|tee -a lxde-yum-install.log
cat /etc/yum.repos.d/oe-rv.repo 2>&1|tee -a lxde-yum-install.log

echo 'install LXDE Desktop 10 packages'
yum -y install lxmenu-data  2>&1|tee -a lxde-yum-install.log
yum -y install libfm-devel  2>&1|tee -a lxde-yum-install.log
yum -y install menu-cache  2>&1|tee -a lxde-yum-install.log
yum -y install libfm  2>&1|tee -a lxde-yum-install.log
yum -y install pcmanfm  2>&1|tee -a lxde-yum-install.log
yum -y install libwnck  2>&1|tee -a lxde-yum-install.log
yum -y install lxpanel  2>&1|tee -a lxde-yum-install.log
yum -y install lxappearance  2>&1|tee -a lxde-yum-install.log
yum -y install lxsession    2>&1|tee -a lxde-yum-install.log
yum -y install lxde-common  2>&1|tee -a lxde-yum-install.log


echo 'install LXDE Applications 7 packages'
yum -y install gpicview 2>&1|tee -a lxde-yum-install.log
yum -y install lxappearance-obconf 2>&1|tee -a lxde-yum-install.log
yum -y install lxinput 2>&1|tee -a lxde-yum-install.log
yum -y install lxrandr 2>&1|tee -a lxde-yum-install.log
yum -y install lxtask 2>&1|tee -a lxde-yum-install.log
yum -y install vte  2>&1|tee -a lxde-yum-install.log
yum -y install lxterminal 2>&1|tee -a lxde-yum-install.log


echo 'check other required packages'
yum install wireless-tools vte volume_key userspace-rcu udisks2 setools selinux-policy samba python-parameterized python-nose2 python-cov-core policycoreutils pcmanfm openbox openEuler-menus ndctl mozjs60 menu-cache lxterminal lxtask lxsession lxpanel lxmenu-data lxinput lxde-common lxappearance libwnck libtdb libtalloc libstoragemgmt libldb libfm-extra libfm krb5 json-c imlib2 gnome-online-accounts bind 2>&1|tee -a lxde-yum-install.log


echo 'can install succeeded，but lxde no need'
## yum -y install vte  setools selinux-policy samba python-parameterized python-nose2 python-cov-core policycoreutils mozjs60 lxterminal lxtask lxinput libstoragemgmt  krb5 bind 
#yum -y install setools 2>&1|tee -a lxde-yum-install.log
#yum -y install samba 2>&1|tee -a lxde-yum-install.log
#yum -y install policycoreutils 2>&1|tee -a lxde-yum-install.log
#yum -y install mozjs60 2>&1|tee -a lxde-yum-install.log
#yum -y install krb5 2>&1|tee -a lxde-yum-install.log
#yum -y install bind 2>&1|tee -a lxde-yum-install.log

#yum -y install python-parameterized 2>&1|tee -a lxde-yum-install.log
#yum -y install python-nose2 2>&1|tee -a lxde-yum-install.log


echo 'install failed:libstoragemgmt python-cov-core'
#yum -y install libstoragemgmt  2>&1|tee -a lxde-yum-install.log
#yum -y install python-cov-core 2>&1|tee -a lxde-yum-install.log

echo 'selinux-policy can install succeeded,but D1 can not start'
##yum -y install selinux-policy 2>&1|tee -a lxde-yum-install.log
