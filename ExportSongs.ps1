Param( [string] $OutFilePath )

$customSongsFolder = "E:\Program_Files\Steam\steamapps\common\Beat Saber\Beat Saber_Data\CustomLevels"

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


$songFileNames = Get-ChildItem $customSongsFolder | Select-Object -ExpandProperty Name


# Build JSON
$out = "{`n  `"songs`": [`n"
$isFirst = $true;
foreach ($fileName in $songFileNames) {
	Write-Host $fileName
	if (!$isFirst) {
		$out += ",`n"
	}
	$isFirst = $false
	$out += extractFileDetails($fileName)
}
$out += "  ]`n}"

$out > $OutFilePath

