# Asset contract

Generated art enters the game only as copied static files under `art/`. The game must run without either Studio, ComfyUI, Python, or local models.

Terrain uses atomic 64x32-footprint assets packed deterministically after approval. Character sheets expose four logical isometric directions: `dl`, `dr`, `ul`, and `ur`. Mirrored right-facing art is allowed temporarily, but all four animation names must exist.

## MVP provenance

- `art/tiles/grass.png`: generated through the unmodified Z-Image Studio API, seed `87214021`, then cropped and nearest-neighbor hardened in the game workspace.
- `art/characters/slime/slime.png`: generated through the unmodified Z-Image Studio API, seed `87214022`, then packed into four bobbing frames in the game workspace.
- `art/characters/guardian/guardian.png`: copied from Frame Motion Studio's committed `assets/showcase/godot-overworld/spritesheet.png` export.
- `art/tiles/road.png`: deterministically derived from the approved grass tile so every edge and footprint remains identical.
- `art/props/shrine.png`: generated through the unmodified Z-Image Studio API, seed `87214023`, then cropped and nearest-neighbor hardened in the game workspace.
- `art/props/bush.png`: generated through the unmodified Z-Image Studio API, seed `87214024`, then cropped and nearest-neighbor hardened in the game workspace.

## Layer contract

Rendering order is ground, roads, environment actors, enemies/towers, projectiles, placement hover, then HUD. Props use bottom-center cell anchors. Their visible footprint blocks nearby placement cells so towers cannot overlap the artwork.
