# FindSteamgamePath

Shell Script for finding Steam Program's installed path based on its manifest number in Windows

## Usage

./findSteamgame.sh {game_manifest_NO}

## Basic Idea

1. get main Steam directory by using Reg Query
2. loop through libraryfolders.vdf in main Steam directory
3. find appmanifest with given input

## Future works?

maybe rewrite in PS1 / bat

maybe support for the linux

maybe additional works for catching errors like
- "script outputs dir where the Steam program was NOT properly uninstalled"

**but not for now**
