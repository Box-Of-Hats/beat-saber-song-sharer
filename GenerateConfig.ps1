# This is used for first time setup

$configPath = "./config.json"


$pageWidth = 50
Write-Host "|".PadRight($pageWidth, "-") "|"
Write-Host "|                 First time setup".PadRight($pageWidth, " ") "|"
Write-Host "|".PadRight($pageWidth, " ") "|"
Write-Host "| Follow the steps to generate your config file".PadRight($pageWidth, " ") "|"
Write-Host "| (You'll only have to do this once)".PadRight($pageWidth, " ") "|"
Write-Host "|".PadRight($pageWidth, "_") "|"
Write-Host

if (Test-Path $configPath) {
    Write-Host "WARN: Config already exists at $configPath. Exit now if you dont want to overwrite your file!" -ForegroundColor Red
}

function PromptForParam {
    Param(
        [string] $ParamName,
        [string] $DefaultValue,
        [string] $FriendlyName
    )
    Write-Host "Please enter $FriendlyName"
    Write-Host "Leave blank to use default value (`"$DefaultValue`")"
    $input = Read-Host ">"
    $value = if ([string]::IsNullOrWhiteSpace($input)) { $DefaultValue } else { $input }
    $value = $value.Replace("\", "/") #Hackily replace backslashes in filepaths
    return "  `"$ParamName`": `"$value`","
}

$params = @(
    @{
        name     = "CustomSongsDirectory";
        default  = "C:/Program Files/Steam/steamapps/common/Beat Saber/Beat Saber_Data/CustomLevels";
        friendly = "your Beat Saber custom songs folder";
    }
)


$configContents = "{"
foreach ($param in $params) {
    $line = PromptForParam -ParamName $param.name -DefaultValue $param.default -FriendlyName $param.friendly
    $configContents += "`n"
    $configContents += $line
}
$configContents = $configContents.TrimEnd(",")
$configContents += "`n}"

$configContents > $configPath
Write-Host "Generated config file. You can change this manually in $configPath" -ForegroundColor Green
Start-Sleep 1
