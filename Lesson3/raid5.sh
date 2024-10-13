#!/bin/bash

# Создание RAID 5 массива на дисках /dev/sdc /dev/sdd /dev/sde
sudo mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/sdc /dev/sdd /dev/sde

# Запись конфигурации RAID в mdadm.conf
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
