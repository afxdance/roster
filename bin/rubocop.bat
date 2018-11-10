@echo off
REM This file provides rubocop support if you are using Ubuntu on Windows and want to use the
REM RuboCop linter. If you use Visual Studio Code, it should work automatically because of a setting
REM we put in the workspace settings (roster/.vscode/settings.json).
wsl ~/.rbenv/shims/bundle exec rubocop $^(echo '%*' ^| sed -e 's^|\\^|/^|g' -e 's^|\^([A-Za-z]\^)\:/\^(.*\^)^|/mnt/\L\1\E/\2^|g'^)
