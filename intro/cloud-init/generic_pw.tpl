#cloud-config

user: deepti
password: Password123? 
chpasswd: {expire: False}
sudo: ALL=(ALL) NOPASSWD:ALL
ssh_pwauth: True
hostname: ${hostname}
  
apt_update: true
apt_upgrade: true

packages:
  - docker.io
  - cifs-utils
  - linux-modules-extra-5.15.0-53-generic

runcmd:
  - mkdir /mnt/storage
  - echo "//172.16.1.3/storage  /mnt/storage  cifs  guest,uid=1000,iocharset=utf8  0  0" | tee -a /etc/fstab

power_state:
 mode: reboot