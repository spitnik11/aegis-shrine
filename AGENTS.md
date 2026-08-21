# Aegis Shrine agent rules

- Build only the current MVP phase documented in `docs/MVP.md`.
- Use Godot 4.7 APIs and `TileMapLayer`, not deprecated `TileMap`.
- Keep pixel art crisp with nearest filtering and integer-friendly rendering.
- Never modify or add runtime dependencies on `Z:\codex app`, `Z:\frame-motion-studio`, ComfyUI, model folders, or their environments.
- Treat all studio output as static imported art.
- Do not add dynamic pathfinding, procedural maps, multiplayer, saves, campaigns, inventories, skill trees, custom editor plugins, ECS, or modding during the MVP.
- Run the Godot headless verification command before committing.

