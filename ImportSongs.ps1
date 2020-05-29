Param(
	[string] $SongFile ,
	[string] $ModAssistantPath
)

if ([string]::IsNullOrEmpty) {
	$SongFile = "./songs.json"
}

if ([string]::IsNullOrEmpty($ModAssistantPath)) {
	$ModAssistantPath = "./ModAssistant.exe";
}

if (! (Test-Path $SongFile)) {
	Write-Host "Could not find song file with path: $SongFile" -ForegroundColor Red
	Write-Host "This needs to be a JSON file that contains a beat saber library." -ForegroundColor Yellow
	Write-Host "You can generate one from ExportSongs.ps1" -ForegroundColor Yellow
	return
}

if (! (Test-Path $ModAssistantPath)) {
	Write-Host "Could not find ModAssistant with path: $ModAssistantPath" -ForegroundColor Red
	return
}

$songData = Get-Content -Raw -Path $SongFile | ConvertFrom-Json

foreach ($song in $songData.songs) {
	$songName = $song.songName
	$id = $song.Id
	$originalFileName = $song.originalFileName

	$url = "beatsaver://$id"

	Write-Host "Importing: " "$id".PadRight(8, " ") "`t$url" "`t'$songName'"

	& $ModAssistantPath @("--install", "$url")

	# Sleep to prevent getting blacklisted
	Start-Sleep -Milliseconds 2000
}



