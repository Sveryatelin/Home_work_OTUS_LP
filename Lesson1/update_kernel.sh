#!/bin/bash

# Обновление пакетов
sudo apt update && sudo apt upgrade -y

# Проверка текущей версии ядра
uname -r

# Установка необходимых пакетов для добавления репозиториев и работы с ядром
sudo apt install -y software-properties-common

# Добавление репозитория с последними ядрами
sudo add-apt-repository ppa:canonical-kernel-team/ppa
sudo apt update

# Установка последнего ядра
sudo apt install -y linux-image-generic linux-headers-generic

# Перезагрузка виртуальной машины
sudo reboot
