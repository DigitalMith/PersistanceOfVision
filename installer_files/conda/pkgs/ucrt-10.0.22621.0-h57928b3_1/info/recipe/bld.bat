@echo on
REM Avoid circular dependency issues with 7zip dependending on ucrt
conda.exe create -p %BUILD_PREFIX%  7zip --yes --quiet -c conda-forge
mkdir %LIBRARY_BIN%
7z x 22621.1.220506-1250.ni_release_WindowsSDK.iso -aoa
if errorlevel 1 exit 1
msiexec /a "%SRC_DIR%\Installers\Universal CRT Redistributable-x86_en-us.msi" /qb TARGETDIR="%SRC_DIR%\tmp"
if errorlevel 1 exit 1
xcopy "tmp\Windows Kits\10\Redist\%PKG_VERSION%\ucrt\DLLs\x64\"* "%PREFIX%"
if errorlevel 1 exit 1
xcopy "tmp\Windows Kits\10\Redist\%PKG_VERSION%\ucrt\DLLs\x64\"* "%LIBRARY_BIN%"
if errorlevel 1 exit 1
