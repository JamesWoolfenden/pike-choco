#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
$outfile="pike.zip"
$version=(Invoke-Webrequest https://api.github.com/repos/jameswoolfenden/pike/releases/latest|convertfrom-json).name

Write-Host "$(get-date) - downloading release $version"
set-content -path ./tools/VERIFICATION.txt -value ((Get-Content -path ./tools/VERIFICATION.txt -Raw) -replace 'PLACEHOLDER', $version)
$version=$version.Replace("v","")

Write-Output "https://github.com/JamesWoolfenden/pike/releases/download/v$($version)/pike_$($version)_windows_amd64.zip"
     
Invoke-WebRequest -uri "https://github.com/JamesWoolfenden/pike/releases/download/v$($version)/pike_$($version)_windows_amd64.zip" -OutFile $outfile
tar -xvf $outfile -C .\tools\

Write-Host "$(get-date) - packing"
choco pack --version $version

Get-ChildItem *.nupkg
Write-Host "$(get-date) - Pushing to Chocolatey Feed"
choco push $package.Name -s https://push.chocolatey.org/ --api-key=$env:CHOCOPUSHKEY
