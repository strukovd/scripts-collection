# Личные настройки из ~/.bash. Отсутствующие файлы пропускаются.
for file in "$HOME/.bash/.bash_custom_env" \
            "$HOME/.bash/.bash_custom_methods" \
            "$HOME/.bash/.bash_custom_aliases" \
            "$HOME/.bash/.bash_custom_completions"; do
    if [ -f "$file" ]; then
        . "$file"
    fi
done
unset file
