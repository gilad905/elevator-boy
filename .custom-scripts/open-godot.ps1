$ErrorActionPreference = "Stop"

$godot = Invoke-Command -ScriptBlock { node ./.custom-scripts/find-godot.mjs }
$cwd = Get-Location

Start-Job {
	param($cwd, $godot)
	Set-Location "$cwd"
	Start-Process -FilePath "$godot" .\project.godot
} -ArgumentList $cwd, $godot