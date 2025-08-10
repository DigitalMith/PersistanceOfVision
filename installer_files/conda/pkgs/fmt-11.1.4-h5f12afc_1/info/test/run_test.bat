



if not exist %LIBRARY_PREFIX%\include\fmt\core.h (exit 1)
IF %ERRORLEVEL% NEQ 0 exit /B 1
if not exist %LIBRARY_PREFIX%\include\fmt\format.h (exit 1)
IF %ERRORLEVEL% NEQ 0 exit /B 1
if not exist %LIBRARY_PREFIX%\lib\cmake\fmt\fmt-config.cmake (exit 1)
IF %ERRORLEVEL% NEQ 0 exit /B 1
if not exist %LIBRARY_PREFIX%\bin\fmt.dll (exit 1)
IF %ERRORLEVEL% NEQ 0 exit /B 1
exit /B 0
