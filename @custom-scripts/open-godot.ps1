$godot = "C:\Users\gilad\Documents\Programming\Game dev\Godot_v4.3-stable_win64\Godot_v4.3-stable_win64.exe"
$cwd = Get-Location
Start-Job {
	param($cwd, $godot)
	Set-Location "$cwd"
	Start-Process -FilePath "$godot" .\project.godot
} -ArgumentList $cwd, $godot