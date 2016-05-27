install
text
url --url=http://ftp.lysator.liu.se/pub/CentOS/6.8/os/x86_64
lang en_US.UTF-8
keyboard sv-latin1
network --onboot yes --device eth0 --bootproto dhcp --noipv6 --hostname centos68
rootpw vagrant
firewall --disabled
authconfig --enableshadow --passalgo=sha512
selinux --disabled
timezone --utc Europe/Stockholm
zerombr
clearpart --all --drives=sda

part /boot --fstype=ext4 --size=500
part pv.008002 --grow --size=1

volgroup vg_centos68 --pesize=4096 pv.008002
logvol / --fstype=ext4 --name=lv_root --vgname=vg_centos68 --grow --size=1024 --maxsize=51200
logvol swap --name=lv_swap --vgname=vg_centos68 --grow --size=1504 --maxsize=1504

repo --name="CentOS"  --baseurl=http://ftp.lysator.liu.se/pub/CentOS/6.8/os/x86_64 --cost=100
user --name=vagrant --groups=wheel --password=vagrant
reboot
%packages --nobase
@core
%end
%post --nochroot
cp /etc/resolv.conf /mnt/sysimage/etc/resolv.conf
%end

%post
/usr/bin/yum -y install sudo
/bin/cat << EOF > /etc/sudoers.d/wheel
Defaults:%wheel env_keep += "SSH_AUTH_SOCK"
Defaults:%wheel !requiretty
%wheel ALL=(ALL) NOPASSWD: ALL
 
EOF
/bin/chmod 0440 /etc/sudoers.d/wheel
/bin/mkdir /home/vagrant/.ssh
/bin/chmod 700 /home/vagrant/.ssh
/usr/bin/curl -L -o /home/vagrant/.ssh/id_rsa https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant
/usr/bin/curl -L -o /home/vagrant/.ssh/authorized_keys https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
/bin/chown -R vagrant:vagrant /home/vagrant/.ssh
/bin/chmod 0400 /home/vagrant/.ssh/*
/bin/echo 'UseDNS no' >> /etc/ssh/sshd_config
/bin/echo '127.0.0.1   vagrant-centos-6.vagrantup.com' >> /etc/hosts
/usr/bin/yum -y clean all
/sbin/swapoff -a
/sbin/mkswap /dev/mapper/vg_vagrantcentos-lv_swap
/bin/dd if=/dev/zero of=/boot/EMPTY bs=1M
/bin/rm -f /boot/EMPTY
/bin/dd if=/dev/zero of=/EMPTY bs=1M
/bin/rm -f /EMPTY
%end
