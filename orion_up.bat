@echo off
REM Use TGWUI's portable Python for both preflight and server
set PYTHONUTF8=1
set PYTHONIOENCODING=utf-8

cd /d "%~dp0"

REM Step 1: Preflight Chroma
.\installer_files\env\python.exe orion_preflight.py

REM Step 2: Launch TGWUI
cd text-generation-webui
..\installer_files\env\python.exe server.py --listen --auto-devices --verbose
