@echo off
REM start-carousel.bat - Executa o script PowerShell de forma silenciosa (duplo-clique)
SET SCRIPT_DIR=%~dp0
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%SCRIPT_DIR%powerbi-carousel.ps1"
EXIT