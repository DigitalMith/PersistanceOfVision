@echo off
REM ============================
REM Orion Startup Script
REM ============================

REM Set paths
set "TGWUI_DIR=C:\Orion\text-generation-webui"
set "MODEL_NAME=openhermes-2.5-mistral-7b.Q4_K_M.gguf"
set "MODEL_PATH=%TGWUI_DIR%\user_data\models\%MODEL_NAME%"

REM Activate TGWUI virtual environment
CALL "%TGWUI_DIR%\installer_files\conda\Scripts\activate.bat" "%TGWUI_DIR%\installer_files\env"

REM Check model exists before launching
IF NOT EXIST "%MODEL_PATH%" (
    echo [ERROR] Model file not found at:
    echo %MODEL_PATH%
    pause
    exit /b 1
)

REM Launch TGWUI with Orion LTM extension and model autoload
CALL "%TGWUI_DIR%\installer_files\env\python.exe" "%TGWUI_DIR%\server.py" ^
    --model "%MODEL_NAME%" ^
    --extensions orion_ltm ^
    --listen ^
    --verbose

pause
