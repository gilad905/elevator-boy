$path = "@exports/web"
$settings = "./resources/export_settings.gd"
$date = Get-Date -Format "MM-dd HH:mm"
$godot = "C:\Users\gilad\Documents\Programming\Game dev\Godot_v4.3-stable_win64\Godot_v4.3-stable_win64.exe"
Write-Output "version: $date"

(Get-Content $settings) -replace '(?<=version = ")[^"]*', $date | Set-Content $settings
(Get-Content $settings) -replace '(?<=debugging = )true', 'false' | Set-Content $settings
Remove-Item $path/* -exclude .git
Start-Process -FilePath "$godot" -ArgumentList "--headless --export-debug Web" -NoNewWindow -Wait

git -C $path add -A
# git -C $path --no-pager diff HEAD --name-status
git -C $path commit -m "new"
git -C $path push -u origin