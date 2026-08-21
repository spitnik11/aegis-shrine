# Aegis Shrine

A small isometric pixel-art tower-defense game built with Godot 4.

The game is standalone. Z-Image Studio and Frame Motion Studio are external authoring tools only; exported art is copied into this repository as ordinary game assets.

## Play

Click grass to place a Guardian for 50 gold, then press **Start Wave**. Survive all three waves to defend the shrine. Towers cannot be placed on the road or occupied cells.

## Open

```powershell
& 'C:\Users\losth\Desktop\godot\Godot_v4.7.2-stable_win64.exe' --editor --path 'Z:\Claude app\aegis-shrine'
```

## Verify

```powershell
& 'C:\Users\losth\Desktop\godot\Godot_v4.7.2-stable_win64_console.exe' --headless --path 'Z:\Claude app\aegis-shrine' --editor --quit
```

The playable MVP was visually verified through both victory and defeat on Godot 4.7.2.
