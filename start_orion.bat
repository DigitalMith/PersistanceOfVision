@echo off
REM ============================
REM Orion Startup Script (venv version)
REM ============================

REM Set paths
set ORION_EMBED_MODEL=all-mpnet-base-v2
set "TGWUI_DIR=C:\Orion\text-generation-webui"
set "MODEL_NAME=openhermes-2.5-mistral-7b.Q4_K_M.gguf"
set "MODEL_PATH=%TGWUI_DIR%\user_data\models\%MODEL_NAME%"

REM Activate venv-orion environment
CALL "%TGWUI_DIR%\venv-orion\Scripts\activate.bat"

REM Check model exists before launching
IF NOT EXIST "%MODEL_PATH%" (
    echo [ERROR] Model file not found at:
    echo %MODEL_PATH%
    pause
    exit /b 1
)

echo [INFO] Embedding model set to: %ORION_EMBED_MODEL%

REM Launch TGWUI with Orion LTM extension and model autoload
python "%TGWUI_DIR%\server.py" ^
    --model "%MODEL_NAME%" ^
    --extensions orion_ltm ^
    --listen ^
    --verbose

pause
