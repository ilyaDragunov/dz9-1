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






