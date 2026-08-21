# Asset contract

Generated art enters the game only as copied static files under `art/`. The game must run without either Studio, ComfyUI, Python, or local models.

Terrain uses atomic 64x32-footprint assets packed deterministically after approval. Character sheets expose four logical isometric directions: `dl`, `dr`, `ul`, and `ur`. Mirrored right-facing art is allowed temporarily, but all four animation names must exist.

