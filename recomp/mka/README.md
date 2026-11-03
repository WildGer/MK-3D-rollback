# Mortal Kombat: Armageddon - XBE Recomp

An unofficial native PC port of the original Xbox version of Mortal Kombat: Armageddon (USA), built with Xbox XBE Recomp.

> [!NOTE]
> This project does not include any game assets. You must provide the files from your own legally acquired copy of the game.

## Standalone build

This project builds its own Windows executable:

`MKA.exe`

You do not need `MK3DLauncher.exe` to start the game. The launcher is optional and can still be used for launcher-managed online/session features.

### Installation / first run

1. Put your Armageddon game files in the `assets` folder. This can be an ISO or the extracted game data. If extracted, `default.xbe` must be in `assets` with the game's folders beside it.
2. Run `build.bat`.
3. The standalone executable is written to:

   `out\build\release\MKA.exe`

4. Run `MKA.exe` directly. The first start compiles the game's code for your PC if needed.
5. `settings.toml` beside the executable controls recomp/runtime settings.

For Steam, add `MKA.exe` as a non-Steam game and name the shortcut `Mortal Kombat: Armageddon`.

## Release package

Run `release.bat` to create `MKA.zip`. The package contains the standalone executable, runtime files, compiler support and an empty `assets` folder for your own game files.

## Controller support

Supports Xbox, PlayStation and Switch controllers, with hot plugging and rumble.

## System requirements

- Windows 10/11 64-bit
- GPU with Direct3D 12 support

## Building requirements

Install Visual Studio 2022 with:

- Desktop development with C++
- C++ Clang tools for Windows
- C++ CMake tools for Windows

## Credits

- Xbox XBE Recomp
- XenonRecomp
- Zydis
- toml++
- Dear ImGui
- SDL
