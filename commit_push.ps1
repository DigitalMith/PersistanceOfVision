<# 
  commit_push.ps1 — Commit & push helper for Orion

  Usage:
    .\commit_push.ps1 -m "feat: update memory pipeline"
    .\commit_push.ps1 -m "docs: README tweak" -Files README.md
    .\commit_push.ps1 -m "chore: scripts" -NoPush    # commit only
    .\commit_push.ps1 -m "fix: ..." -NoAdd           # skip 'git add'

  Flags:
    -m, -Message    (required) Commit message.
    -Files          Optional list of files to stage (defaults to all changes).
    -NoAdd          Skip 'git add' step.
    -NoPush         Skip 'git push' step.
#>

param(
  [Parameter(Mandatory = $false)]
  [Alias("m")]
  [string]$Message,

  [string[]]$Files,

  [switch]$NoAdd,
  [switch]$NoPush
)

function Show-Usage {
  Write-Host ""
  Write-Host "Usage:" -ForegroundColor Yellow
  Write-Host "  .\commit_push.ps1 -m ""<commit message>""" -ForegroundColor Yellow
  Write-Host "  .\commit_push.ps1 -m ""<msg>"" -Files README.md scripts\orion_preflight.py" -ForegroundColor Yellow
  Write-Host ""
  Write-Host "Flags:" -ForegroundColor Yellow
  Write-Host "  -m, -Message   (required) Commit message."
  Write-Host "  -Files         Optional list of files to stage; if omitted, stages ALL changes."
  Write-Host "  -NoAdd         Skip 'git add' (use when you've already staged)."
  Write-Host "  -NoPush        Commit only (do not push)."
  Write-Host ""
}

# Require a message
if (-not $Message -or $Message.Trim() -eq "") {
  Write-Host "ERROR: Missing commit message (-m)." -ForegroundColor Red
  Show-Usage
  exit 2
}

# Require git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  Write-Host "ERROR: 'git' not found in PATH." -ForegroundColor Red
  exit 1
}

# Ensure we're inside a git repo
$repoRoot = (& git rev-parse --show-toplevel) 2>$null
if ($LASTEXITCODE -ne 0 -or -not $repoRoot) {
  Write-Host "ERROR: Not inside a git repository." -ForegroundColor Red
  exit 1
}

Set-Location $repoRoot

# Stage changes (unless -NoAdd)
if (-not $NoAdd) {
  if ($Files -and $Files.Count -gt 0) {
    Write-Host "Staging specific files:" ($Files -join ", ")
    & git add -- $Files
  } else {
    Write-Host "Staging ALL changes (git add -A)..."
    & git add -A
  }
  if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: 'git add' failed." -ForegroundColor Red
    exit 1
  }
}

# If nothing is staged, exit nicely
& git diff --cached --quiet
if ($LASTEXITCODE -eq 0) {
  Write-Host "No staged changes. Nothing to commit." -ForegroundColor Yellow
  Write-Host "Tip: modify files or pass -Files to stage specific files."
  Show-Usage
  exit 0
}

# Commit
Write-Host "Committing: $Message"
& git commit -m $Message
if ($LASTEXITCODE -ne 0) {
  Write-Host "ERROR: 'git commit' failed." -ForegroundColor Red
  exit 1
}

if ($NoPush) {
  Write-Host "Commit created (skipping push by request -NoPush)." -ForegroundColor Green
  exit 0
}

# Determine branch
$branch = (& git rev-parse --abbrev-ref HEAD).Trim()
if (-not $branch -or $branch -eq "HEAD") {
  Write-Host "ERROR: Could not determine current branch (detached HEAD?)." -ForegroundColor Red
  exit 1
}

# Check if upstream exists; if not, set it
Invoke-Expression 'git rev-parse --abbrev-ref --symbolic-full-name "@{u}"' 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) {
  Write-Host "No upstream set. Pushing with upstream to 'origin/$branch'..."
  & git push -u origin $branch
} else {
  Write-Host "Pushing to upstream..."
  & git push
}

if ($LASTEXITCODE -ne 0) {
  Write-Host "ERROR: 'git push' failed." -ForegroundColor Red
  exit 1
}

Write-Host "✅ Commit and push complete on branch '$branch'." -ForegroundColor Green
