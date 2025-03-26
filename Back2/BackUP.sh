#!/bin/bash
# Скрипт backup BD table

USER="root"
OUTPUT_DIR="/home/vt/DB/DB"

# Проверка подключения к MySQL
if ! mysql -u"$USER" -e "SHOW DATABASES;" > /dev/null; then
    echo "Ошибка подключения к MySQL. Проверьте учетные данные и доступность сервера."
    exit 1
fi

# Получаем БД, исключая системные
databases=$(mysql -u"$USER" -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql|sys)")

# Цикл по каждой БД
for db in $databases; do
    echo "Выгружаем базу данных: $db"

    # Создаем папку для текущей БД
    if ! mkdir -p "$OUTPUT_DIR/$db"; then
        echo "Ошибка при создании папки $OUTPUT_DIR/$db."
        exit 1
    fi

    # Получаем список всех таблиц в БД
    tables=$(mysql -u"$USER" -e "SHOW TABLES IN $db;" | grep -v "Tables_in")

    # Цикл по каждой таблице
    for table in $tables; do
        echo "Выгружаем таблицу: $table из базы $db"

        # Проверка на существование файла
        if [[ -f "$OUTPUT_DIR/$db/$table.sql" ]]; then
            echo "Файл $OUTPUT_DIR/$db/$table.sql уже существует. Он будет перезаписан."
        fi

        # Делаем выгрузку таблицы в файл внутри папки базы данных
        mysqldump -u"$USER" --single-transaction --routines --events "$db" "$table" > "$OUTPUT_DIR/$db/$table.sql"
    done
done

echo "Бэкап готов!"
