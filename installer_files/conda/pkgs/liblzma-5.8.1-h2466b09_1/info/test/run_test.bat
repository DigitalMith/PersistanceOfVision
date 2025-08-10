



if not exist %LIBRARY_PREFIX%\bin\liblzma.dll exit 1
IF %ERRORLEVEL% NEQ 0 exit /B 1
if exist %LIBRARY_PREFIX%\lib\lzma.lib exit 1
IF %ERRORLEVEL% NEQ 0 exit /B 1
exit /B 0
