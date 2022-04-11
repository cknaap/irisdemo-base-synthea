Push-Location $PSScriptRoot

$VERSION = Get-Content -Path ./VERSION
$VERSION

# Build synthea distribution tar file
./build_synthea.ps1

# Containerize it
docker build -t firely/synthea:$VERSION .

Pop-Location
