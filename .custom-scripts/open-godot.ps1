$ErrorActionPreference = "Stop"

$cwd = Get-Location

Start-Job {
	param($cwd)
	Set-Location "$cwd"
	Start-Process godot.exe .\project.godot
} -ArgumentList $cwd