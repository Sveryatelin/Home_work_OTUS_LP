## Инициализация системы. Systemd.
Для проверки домашней работы необходимо:

1. Скачать [Vagrantfile](https://raw.githubusercontent.com/Sveryatelin/Home_work_OTUS_LP/refs/heads/main/Lesson9/Vagrantfile) и [script.sh](https://raw.githubusercontent.com/Sveryatelin/Home_work_OTUS_LP/refs/heads/main/Lesson9/script.sh) в одну директорию, после чего выполнить `vagrant up`. И далее подключиться к созданой ВМ с помошью `vagrant ssh`.

2. И проверить успешность выполения заданий=)
```bash
tail -n 1000 /var/log/syslog  | grep word
systemctl status spawn-fcgi
ss -tnulp | grep nginx
systemctl status nginx@first.service
systemctl status nginx@second.service
```
