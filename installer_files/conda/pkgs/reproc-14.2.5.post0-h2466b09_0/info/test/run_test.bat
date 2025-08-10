



@echo on
IF %ERRORLEVEL% NEQ 0 exit /B 1
if not exist %LIBRARY_PREFIX%\include\reproc\run.h (exit 1)
IF %ERRORLEVEL% NEQ 0 exit /B 1
if not exist %LIBRARY_PREFIX%\lib\reproc.lib (exit 1)
IF %ERRORLEVEL% NEQ 0 exit /B 1
if not exist %LIBRARY_PREFIX%\bin\reproc.dll (exit 1)
IF %ERRORLEVEL% NEQ 0 exit /B 1
if not exist %LIBRARY_PREFIX%\lib\cmake\reproc\reproc-config.cmake (exit 1)
IF %ERRORLEVEL% NEQ 0 exit /B 1
if exist %LIBRARY_PREFIX%\include\reproc++\run.hpp (exit 1)
IF %ERRORLEVEL% NEQ 0 exit /B 1
if exist %LIBRARY_PREFIX%\lib\reproc++.lib (exit 1)
IF %ERRORLEVEL% NEQ 0 exit /B 1
if exist %LIBRARY_PREFIX%\bin\reproc++.dll (exit 1)
IF %ERRORLEVEL% NEQ 0 exit /B 1
if exist %LIBRARY_PREFIX%\lib\reproc_static.lib (exit 1)
IF %ERRORLEVEL% NEQ 0 exit /B 1
if exist %LIBRARY_PREFIX%\lib\reproc++_static.lib (exit 1)
IF %ERRORLEVEL% NEQ 0 exit /B 1
if exist %LIBRARY_PREFIX%\lib\cmake\reproc++\reproc++-config.cmake (exit 1)
IF %ERRORLEVEL% NEQ 0 exit /B 1
cmake -G Ninja -S test-c/ -B build-test-c/ %CMAKE_ARGS%
IF %ERRORLEVEL% NEQ 0 exit /B 1
cmake --build build-test-c/
IF %ERRORLEVEL% NEQ 0 exit /B 1
cmake --build build-test-c/ --target test
IF %ERRORLEVEL% NEQ 0 exit /B 1
exit /B 0
