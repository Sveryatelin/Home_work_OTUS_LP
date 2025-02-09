## NFS

Для проверки домашней работы необходимо:

1. Скачать и выполнить [Vagrantfile](https://raw.githubusercontent.com/Sveryatelin/Home_work_OTUS_LP/refs/heads/main/Lesson6/Vagrantfile). После создания подключиться к ВМ, выступающей клиентом, с помощью команды:
   ```sh
   vagrant ssh nfsc
   ```

2. Далее проверить файл, который создался в примонтированной директории:
   ```sh
   cat /mnt/nfs/upload/check_file.txt
  
