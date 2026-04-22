#!/bin/bash

# Функция установки ноды
install_node() {
    echo "Установка ноды..."
    curl -L -o pop "https://dl.pipecdn.app/v0.2.4/pop"
    chmod +x pop
    mkdir -p download_cache

    read -p "Введите ваш адрес Solana: " SOLANA_KEY

    screen -dmS Pipe bash -c "./pop --ram 4 --max-disk 100 --cache-dir /data --pubKey $SOLANA_KEY --signup-by-referral-route eae75702c2eb1b0a"

    sleep 2
    echo "Нода запущена в screen 'Pipe'. Используйте 'screen -r Pipe' для просмотра."
}

# Функция проверки логов
check_logs() {
    echo "Проверка логов..."
    ./pop --status
}

# Функция проверки поинтов (парсим JSON)
check_points() {
    echo "Запрос количества поинтов..."
    RESPONSE=$(./pop --points 2>/dev/null | grep -oE '{"success":(true|false),.*}')
    
    if [[ $RESPONSE == *'"success":true'* ]]; then
        POINTS=$(echo $RESPONSE | grep -oE '"points":[0-9]+' | awk -F: '{print $2}')
        echo "Ваше количество поинтов: $POINTS"
    else
        echo "Не удалось узнать количество поинтов."
    fi
}

# Функция удаления ноды
remove_node() {
    echo "Удаление ноды..."
    rm -rf pop download_cache
    echo "Нода удалена!"
}

# Функция генерации реферального кода (парсим JSON)
generate_referral() {
	echo "Генерация реферального кода..."
output=$(./pop --gen-referral-route)

# Извлекаем JSON-ответ
json=$(echo "$output" | grep -oE '\{.*\}')

# Проверяем, удалось ли извлечь JSON
if echo "$json" | grep -q '"success":true'; then
    referral_code=$(echo "$json" | grep -oP '(?<="referral_url":"referral=)[^"]+')
    echo "Ваш реферальный код: $referral_code"
else
    echo "Не удалось сгенерировать реферальный код"
fi
}

# Функция отображения меню
show_menu() {
    echo "██████╗  █████╗ ██████╗ ██████╗ ███████╗███╗   ██╗"
    echo "██╔════╝ ██╔══██╗██╔══██╗██╔══██╗██╔════╝████╗  ██║"
    echo "██║  ███╗███████║██████╔╝██║  ██║█████╗  ██╔██╗ ██║"
    echo "██║   ██║██╔══██║██╔══██╗██║  ██║██╔══╝  ██║╚██╗██║"
    echo "╚██████╔╝██║  ██║██║  ██║██████╔╝███████╗██║ ╚████║"
    echo " ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═══╝"


    echo " Установить любую ноду в 2 клика --> @пампарам.."
    echo " Мой канал : @пупупу..."
    echo "===================================="
    echo "Garden Node Manager"
    echo "===================================="
    echo "1. Установить ноду"
    echo "2. Проверить логи"
    echo "3. Узнать количество поинтов"
    echo "4. Удалить ноду"
    echo "5. Сгенерировать реферальный код"
    echo "6. Выйти из скрипта"
    echo "===================================="
}

# Основной цикл
while true; do
    show_menu
    read -p "Введите цифру: " choice

    case $choice in
        1) install_node ;;
        2) check_logs ;;
        3) check_points ;;
        4) remove_node ;;
        5) generate_referral ;;
        6) echo "Выход..."; exit ;;
        *) echo "Неверный ввод. Попробуйте снова!" ;;
    esac
done

