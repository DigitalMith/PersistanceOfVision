



if not exist %LIBRARY_PREFIX%\\bin\\git.exe exit 1
IF %ERRORLEVEL% NEQ 0 exit /B 1
git --version
IF %ERRORLEVEL% NEQ 0 exit /B 1
git clone https://github.com/conda-forge/git-feedstock
IF %ERRORLEVEL% NEQ 0 exit /B 1
exit /B 0
