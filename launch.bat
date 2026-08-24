@echo off
set "psScript=%~dp0launch.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -File "%psScript%" %*