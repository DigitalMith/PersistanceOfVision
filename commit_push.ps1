<# 
  commit_push.ps1 — Commit & push helper for Orion

  Usage examples:
    .\commit_push.ps1 -m "feat(ltm): dual-write episodic/web; wiki filter; autoload script"
    .\commit_push.ps1 -m "fix: policy loader" -Files custom_ltm\orion_memory.py,custom_ltm\test_store_callback.py
    .\commit_push.ps1 -m "chore: commit only" -NoPush
#>

param(
  [Parameter(Mandatory=$true)][string]$m,
  [string[]]$Files,
  [switch]$NoAdd,
  [switch]$NoPush
)

$ErrorActionPreference = "Stop"

# --- Repo root (adjust if different) ---
$Repo = "C:\Orion\text-generation-webui"
if (-not (Test-Path $Repo)) { Write-Host "Repo not found: $Repo" -ForegroundColor Red; exit 1 }

Set-Location $Repo

# --- Guard: ensure 'git' available ---
git --version | Out-Null

# --- Strong defaults: ensure .gitignore protects big stuff ---
$gi = @"
# Orion / TGWUI big artifacts
user_data\models/
user_data\chroma_db/
installer_files\env/
installer_files\conda/
__pycache__/
*.gguf
*.safetensors
*.pt
*.bin
*.7z
*.zip
*.log
*.cache/
"@
$giPath = Join-Path $Repo ".gitignore"
if (-not (Test-Path $giPath)) {
  $gi | Out-File -FilePath $giPath -Encoding UTF8
} else {
  # append missing lines without dupes
  $existing = Get-Content $giPath -ErrorAction SilentlyContinue
  $append = @()
  foreach ($line in $gi -split "`r?`n") {
    if ($line.Trim() -ne "" -and ($existing -notcontains $line)) { $append += $line }
  }
  if ($append.Count -gt 0) { Add-Content -Path $giPath -Value ($append -join "`r`n") }
}

# --- Determine current branch ---
$branch = (& git rev-parse --abbrev-ref HEAD).Trim()
if ([string]::IsNullOrWhiteSpace($branch)) { Write-Host "Cannot resolve git branch." -ForegroundColor Red; exit 1 }

# --- Stage files (unless -NoAdd) ---
if (-not $NoAdd) {
  if ($Files -and $Files.Count -gt 0) {
    Write-Host "Staging specified files..." -ForegroundColor Cyan
    & git add -- $Files
  } else {
    Write-Host "Staging safe defaults (tracked changes)..." -ForegroundColor Cyan
    # Add everything, but .gitignore avoids heavy stuff
    & git add -A
  }

  # Extra belt-and-suspenders: unstage known heavy paths if accidentally tracked
  $heavy = @(
    "user_data\models", "user_data\chroma_db", "installer_files\env", "installer_files\conda"
  )
  foreach ($p in $heavy) {
    & git reset HEAD -- $p 2>$null
  }
}

# --- Show status ---
& git status -s

# --- Commit ---
& git commit -m $m 2>$null
if ($LASTEXITCODE -ne 0) {
  Write-Host "Nothing to commit (working tree clean?)." -ForegroundColor Yellow
}

# --- Push (unless -NoPush) ---
if (-not $NoPush) {
  # Check if upstream is set
  & git rev-parse --abbrev-ref --symbolic-full-name "@{u}" 1>$null 2>$null
  if ($LASTEXITCODE -ne 0) {
    Write-Host "No upstream set. Pushing with upstream to 'origin/$branch'..."
    & git push -u origin $branch
  } else {
    Write-Host "Pushing to upstream..."
    & git push
  }
  if ($LASTEXITCODE -ne 0) { Write-Host "ERROR: 'git push' failed." -ForegroundColor Red; exit 1 }
}

Write-Host "✅ Commit complete on '$branch'." -ForegroundColor Green
