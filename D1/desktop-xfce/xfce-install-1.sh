#!/bin/bash
set -v

df -h  
fdisk -l 
date 
cat /etc/yum.repos.d/oe-rv.repo 

echo 'install Xfce Desktop 15 packages'
yum -y install libxfce4util  
yum -y install xfconf  
yum -y install libxfce4ui 
yum -y install exo  
yum -y install garcon  
yum -y install thunar  
yum -y install thunar-volman  
yum -y install tumbler  
yum -y install xfce4-appfinder    
yum -y install xfce4-panel  
yum -y install xfce4-power-manager 
yum -y install xfce4-settings 
yum -y install xfdesktop 
yum -y install xfwm4 
yum -y install xfce4-session 


echo 'install Xfce Applications 6 packages'
yum -y install parole 
yum -y install xfce4-terminal 
yum -y install xfburn 
yum -y install ristretto 
yum -y install xfce4-notifyd 
yum -y install xfce4-pulseaudio-plugin 
