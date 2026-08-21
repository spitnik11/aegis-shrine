# MVP status

## Phase 0 — complete

- [x] Godot 4.7.2 executable verified
- [x] Standalone project created
- [x] Studio repositories remain external and read-only
- [x] Nearest texture filtering configured
- [x] Headless editor import succeeds

## First playable MVP — complete

- [x] Generated pixel-art grass renders on isometric `TileMapLayer` coordinates
- [x] Crisp nearest-neighbor rendering and pixel snapping
- [x] Guardian uses the Frame Motion sprite sheet with four logical directions
- [x] Generated slime uses a four-frame `SpriteFrames` walk animation
- [x] Fixed `Path2D` route reaches the shrine without looping
- [x] Mouse hover maps through `TileMapLayer.local_to_map()`
- [x] Towers place only on valid, unoccupied grass and deduct 50 gold
- [x] First-target combat, directional attack, projectile, damage, death, and gold reward
- [x] Three waves, shrine lives, victory, defeat, and restart
- [x] Full one-tower victory run visually verified in Godot 4.7.2
- [x] Full no-tower defeat run visually verified in Godot 4.7.2

## Verification — 2026-08-21

One Guardian completed all three waves with four shrine lives remaining. The no-tower run reached zero lives and displayed the defeat panel. `Play Again` reset gold, lives, waves, enemies, and placements.

## Deferred polish

- Unique right-facing Guardian art instead of logical direction reuse
- Audio, hit flash, and impact particles

## Environment polish milestone — complete

- [x] Grass tiles connect on the Godot isometric grid without gaps
- [x] Deterministic road tiles replace the flat road overlay and connect continuously
- [x] Generated shrine anchors the route endpoint
- [x] Generated flowering bushes break up grass repetition
- [x] Explicit draw order: ground → roads → actors/enemies → projectiles → hover → HUD
- [x] Shrine renders over arriving enemies
- [x] Decoration footprints reject overlapping tower placement
- [x] Real Godot render visually verified at 1280x720
