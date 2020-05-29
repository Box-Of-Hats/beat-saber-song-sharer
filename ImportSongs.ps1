Param(
	[string] $SongFile ,
	[string] $ModAssistantPath
)

if ([string]::IsNullOrEmpty) {
	$SongFile = "songs.json"
}

if ([string]::IsNullOrEmpty($ModAssistantPath)) {
	$ModAssistantPath = ".\ModAssistant.exe";
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
	Start-Sleep -Milliseconds 10000
}



