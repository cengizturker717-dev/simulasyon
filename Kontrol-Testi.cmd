@echo off
setlocal
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Kontrol-Testi.ps1"
set "RESULT=%errorlevel%"
if /i not "%~1"=="--no-pause" pause
exit /b %RESULT%
