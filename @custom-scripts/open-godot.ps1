$godotPaths = @(
	"C:\Users\gilad\Documents\Programming\Game dev\Godot_v4.3-stable_win64\Godot_v4.3-stable_win64.exe",
	"D:\DEV\Own\Godot\Godot_v4.3-stable_win64.exe\Godot_v4.3-stable_win64.exe"
)

$godot = $null
foreach ($path in $godotPaths) {
	if (Test-Path $path) {
		$godot = $path
		break
	}
}

$cwd = Get-Location

Start-Job {
	param($cwd, $godot)
	Set-Location "$cwd"
	Start-Process -FilePath "$godot" .\project.godot
} -ArgumentList $cwd, $godot