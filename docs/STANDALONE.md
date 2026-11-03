# Standalone Mortal Kombat: Deception / Armageddon builds

This branch keeps the original MK3D Rollback project intact while providing a
clear build path for two independent Windows executables:

- `MKD.exe` for **Mortal Kombat: Deception**
- `MKA.exe` for **Mortal Kombat: Armageddon**

The intent is not to turn the project into another multi-game launcher. Each
game should be usable as its own application and can therefore be added to
Steam, Playnite, a desktop shortcut, or another frontend as a separate title.

The existing launcher, rollback code, online code and research files are kept
in this branch. `MK3DLauncher.exe` may still be useful for the original
launcher-managed online/session workflow, but it is not required as a game
selector for the standalone builds.

## Deadly Alliance

Deadly Alliance is intentionally outside the scope of this branch. A separate
working native-PC preservation project already exists here:

**https://github.com/WildGer/MKDA-PC**

This keeps the three games as distinct projects/entries rather than forcing
Deadly Alliance back into this branch.

## Required game data

No copyrighted game files are included. Supply files from your own Xbox copies
under the per-game asset directories:

```text
recomp\mkd\assets\default.xbe
recomp\mka\assets\default.xbe
```

Keep the rest of each extracted game's files beside its `default.xbe` in the
corresponding `assets` directory.

## Build both standalone executables

From the repository root:

```bat
git checkout standalone-mkd-mka
build-standalone.bat
```

The script first prepares the patched XboxXBERecomp SDK expected by this
project, then builds Deception followed by Armageddon.

Expected outputs:

```text
recomp\mkd\out\build\release\MKD.exe
recomp\mka\out\build\release\MKA.exe
```

## Build only one game

Deception:

```bat
cd recomp\mkd
build.bat
```

Armageddon:

```bat
cd recomp\mka
build.bat
```

## Steam / frontend layout

Use the executables directly as separate entries:

```text
Mortal Kombat: Deception
  -> ...\recomp\mkd\out\build\release\MKD.exe

Mortal Kombat: Armageddon
  -> ...\recomp\mka\out\build\release\MKA.exe
```

The visible library name can be whatever the frontend uses; the underlying
executables should remain `MKD.exe` and `MKA.exe` so their associated build and
runtime naming stays consistent.

## SDK patching

The shared MK3D runtime depends on project-specific XboxXBERecomp changes kept
under `recomp\patches`. In particular, rollback/netplay relies on host-side
rollback support and the DirectSound frame-clock API (`xdk/dsound.h`).

`tools\prepare-xberecomp.ps1` prepares the compatible SDK checkout under
`external\XboxXBERecomp` and applies the patch series. `build-standalone.bat`
runs this step automatically.

The standalone targets also enable SSE4.1 for the host runtime because the
current renderer uses `_mm_testz_si128`.

## Branch intent

This branch exists to preserve a simple rule:

**one game, one executable, one library entry.**

MKD and MKA are kept separate from each other at launch time, and MKDA remains
in its own already-working project.
