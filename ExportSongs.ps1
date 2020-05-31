Param(
	[string] $OutFilePath
)

if (! (Test-Path "./config.json")){
	./GenerateConfig.ps1
}
$config = Get-Content "./config.json" | ConvertFrom-Json

$CustomSongsFolder = $config.CustomSongsDirectory

if (! (Test-Path $CustomSongsFolder)) {
	Write-Host "Could not find custom songs folder at location: '$CustomSongsFolder'" -ForegroundColor Red
	return;
}

if ( [string]::IsNullOrEmpty($OutFilePath) ) {
	$OutFilePath = "./songs.json"
}

function shouldIncludeSong($fileName){
	$pattern = "^[a-z0-9]{0,6} \(.*\)"
	return $fileName -match $pattern
}

function extractFileDetails($fileName) {
	$split = $fileName.Split(" ")
	$id = $split[0]
	$songName = [string]::Join(" ", ($split | Select-Object -Skip 1))

	if ($id.Length -gt 5) {
		return ""
	}

	return @"
    {
      "id": "$id",
      "songName": "$songName",
      "originalFileName": "$fileName"
    }
"@
}


$songFileNames = Get-ChildItem $CustomSongsFolder | Select-Object -ExpandProperty Name


# Build JSON
$out = "{`n  `"songs`": [`n"
$processedCount = 0
$songFileNamesCount = $songFileNames.Count
foreach ($fileName in $songFileNames) {
	if (-not (shouldIncludeSong($fileName))){
		continue;
	}

	$fileDetails = extractFileDetails($fileName)

	if ([string]::IsNullOrEmpty($fileDetails)){
		continue;
	}

	if ($processedCount -gt 0) {
		$out += ",`n"
	}

	Write-Host "[$processedCount/$songFileNamesCount] Adding '$fileName'"
	$out += $fileDetails
	$processedCount++
}
$out += "`n  ]`n}"
$out | Out-File $OutFilePath

$skipCount = $songFileNamesCount - $processedCount
Write-Host "Output songs to '$OutFilePath' [added $processedCount] [$skipCount skipped]" -ForegroundColor Green
if ($skipCount -gt 0){
	Write-Host "Some songs were skipped due to having invalid filenames. See readme at https://github.com/Box-Of-Hats/beat-saber-song-sharer for more info. " -ForegroundColor Yellow
}

