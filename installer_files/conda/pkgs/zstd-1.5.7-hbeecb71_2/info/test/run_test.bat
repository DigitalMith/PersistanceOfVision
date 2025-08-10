



if not exist %LIBRARY_BIN%\zstd.dll exit 1
IF %ERRORLEVEL% NEQ 0 exit /B 1
if not exist %LIBRARY_LIB%\zstd.lib exit 1
IF %ERRORLEVEL% NEQ 0 exit /B 1
if not exist %LIBRARY_BIN%\libzstd.dll exit 1
IF %ERRORLEVEL% NEQ 0 exit /B 1
if not exist %LIBRARY_LIB%\libzstd.lib exit 1
IF %ERRORLEVEL% NEQ 0 exit /B 1
if exist %LIBRARY_LIB%\zstd_static.lib exit 1
IF %ERRORLEVEL% NEQ 0 exit /B 1
if exist %LIBRARY_LIB%\libzstd_static.lib exit 1
IF %ERRORLEVEL% NEQ 0 exit /B 1
if not exist %LIBRARY_INC%\zstd.h exit 1
IF %ERRORLEVEL% NEQ 0 exit /B 1
zstd -be -i5
IF %ERRORLEVEL% NEQ 0 exit /B 1
if not exist %LIBRARY_LIB%\pkgconfig\libzstd.pc exit 1
IF %ERRORLEVEL% NEQ 0 exit /B 1
set "PKG_CONFIG_PATH=%LIBRARY_LIB%\pkgconfig"
IF %ERRORLEVEL% NEQ 0 exit /B 1
pkg-config --cflags libzstd
IF %ERRORLEVEL% NEQ 0 exit /B 1
cd cf_test
IF %ERRORLEVEL% NEQ 0 exit /B 1
cmake %CMAKE_ARGS% .
IF %ERRORLEVEL% NEQ 0 exit /B 1
exit /B 0
