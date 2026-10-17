# lua-config-template-engine

Движок динамической шаблонизации конфигурационных файлов (Nginx, JSON, YAML, INI) на Lua 5.4.

## Возможности
- Интерполяция Lua-выражений: `<%= expression %>`.
- Выполнение блоков кода и циклов: `<% for k, v in pairs(...) do %> ... <% end %>`.
- Чтение параметров из структуры конфигурации `context.lua`.
- Автоматическая валидация синтаксиса и генерация итогового конфигурационного файла.

## Сборка байт-кода
```bash
luac -o releases/engine.luac engine.lua
```

## Использование
```bash
# Рендеринг шаблона через Lua
lua engine.lua template.nginx.conf context.lua output.conf

# Быстрый запуск из releases:
./releases/lua-config-template-engine.bat
```
