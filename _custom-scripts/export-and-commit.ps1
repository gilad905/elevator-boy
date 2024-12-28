$path = "_exports/web"
$main = "./scenes/main.tscn"
$date = Get-Date -Format "MM-dd HH:mm"
$version = "{version:$date}"
$godot = "C:\Users\gilad\Documents\Programming\Game dev\Godot_v4.3-stable_win64\Godot_v4.3-stable_win64.exe"
Write-Output "version: $date"

(Get-Content $main) -replace '\{version:[^}]*\}', $version | Set-Content $main
Remove-Item $path/* -exclude .git
Start-Process -FilePath "$godot" -ArgumentList "--headless --export-debug Web" -NoNewWindow -Wait

git -C $path add -A
git -C $path --no-pager diff HEAD --name-status
git -C $path commit -m "new"
git -C $path push -u origin