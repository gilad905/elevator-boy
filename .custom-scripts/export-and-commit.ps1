$path = "@exports/web"
$settings = "./resources/export_settings.gd"
$date = Get-Date -Format "MM-dd HH:mm"
Write-Output "version: $date"

(Get-Content $settings) -replace '(?<=version = ")[^"]*', $date | Set-Content $settings
(Get-Content $settings) -replace '(?<=is_dev = )true', 'false' | Set-Content $settings
Remove-Item $path/* -exclude .git
Start-Process godot.exe -ArgumentList "--headless --export-debug Web" -NoNewWindow -Wait

git -C $path add -A
git -C $path commit -m "new"
git -C $path push -u origin