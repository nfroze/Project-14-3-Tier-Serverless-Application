Get-ChildItem -Filter *.py | ForEach-Object {
    Compress-Archive -Path $_.Name -DestinationPath "$($_.BaseName).zip" -Force
}
Write-Host "Lambda functions packaged successfully" -ForegroundColor Green