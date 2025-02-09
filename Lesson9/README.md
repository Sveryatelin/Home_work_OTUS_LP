## Инициализация системы. Systemd.
Для проверки домашней работы необходимо:

1. Скачать [Vagrantfile](https://raw.githubusercontent.com/Sveryatelin/Home_work_OTUS_LP/refs/heads/main/Lesson9/Vagrantfile) и [script.sh](https://raw.githubusercontent.com/Sveryatelin/Home_work_OTUS_LP/refs/heads/main/Lesson9/script.sh) в одну директорию, после чего выполнить `vagrant up`. И далее подключиться к созданой ВМ с помошью `vagrant ssh`.

2. И проверить успешность выполения заданий=)
```bash
#Task 1
tail -n 1000 /var/log/syslog  | grep word
#Task 2
systemctl status spawn-fcgi
#Task 3
ss -tnulp | grep nginx
systemctl status nginx@first.service
systemctl status nginx@second.service
```
