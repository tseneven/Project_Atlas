#!/bin/bash

random=$((RANDOM % 10000))
NAME="Migration_$random"

echo "Создание миграции: $NAME"

if ! dotnet ef migrations add "$NAME"; then
    echo "Ошибка создания миграции."
    read -p "Нажмите Enter..."
    exit 1
fi

echo "Применение миграции..."

if ! dotnet ef database update; then
    echo "Ошибка применения. Удаление миграции..."

    if dotnet ef migrations remove --force; then
        echo "Миграция удалена."
    else
        echo "Не удалось удалить миграцию."
    fi

    read -p "Нажмите Enter..."
    exit 1
fi

echo "Миграция успешно применена: $NAME"
read -p "Нажмите Enter..."