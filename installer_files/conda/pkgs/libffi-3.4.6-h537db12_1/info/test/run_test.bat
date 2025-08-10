



if not exist %LIBRARY_PREFIX%/bin/ffi-8.dll exit /b 1
IF %ERRORLEVEL% NEQ 0 exit /B 1
if not exist %LIBRARY_PREFIX%/lib/libffi.lib exit /b 1
IF %ERRORLEVEL% NEQ 0 exit /B 1
if not exist %LIBRARY_PREFIX%/lib/ffi.lib exit /b 1
IF %ERRORLEVEL% NEQ 0 exit /B 1
if not exist %LIBRARY_PREFIX%/include/ffi.h exit /b 1
IF %ERRORLEVEL% NEQ 0 exit /B 1
if not exist %LIBRARY_PREFIX%/include/ffitarget.h exit /b 1
IF %ERRORLEVEL% NEQ 0 exit /B 1
llvm-nm %LIBRARY_PREFIX%/lib/libffi.lib | grep "__imp_ffi_type_void"
IF %ERRORLEVEL% NEQ 0 exit /B 1
exit /B 0
