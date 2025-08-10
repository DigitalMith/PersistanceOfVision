



if not exist %LIBRARY_BIN%\mamba.exe (exit 1)
IF %ERRORLEVEL% NEQ 0 exit /B 1
if not exist %PREFIX%\condabin\mamba.bat (exit 1)
IF %ERRORLEVEL% NEQ 0 exit /B 1
mamba --help
IF %ERRORLEVEL% NEQ 0 exit /B 1
CALL %PREFIX%/condabin/mamba.bat --help
IF %ERRORLEVEL% NEQ 0 exit /B 1
mkdir %TEMP%\mamba
IF %ERRORLEVEL% NEQ 0 exit /B 1
set "MAMBA_ROOT_PREFIX=%TEMP%\mamba"
IF %ERRORLEVEL% NEQ 0 exit /B 1
mamba create -n test --override-channels -c conda-forge --yes python=3.9
IF %ERRORLEVEL% NEQ 0 exit /B 1
%MAMBA_ROOT_PREFIX%\envs\test\python.exe --version
IF %ERRORLEVEL% NEQ 0 exit /B 1
%MAMBA_ROOT_PREFIX%\envs\test\python.exe -c "import os"
IF %ERRORLEVEL% NEQ 0 exit /B 1
exit /B 0
