Для проверки домашней работы необходимо:

1. Скачать и выполнить Vagrantfile https://raw.githubusercontent.com/Sveryatelin/Home_work_OTUS_LP/refs/heads/main/Lesson2/Vagrantfile. Если роль ansible находится на другом хосте, то можно раскоментировать строчки "config.vm.synced_folder "Q:/1VirtualBox/vagrant/.vagrant/ssh/ansible", "/vagrant/ssh/ansible"" и строчку "cat /vagrant/ssh/ansible/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys". Вместо "Q:/1VirtualBox/vagrant/.vagrant/ssh/ansible" нужно будет указать ваш файл с публичным ssh ключём ansible

2. Далее добавить развёрнутую ВМ в инвентарь ansible и назвать узел nginx

3. Скачать плейбук на сервер ansible ```wget https://raw.githubusercontent.com/Sveryatelin/Home_work_OTUS_LP/refs/heads/main/Lesson2/lesson2.yml```

4. Так же скачать шаблон и обработчик ```wget https://raw.githubusercontent.com/Sveryatelin/Home_work_OTUS_LP/refs/heads/main/Lesson2/handlers/restart%20nginx https://raw.githubusercontent.com/Sveryatelin/Home_work_OTUS_LP/refs/heads/main/Lesson2/templates/nginx.conf.j2```

5. Запустить плейбук 

6. Убедится что nginx развёрнут и доступен на порту 8080
