$Env:CONDA_EXE = "D:\bld\conda_1743046486868\_h_env\Scripts\conda.exe"
$Env:_CE_M = $null
$Env:_CE_CONDA = $null
$Env:_CONDA_ROOT = "D:\bld\conda_1743046486868\_h_env"
$Env:_CONDA_EXE = "D:\bld\conda_1743046486868\_h_env\Scripts\conda.exe"
$CondaModuleArgs = @{ChangePs1 = $True}
Import-Module "$Env:_CONDA_ROOT\shell\condabin\Conda.psm1" -ArgumentList $CondaModuleArgs

Remove-Variable CondaModuleArgs