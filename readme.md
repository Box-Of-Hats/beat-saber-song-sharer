# Beat Saber Song Sharer

Beat saber song sharer lets you import and export your custom beat saber songs that were downloaded from [https://bsaber.com/](https://bsaber.com/).

## What does it do

There are 2 scripts provided: One which will **export** all of your custom songs into a single json file and one which will **import** all of the songs in a json file into your beat saber library.

This makes sharing songs between friends much easier.

## Prerequisites

### ModAssistant.exe

You will need to download [ModAssistant.exe](https://github.com/Assistant/ModAssistant) separately and take note of where you store the exe because these scripts rely on it.

It's free and a must-have tool for anyone using custom songs/mods with beat saber.


### Song filename format

All songs in your custom song directory should follow the normal format that [BSaber](https://bsaber.com/) uses: `"SONG_ID (song name)"`

For example: `"124 (Rasputin (Funk Overload) - jobas)"`. By default, songs downloaded from [BSaber](https://bsaber.com/) using  [ModAssistant.exe](https://github.com/Assistant/ModAssistant) will already have this filename format so you should be good to go.

The export script will **try its best** to ignore any files that don't follow the required format

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

## General

Exporting your song library creates a JSON file that contains the song IDs (as found on [bsaber.com](https://bsaber.com/)) of all of your custom songs.


This list can then be used by someone else to import all of those same songs to their beat saber library.

An example song file:

```json
{
  "songs": [
    {
      "id": "1023",
      "songName": "(I Wanna Be Like You (Sim Gretina Remix) - ConnorJC)",
      "originalFileName": "1023 (I Wanna Be Like You (Sim Gretina Remix) - ConnorJC)"
    },
    {
      "id": "1060",
      "songName": "(X Gon' Give It To Ya Maybe - ruckus)",
      "originalFileName": "1060 (X Gon' Give It To Ya Maybe - ruckus)"
    },
    {
      "id": "1074",
      "songName": "(State Of Mind - roeek)",
      "originalFileName": "1074 (State Of Mind - roeek)"
    }
  ]
}
```
