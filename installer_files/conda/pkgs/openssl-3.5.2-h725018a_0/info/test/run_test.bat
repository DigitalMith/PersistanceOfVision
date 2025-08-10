



copy NUL checksum.txt
IF %ERRORLEVEL% NEQ 0 exit /B 1
%LIBRARY_BIN%\openssl sha256 checksum.txt
IF %ERRORLEVEL% NEQ 0 exit /B 1
if not exist "%SSL_CERT_FILE%" exit 1
IF %ERRORLEVEL% NEQ 0 exit /B 1
pkg-config --print-errors --exact-version "3.5.2" openssl
IF %ERRORLEVEL% NEQ 0 exit /B 1
type %CONDA_PREFIX%\etc\conda\activate.d\openssl_activate-win.sh | rg \r & if ERRORLEVEL ==1 (exit 0) else (exit 1)
IF %ERRORLEVEL% NEQ 0 exit /B 1
type %CONDA_PREFIX%\etc\conda\deactivate.d\openssl_deactivate-win.sh | rg \r & if ERRORLEVEL ==1 (exit 0) else (exit 1)
IF %ERRORLEVEL% NEQ 0 exit /B 1
exit /B 0
