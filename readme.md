# Beat Saber Song Sharer

Beat saber song sharer lets you import and export your custom beat saber songs that were downloaded from [https://bsaber.com/](https://bsaber.com/).

## Prerequisites

### ModAssistant.exe

You will need to download [ModAssistant.exe](https://github.com/Assistant/ModAssistant) separately and take note of where you store the exe because these scripts rely on it.

It's free and a must-have tool for anyone using custom songs/mods with beat saber.


### Song filename format

All songs in your custom song directory should follow the normal format that BSaber uses: `"SONG_ID (song name)"`

For example: `"124 (Rasputin (Funk Overload) - jobas)"`. By default, songs downloaded from BSaber using ModAssistant.exe will already have this filename format so you should be good to go.

## Usage

### Export songs with default settings

Simply run the export songs script. This will look for custom songs in `"C:\Program Files\Steam\steamapps\common\Beat Saber\Beat Saber_Data\CustomLevels"`.

```powershell

.\ExportSongs.ps1

```


### Export songs with custom settings

You can export your songs from your custom install directory and/or change the output file by passing in params to the export script

```powershell

.\ExportSongs.ps1 -CustomSongsFolder "E:\Program_Files\Steam\steamapps\common\Beat Saber\Beat Saber_Data\CustomLevels" -OutFilePath "songs.json"

```

### Import songs with default settings

By default, import songs will look for `ModAssistant.exe` in the current directory and will import songs from `songs.json`.

```powershell

.\ImportSongs.ps1

```

### Import songs with custom settings

You can specify a custom json file and/or mod assistant location by passing params into ImportSongs.ps1

```powershell

.\ImportSongs.ps1 -ModAssistantPath "E:\Program Files\ModAssistant\ModAssistant.exe" -SongFile "my-songs.json"

```




