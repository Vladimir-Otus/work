#!/bin/bash
# Скрипт резервного копирования таблиц БД MySQL

# Параметры подключения
USER="root"
# Пароль можно задать здесь или в ~/.my.cnf для безопасности
# PASSWORD=""
OUTPUT_DIR="/home/vt"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="$OUTPUT_DIR/backup_$TIMESTAMP.log"

# Создаем директорию для бэкапов, если не существует
mkdir -p "$OUTPUT_DIR"

# Функция для логирования
log() {
    echo "$(date "+%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG_FILE"
}

# Проверка подключения к MySQL
log "Проверка подключения к MySQL..."
if ! mysql -u"$USER" -e "SHOW DATABASES;" > /dev/null 2>&1; then
    log "Ошибка подключения к MySQL. Проверьте учетные данные и доступность сервера."
    exit 1
fi

# Получаем список БД, исключая системные
log "Получение списка пользовательских БД..."
databases=$(mysql -u"$USER" -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql|sys)")

if [ -z "$databases" ]; then
    log "Не найдено пользовательских баз данных для резервного копирования."
    exit 0
fi

log "Найдены следующие БД для резервного копирования: $databases"

# Цикл по каждой БД
for db in $databases; do
    log "Обработка базы данных: $db"
    
    # Создаем папку для текущей БД
    db_dir="$OUTPUT_DIR/$db/$TIMESTAMP"
    if ! mkdir -p "$db_dir"; then
        log "Ошибка при создании папки $db_dir."
        continue
    fi

    # Получаем список всех таблиц в БД
    tables=$(mysql -u"$USER" -e "SHOW TABLES IN $db;" | grep -v "Tables_in_$db")
    
    if [ -z "$tables" ]; then
        log "В базе $db нет таблиц для резервного копирования."
        continue
    fi

    # Цикл по каждой таблице
    for table in $tables; do
        log "Выгружаем таблицу: $table из базы $db"
        
        output_file="$db_dir/$table.sql"
        
        # Делаем выгрузку таблицы
        if ! mysqldump -u"$USER" --single-transaction --quick --routines --events "$db" "$table" > "$output_file" 2>> "$LOG_FILE"; then
            log "Ошибка при выгрузке таблицы $table из базы $db"
            continue
        fi
        
        # Проверяем размер выходного файла
        if [ ! -s "$output_file" ]; then
            log "Предупреждение: файл $output_file пуст или не создан."
        else
            log "Таблица $table успешно выгружена в $output_file"
        fi
    done
    
    # Архивируем всю папку с бэкапом
    log "Архивирование бэкапа для базы $db..."
    tar -czf "$OUTPUT_DIR/${db}_${TIMESTAMP}.tar.gz" -C "$OUTPUT_DIR/$db" "$TIMESTAMP" 2>> "$LOG_FILE"
    
    if [ $? -eq 0 ]; then
        log "Архив создан: $OUTPUT_DIR/${db}_${TIMESTAMP}.tar.gz"
        # Удаляем временные файлы
        rm -rf "$db_dir"
    else
        log "Ошибка при создании архива для базы $db"
    fi
done

log "Резервное копирование завершено!"
