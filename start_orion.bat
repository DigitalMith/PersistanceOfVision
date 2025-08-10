@echo off
REM ============================================
REM Orion TGWUI Startup Script (eGPU / Chroma)
REM ============================================

REM Change to project root
cd /d C:\Orion\text-generation-webui

REM Point to venv Python
set PYTHON=C:\Orion\text-generation-webui\installer_files\env\python.exe

REM Optional: disable Chroma telemetry & speed up CUDA DLL load
set CHROMA_DISABLE_TELEMETRY=1
set CUDA_MODULE_LOADING=LAZY

REM Launch TGWUI
%PYTHON% server.py ^
  --listen ^
  --listen-host 127.0.0.1 ^
  --listen-port 7860 ^
  --model "openhermes-2.5-mistral-7b.Q4_K_M.gguf" ^
  --extensions orion_ltm
