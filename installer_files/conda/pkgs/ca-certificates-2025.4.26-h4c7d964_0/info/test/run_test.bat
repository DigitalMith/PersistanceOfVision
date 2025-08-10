



if not exist %LIBRARY_PREFIX%\\ssl\\cacert.pem exit 1
IF %ERRORLEVEL% NEQ 0 exit /B 1
if not exist %LIBRARY_PREFIX%\\ssl\\cert.pem exit 1
IF %ERRORLEVEL% NEQ 0 exit /B 1
curl --cacert %LIBRARY_PREFIX%\\ssl\\cacert.pem https://www.google.com
IF %ERRORLEVEL% NEQ 0 exit /B 1
exit /B 0
