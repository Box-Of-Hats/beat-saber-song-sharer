Param(
	[string] $SongFile
)

if (! (Test-Path "./config.json")) {
	./GenerateConfig.ps1
}
$config = Get-Content "./config.json" | ConvertFrom-Json
$customSongDir = $config.CustomSongsDirectory;

if ([string]::IsNullOrEmpty) {
	$SongFile = "./songs.json"
}

if (! (Test-Path $SongFile)) {
	Write-Host "Could not find song file with path: $SongFile" -ForegroundColor Red
	Write-Host "This needs to be a JSON file that contains a beat saber library." -ForegroundColor Yellow
	Write-Host "You can generate one from ExportSongs.ps1" -ForegroundColor Yellow
	return
}


$workingDir = "./working/"
if (! (Test-Path $workingDir)) {
	New-Item -ItemType Directory -Path $workingDir
}

function IsRateLimited() {
	Param(
		$Request
	)
	return $Request.Headers.'Rate-Limit-Remaining' -eq 0
}

function WaitIfRateLimited() {
	Param(
		$Request
	)
	if (IsRateLimited($Request)) {
		Write-Host "[!] Currently rate limited. Waiting for rate-limit reset..." -ForegroundColor Red
		$now = [int][double]::Parse((Get-Date -UFormat %s))
		$resetsAt = $Request.Headers.'Rate-Limit-Reset';
		while ($now -le $resetsAt) {
			$now = [int][double]::Parse((Get-Date -UFormat %s))
			$secondsToGo = $resetsAt - $now
			Write-Host "Time until rate limit: $secondsToGo secs..."
			Start-Sleep -Seconds 1
		}
	}
}

function GetSongDetails($songId) {
	return Invoke-RestMethod -Method Get -Uri "https://beatsaver.com/api/maps/detail/$songId"
}

function DownloadSong() {
	Param(
		[string] $SongId,
		[string] $FileName
	)

	$url = "https://beatsaver.com/api/download/key/$SongId"
	if (Test-Path -LiteralPath $FileName) {
		Write-Host "Path already exists. Skipping download..." -ForegroundColor Red
		return
	}
	Write-Host "($url | $FileName)"
	$request = Invoke-WebRequest $url -OutFile $FileName
	return $request
}

function GetFileName() {
	Param(
		$SongDetails
	)
	$songId = $SongDetails.key
	$songName = $SongDetails.name
	$author = $SongDetails.uploader.username
	return "$songId ($songName - $author)"
}



$songData = Get-Content -Raw -Path $SongFile | ConvertFrom-Json

$songsImported = 0;
$songsProcessed = 0;
$totalSongCount = $songData.songs.Length
foreach ($song in $songData.songs) {
	$songsProcessed += 1;

	$songName = $song.songName
	$id = $song.Id.ToString()
	$originalFileName = $song.originalFileName


	Write-Host "[$songsProcessed/$totalSongCount] Importing '$songName'" -ForegroundColor Cyan

	# If we already have the original filename, use that. Otherwise, use the API to generate it
	if (! [string]::IsNullOrWhiteSpace($originalFileName)) {
		$fileName = $originalFileName
	}
 else {
		$songDetails = GetSongDetails -songId $id
		$fileName = GetFileName -SongDetails $songDetails
	}

	$downloadLocation = Join-Path $workingDir "$fileName.zip"
	$destinationLocation = Join-Path $customSongDir $fileName

	$doesAlreadyExist = Test-Path -LiteralPath $destinationLocation
	if ($doesAlreadyExist) {
		Write-Host " [s] Song already exists. Skipping..." -ForegroundColor Yellow
		continue;
	}

	Write-Host " [d] Downloading... => " -NoNewline
	$downloadResponse = DownloadSong -SongId $id -FileName $downloadLocation;

	WaitIfRateLimited -Request $downloadResponse

	Write-Host " [e] Expanding... => $destinationLocation"
	Expand-Archive -Path $downloadLocation -DestinationPath $destinationLocation

	Write-Host " [r] Removing... => $downloadLocation"
	Remove-Item $downloadLocation

	# Sleep to help prevent getting blacklisted
	Write-Host " [z] Sleeping" -NoNewline
	for ($i = 0; $i -lt 5; $i++ ) {
		Write-Host "." -NoNewline
		Start-Sleep -Milliseconds 500
	}
	Write-Host "."

	$songsImported += 1 ;
}



