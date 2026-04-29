Set-StrictMode -Version Latest

$root = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
$venvPath = Join-Path $root '.venv'
$requirements = Join-Path $root 'requirements.txt'

if (-Not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Error 'Python was not found in PATH. Install Python 3.11+ and retry.'
    exit 1
}

if (-Not (Test-Path $requirements)) {
    Write-Error "Missing requirements.txt in $root"
    exit 1
}

if (-Not (Test-Path $venvPath)) {
    Write-Host "Creating virtual environment at $venvPath..."
    python -m venv $venvPath
}
else {
    Write-Host "Using existing virtual environment at $venvPath."
}

$activateScript = Join-Path $venvPath 'Scripts\Activate.ps1'
$pip = Join-Path $venvPath 'Scripts\pip.exe'

if (-Not (Test-Path $pip)) {
    Write-Error 'Failed to find pip in the virtual environment. The venv may not have been created correctly.'
    exit 1
}

Write-Host 'Upgrading pip...'
& $pip install --upgrade pip

Write-Host 'Installing dependencies from requirements.txt...'
& $pip install -r $requirements

Write-Host '`nSetup complete.'
Write-Host 'Activate the environment with:'
Write-Host "    & '$activateScript'"
