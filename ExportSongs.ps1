Param(
	[string] $OutFilePath,
	[string] $CustomSongsFolder
)

if ([string]::IsNullOrEmpty($CustomSongsFolder)){
	$CustomSongsFolder = "C:\Program Files\Steam\steamapps\common\Beat Saber\Beat Saber_Data\CustomLevels"
}

if (! (Test-Path $CustomSongsFolder)) {
	Write-Host "Could not find custom songs folder at location: '$CustomSongsFolder'" -ForegroundColor Red
	return;
}


if ( [string]::IsNullOrEmpty($OutFilePath) ) {
	$OutFilePath = "./songs.json"
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
$isFirst = $true;
foreach ($fileName in $songFileNames) {
	Write-Host $fileName
	$fileDetails = extractFileDetails($fileName)

	if ([string]::IsNullOrEmpty($fileDetails)){
		continue;
	}

	if (!$isFirst) {
		$out += ",`n"
	}
	$isFirst = $false

	$out += $fileDetails
}
$out += "  ]`n}"

$out | Out-File $OutFilePath

