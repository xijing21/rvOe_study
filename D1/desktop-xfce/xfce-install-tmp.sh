#!/bin/bash
set -v

df -h  2>&1|tee -a xfce-yum-install.log
fdisk -l 2>&1|tee -a xfce-yum-install.log
date 2>&1|tee -a xfce-yum-install.log
cat /etc/yum.repos.d/oe-rv.repo 2>&1|tee -a xfce-yum-install.log

echo 'install Xfce Desktop 15 packages'
yum -y install libxfce4util  2>&1|tee -a xfce-yum-install.log
yum -y install xfconf  2>&1|tee -a xfce-yum-install.log
yum -y install libxfce4ui 2>&1|tee -a xfce-yum-install.log
yum -y install exo  2>&1|tee -a xfce-yum-install.log
yum -y install garcon  2>&1|tee -a xfce-yum-install.log
yum -y install thunar  2>&1|tee -a xfce-yum-install.log
yum -y install thunar-volman  2>&1|tee -a xfce-yum-install.log
yum -y install tumbler  2>&1|tee -a xfce-yum-install.log
yum -y install xfce4-appfinder    2>&1|tee -a xfce-yum-install.log
yum -y install xfce4-panel  2>&1|tee -a xfce-yum-install.log
yum -y install xfce4-power-manager 2>&1|tee -a xfce-yum-install.log
yum -y install xfce4-settings 2>&1|tee -a xfce-yum-install.log
yum -y install xfdesktop 2>&1|tee -a xfce-yum-install.log
yum -y install xfwm4 2>&1|tee -a xfce-yum-install.log
yum -y install xfce4-session 2>&1|tee -a xfce-yum-install.log


echo 'install Xfce Applications 6 packages'
yum -y install parole 2>&1|tee -a xfce-yum-install.log
yum -y install xfce4-terminal 2>&1|tee -a xfce-yum-install.log
yum -y install xfburn 2>&1|tee -a xfce-yum-install.log
yum -y install ristretto 2>&1|tee -a xfce-yum-install.log
yum -y install xfce4-notifyd 2>&1|tee -a xfce-yum-install.log
yum -y install xfce4-pulseaudio-plugin 2>&1|tee -a xfce-yum-install.log
