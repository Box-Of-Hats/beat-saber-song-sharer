# Beat Saber Song Sharer

Beat saber song sharer lets you import and export your custom beat saber songs that were downloaded from [https://bsaber.com/](https://bsaber.com/).

## What does it do

There are 2 scripts provided: One which will **export** all of your custom songs into a single json file and one which will **import** all of the songs in a json file into your beat saber library.

This makes sharing songs between friends much easier.

## Prerequisites

### Song filename format

All songs in your custom song directory should follow the normal format that [BSaber](https://bsaber.com/) uses: `"SONG_ID (song name)"`

For example: `"124 (Rasputin (Funk Overload) - jobas)"`. By default, songs downloaded from [BSaber](https://bsaber.com/) using  [ModAssistant.exe](https://github.com/Assistant/ModAssistant) will already have this filename format so you should be good to go.

The export script will **try its best** to ignore any files that don't follow the required format

## Usage

### First time setup

When you first run either the import or export script, you will be prompted to create a config file. This is a small file used to tell the script where your custom songs directory is. You'll only need to do this the first time you run either script.

You can always manually edit this file afterwards by going to `./config.json`.

```json
{
  "CustomSongsDirectory": "C:/Program Files/Steam/steamapps/common/Beat Saber/Beat Saber_Data/CustomLevels"
}

```


### Exporting your songs

Simply run the export songs script.

```powershell

.\ExportSongs.ps1

```

Optionally, you can provide an output file. By default songs will be output to `./songs.json`

```powershell

.\ExportSongs.ps1 -CustomSongsFolder -OutFilePath "songs.json"

```

### Importing songs into your Beat Saber library

Simply run the import songs script and all of the songs in `songs.json` will be downloaded to your beat saber library.


```powershell

.\ImportSongs.ps1

```

Optionally, you can specify a custom json file to load songs from.

```powershell

.\ImportSongs.ps1  -SongFile "my-songs.json"

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
