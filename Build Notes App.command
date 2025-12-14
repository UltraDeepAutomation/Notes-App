#!/bin/bash

# Путь к проекту
PROJECT_DIR="/Users/leoerdman/Programming - MAIN FOLDER/Notes App"
APP_BUNDLE="$PROJECT_DIR/NotesApp.app"

cd "$PROJECT_DIR"

echo "🔨 Сборка NotesApp..."
swift build -c release

if [ $? -eq 0 ]; then
    echo "✅ Сборка завершена!"
    
    # Копируем в .app бандл
    cp "$PROJECT_DIR/.build/release/NotesApp" "$APP_BUNDLE/Contents/MacOS/"
    
    echo "🚀 Запуск приложения..."
    open "$APP_BUNDLE"
else
    echo "❌ Ошибка сборки!"
    read -p "Нажмите Enter для выхода..."
fi