cd exports/web
rmdir .
"C:\Users\gilad\Documents\Programming\Game dev\Godot_v4.3-stable_win64\Godot_v4.3-stable_win64.exe" --headless --export-debug "Web"
git diff --name-status
git add -A
git commit -m "new"
git push -u origin