



if not exist %LIBRARY_BIN%\vcomp140.dll exit 1
IF %ERRORLEVEL% NEQ 0 exit /B 1
if not exist %PREFIX%\vcomp140.dll exit 1
IF %ERRORLEVEL% NEQ 0 exit /B 1
exit /B 0
