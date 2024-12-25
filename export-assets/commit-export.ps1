cd exports/web
Remove-Item * -exclude .git
$godot = "C:\Users\gilad\Documents\Programming\Game dev\Godot_v4.3-stable_win64\Godot_v4.3-stable_win64.exe"
Start-Process -FilePath "$godot" -ArgumentList "--headless --export-debug Web" -NoNewWindow -Wait
echo here
# git diff --name-status
# git add -A
# git commit -m "new"
# git push -u origin
cd ../..