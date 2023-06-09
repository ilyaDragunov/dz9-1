			Домашнее задание #9
		
Описание/Пошаговая инструкция выполнения домашнего задания:
Написать скрипт для CRON, который раз в час будет формировать письмо и отправлять на заданную почту.
Необходимая информация в письме:

1. Список IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;
2. Список запрашиваемых URL (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;
3. Ошибки веб-сервера/приложения c момента последнего запуска;
4. Список всех кодов HTTP ответа с указанием их кол-ва с момента последнего запуска скрипта.
5. Скрипт должен предотвращать одновременный запуск нескольких копий, до его завершения.
6. В письме должен быть прописан обрабатываемый временной диапазон.



1. Создаем файл script.sh и делаем его исполняемым

```

user@ubuntu-vm:~/DZ-OTUS/DZ-9$ touch script.sh
user@ubuntu-vm:~/DZ-OTUS/DZ-9$ chmod +x script.sh


#!/bin/bash

# Если скрипт не успеет отработать в отведенное время, повторный запуск скрипта не произойдет - произойдет запуск программы flock
#(она будет ждать пока что первый скрипт завершит свою работу и только после этого запустит скрипт).
if [ -f lock ]
then
exit 1
fi
touch lock

# Выводим дату запуска скрипта
echo  Временной интервал >> main.log
cat access.log | awk '{print $4}' | head -n 1 &&  date >> main.log


# Список последних пяти  IP адресов с наибольшим кол-вом запросов
echo "Список последних пяти  IP адресов с наибольшим кол-вом запросов" >> main.log
grep "$1" access.log | cut -d ' ' -f 1 | sort | uniq -c | sort -n | tail -n 5 >> main.log

# Список полседних пяти запрашиваемых URL с наибольшим кол-вом запросов
echo "Список полседних пяти запрашиваемых URL с наибольшим кол-вом запросов" >> main.log
grep "$7" access.log | cut -d ' ' -f 7 | sort | uniq -c | sort -n | tail -n 5 >> main.log

# Ошибки веб-сервера/приложения c момента последнего запуска
echo "Ошибки веб-сервера/приложения c момента последнего запуска" >> main.log
grep "$9" access.log | cut -d ' ' -f 9 | grep ^4 | sort | uniq -c | sort -n >> main.log
grep "$9" access.log | cut -d ' ' -f 9 | grep ^5 | sort | uniq -c | sort -n >> main.log

# Список всех кодов HTTP ответа
echo "Список всех кодов HTTP ответа" >> main.log
grep "$9" access.log | cut -d ' ' -f 9 | sort | uniq -c | sort -n >>  main.log

# Отправка файла с отчетом на локальную почту root

mailx -s "Report" root < main.log

rm lock

```

2. Настраиваем планировщик


```

user@ubuntu-vm:~/DZ-OTUS/DZ-9$ crontab -e

  GNU nano 6.2                                                           
# Edit this file to introduce tasks to be run by cron.
#
# Each task to run has to be defined through a single line
# indicating with different fields when the task will be run
# and what command to run for the task
#
# To define the time you can provide concrete values for
# minute (m), hour (h), day of month (dom), month (mon),
# and day of week (dow) or use '*' in these fields (for 'any').
#
# Notice that tasks will be started based on the cron's system
# daemon's notion of time and timezones.
#
# Output of the crontab jobs (including errors) is sent through
# email to the user the crontab file belongs to (unless redirected).
#
# For example, you can run a backup of all your user accounts

#Выполнять каждый час
 0 * * * *  /home/user/DZ-OTUS/DZ-9/script.sh

#
# For more information see the manual pages of crontab(5) and cron(8)
#
# m h  dom mon dow   command

```

3. Проверяем письмо в каталоге /var/mail после отработки cron

```

From root@ubuntu-vm  Fri Jun  9 18:20:05 2023
Return-Path: <root@ubuntu-vm>
X-Original-To: root
Delivered-To: root@ubuntu-vm
Received: by ubuntu-vm (Postfix, from userid 0)
        id 6B85C6410E9; Fri,  9 Jun 2023 18:20:05 +0300 (MSK)
Subject: Report
To: root@ubuntu-vm
User-Agent: mail (GNU Mailutils 3.14)
Date: Fri,  9 Jun 2023 18:20:05 +0300
Message-Id: <20230609152005.6B85C6410E9@ubuntu-vm>
From: root <root@ubuntu-vm>

Временной интервал
Пт 09 июн 2023 18:20:05 MSK
Список последних пяти  IP адресов с наибольшим кол-вом запросов
     55 188.242.82.120
     90 176.97.33.2
    151 79.134.210.218
    399 85.114.18.228
    640 95.161.177.237
Список полседних пяти запрашиваемых URL с наибольшим кол-вом запросов
     32 /login
     78 /
    155 /ocs/v2.php/apps/notifications/api/v2/notifications
    190 /csrftoken
    468 /ocs/v2.php/apps/user_status/api/v1/heartbeat?format=json
Ошибки веб-сервера/приложения c момента последнего запуска
      2 401
      3 499
      4 412
     16 400
     40 404
Список всех кодов HTTP ответа
      1 HTTP/1.1"
      1 \x9D\xBF-\x92W\xD8
      2 301
      2 401
      3 157
      3 499
      4 412
      6 206
      7 201
      7 204
     13 101
     14 303
     16 "-"
     16 400
     28 207
     40 404
     68 302
    152 304
   1244 200


```


# dz-9
# dz-9
# dz9-1
