@echo off
echo ---------------------------------
echo Orion Repo Bloat Cleanup Utility
echo ---------------------------------

:: Change to script's directory
cd /d "%~dp0"

:: Remove common build artifacts and temp folders
echo Cleaning build artifacts...
rmdir /s /q build dist .eggs 2>nul
del /s /q *.egg-info 2>nul
del /s /q *.pyc *.pyo *.pyd 2>nul
rmdir /s /q __pycache__ 2>nul

:: Remove cache directories
echo Cleaning cache directories...
rmdir /s /q .mypy_cache .pytest_cache .venv venv env 2>nul

:: Remove Chroma DBs if NOT critical
echo Checking for Chroma DBs...
if exist user_data\chroma_db\chroma.sqlite3 (
    echo Found: chroma.sqlite3
    echo [!] Skipping deletion – review manually if needed.
)
if exist user_data\chroma_db\chroma (2).sqlite3 (
    echo Found: chroma (2).sqlite3
    echo [!] Skipping deletion – review manually if needed.
)

:: Suggest adding to .gitignore
echo.
echo [INFO] Suggest reviewing your .gitignore for:
echo   __pycache__/
echo   *.pyc
echo   *.pyo
echo   *.egg-info/
echo   .mypy_cache/
echo   .venv/
echo   env/
echo   *.sqlite3 (unless needed)
echo.

echo Done.
pause
