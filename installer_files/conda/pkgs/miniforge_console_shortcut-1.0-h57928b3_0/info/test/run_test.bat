



if not exist %PREFIX%\\Menu\\console_shortcut.json exit 1
IF %ERRORLEVEL% NEQ 0 exit /B 1
if not exist %PREFIX%\\Menu\\console_shortcut.ico exit
IF %ERRORLEVEL% NEQ 0 exit /B 1
exit /B 0
