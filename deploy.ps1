$src  = "$HOME\Desktop\biter-pet"
$dest = "$env:APPDATA\factorio\mods\biter-pet"
$info = Join-Path $src "info.json"

# --- Auto-increment minor version ---
$json = Get-Content $info -Raw | ConvertFrom-Json

$parts = $json.version.Split('.')
$major = [int]$parts[0]
$minor = [int]$parts[1] + 1
$patch = [int]$parts[2]

$json.version = "$major.$minor.$patch"
$json | ConvertTo-Json -Depth 10 | Set-Content $info

Write-Host "Version updated to $($json.version)"

# --- Sync folder ---
if (Test-Path $dest) {
    Remove-Item $dest -Recurse -Force
}

Copy-Item $src $dest -Recurse -Force
Remove-Item (Join-Path $dest "deploy.ps1") -ErrorAction SilentlyContinue

Write-Host "Folder synchronization complete!"
Write-Host "Remember: rate limiter may hide logs during debugging."