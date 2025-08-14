@echo off
setlocal enabledelayedexpansion
REM ==================================================================
REM Orion one-click: backup -> seed persona -> seed episodic -> sentence -> inspect
REM Tip: close text-generation-webui while running to avoid SQLite locks.
REM ==================================================================

REM --- Always run from repo root ---
cd /d "%~dp0"

REM --- Paths / env ---
set "ROOT=%CD%\"
set "PY=%ROOT%installer_files\env\python.exe"
set "CTL=%ROOT%custom_ltm\orion_ctl.py"
set "CHROMA_DB_PATH=%ROOT%user_data\chroma_db"

REM --- Optional policy file (used only if it exists) ---
set "POLICY=C:\Orion\dev\orion_policy.yaml"
set "POLICYARG="
if exist "%POLICY%" set "POLICYARG=--policy \"%POLICY%\""

REM --- Preflight checks ---
if not exist "%PY%" (
  echo [ERROR] Python not found: %PY%
  goto :err
)
if not exist "%CTL%" (
  echo [ERROR] Controller not found: %CTL%
  goto :err
)
if not exist "%CHROMA_DB_PATH%" (
  echo [WARN] CHROMA_DB_PATH does not exist yet: %CHROMA_DB_PATH%
  echo        It will be created on first write.
)

echo.
echo [1/6] Backup Chroma to /backups/chroma/
"%PY%" "%CTL%" backup-fs || goto :err

echo.
echo [2/6] Inspect BEFORE
"%PY%" "%CTL%" inspect || goto :err

echo.
echo [3/6] Seed persona (non-destructive refresh of same source)
"%PY%" "%CTL%" seed-persona %POLICYARG% || goto :err

echo.
echo [4/6] Seed episodic (add-only)
"%PY%" "%CTL%" seed-episodic %POLICYARG% || goto :err

echo.
echo [5/6] Sentencing episodic (upsert compact, labeled points)
"%PY%" "%CTL%" make-episodic-sentences --max-points 2 || goto :err

echo.
echo [6/6] Inspect AFTER
"%PY%" "%CTL%" inspect || goto :err

echo.
echo Done. Backup and counts complete.
goto :eof

:err
echo.
echo ERROR: A step failed (errorlevel %errorlevel%).
exit /b %errorlevel%
