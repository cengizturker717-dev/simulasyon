@echo off
set "QSG_RHI_BACKEND=d3d11"
if exist "%~dp0render-backend.txt" set /p QSG_RHI_BACKEND=<"%~dp0render-backend.txt"
start "" "%~dp0app\SolidSimNative.exe"
