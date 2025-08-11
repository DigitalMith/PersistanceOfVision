@echo off
REM Activate correct environment manually
CALL C:\Orion\text-generation-webui\installer_files\conda\Scripts\activate.bat C:\Orion\text-generation-webui\installer_files\env

REM Confirm which Python is being used
echo Using Python:
where python

REM Force correct Python to launch Orion with extension
CALL C:\Orion\text-generation-webui\installer_files\env\python.exe server.py --extensions orion_ltm
