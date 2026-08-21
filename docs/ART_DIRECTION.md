# Pixel art production philosophy

## The rule

An image that looks pixelated is concept art until it passes the asset contract. Production pixel art has a declared native grid, deliberate clusters, a controlled palette, binary alpha, exact projection and anchors, and survives nearest-neighbor display at 1x.

## Aegis Shrine visual grammar

- Readable chibi silhouettes at gameplay scale; detail may never cost recognition.
- Fixed 2:1 isometric projection for world assets and an exact 64x32 terrain footprint.
- Upper-left key light, compact shadows, muted navy/teal stone and cloth, restrained moss, and one warm amber gameplay accent.
- One shared palette per asset family, normally 8-16 colors after hardening.
- Hard clusters and intentional stair-steps. No anti-aliasing, subpixel detail, painterly gradients, photorealism, or perspective drift.
- Terrain edges must connect in a repeated 3x3 preview. Props and actors use bottom-center anchors.
- Ground, roads, back environment, actors, front environment, effects, placement feedback, and HUD remain distinct render layers.

## Generation contract

Generate atomic assets, not final atlases. A prompt must state:

1. asset and gameplay function;
2. exact view or projection;
3. native cell or footprint;
4. silhouette and only the identity-bearing details;
5. palette and light direction;
6. anchor and background;
7. exclusions such as text, scenery, gradients, anti-aliasing, and extra views.

Use `8-bit` or `16-bit` only as loose mood vocabulary. They do not define a grid, projection, palette, or production constraint. Generate one direction, frame, or tile at a time when consistency matters. A multi-view sheet is acceptable for exploration, but every view must still be split, normalized, and approved independently.

## Deterministic hardening gate

Every generated candidate must be copied out of the external Studio and processed in the game workspace:

1. remove the background and force alpha to 0 or 255;
2. crop visible bounds;
3. fit once to the declared native canvas;
4. quantize to the approved family palette;
5. use nearest-neighbor for every later resize;
6. align the bottom-center anchor;
7. inspect at native 1x and an integer-magnified preview;
8. repeat tiles in a 3x3 seam test and compare animation frames as an overlay;
9. pack only approved atomic assets into deterministic sheets or atlases;
10. verify the imported result in Godot.

Generation is rejected if hardening destroys the silhouette, a tile misses its footprint, edge pixels do not connect, views change scale or costume, or noise turns into unreadable single-pixel confetti.

## Godot contract

- Keep default texture filtering on Nearest and disable nearest-mipmap filtering for small sprites.
- Choose the scaling model deliberately. `viewport` gives a uniformly low-resolution presentation; `canvas_items` keeps high-resolution UI and effects but needs stricter camera/pixel handling.
- If the game is intended to remain uniformly pixel-perfect, use integer stretch scaling and accept bars at unsupported window sizes.
- Never use lossy source art. Validate imports, camera motion, anchors, seams, and render order in a live Godot run.

The current 1280x720 project uses nearest filtering and pixel snapping. Changing its base resolution or stretch mode is a separate gameplay-and-UI decision, not an automatic art cleanup.

## Sandbox result, 2026-08-21

Four fixed-seed candidates were generated through the unmodified Z-Image Studio API and hardened outside the game repository.

| Test | Native target | Finding | Decision |
|---|---:|---|---|
| Orthographic guardian | 32x48 | Strong silhouette, but facial identity vanished after hardening | Useful concept; redraw face/head before production |
| Isometric guardian | 48x64 | Readable pose, but smooth source contours became uneven clusters | Reject as-is; prompt smaller shapes and hand-clean outline |
| Three-view guardian | 96x48 | Views stayed unusually coherent and readable | Best reference sheet; split and normalize before use |
| Isometric path tile | 64x32 | Source used a square diamond and noisy highlights, not a clean 2:1 footprint | Reject; generate or draw a clean mask first, then texture within it |

## Source ranking

1. [GDQuest: Pixel art setup in Godot 4](https://www.gdquest.com/library/pixel_art_setup_godot4/) - strongest practical engine guidance on filtering, base resolution, scaling modes, and integer scaling.
2. [Godot: Pixelorama showcase](https://godotengine.org/showcase/pixelorama/) - strongest authoring workflow reference for palettes, layers, animation, isometric grids, tile mode, and deterministic export.
3. [Stable Diffusion character-sheet discussion](https://www.reddit.com/r/StableDiffusion/comments/1hxjbld/pixel_art_character_sheets_prompts_included/) - useful prompt patterns plus the most important warning: apparent pixel art and multi-view consistency still need strict downstream validation.
4. [Doing pixel-perfect in Godot](https://medium.com/codex/doing-pixel-perfect-in-godot-the-right-way-77cd39f8f23d) - concise supporting advice on Nearest filtering and viewport/keep scaling; largely overlaps stronger sources. The publisher blocked full-page retrieval, so only indexed content informed this document.
5. [OpenArt prompt examples](https://openart.ai/blog/post/midjourney-prompts-for-pixel-art) - useful for concise visual keywords, perspective, palette mood, and negatives; too generic for production contracts.
6. [ChatGPT influencer-style discussion](https://www.reddit.com/r/ChatGPT/comments/1m72r1u/what_prompt_are_influencers_using_to_make_these/) - useful mainly as a caution against assuming polished human art came from one prompt; limited-color and hard-edge resizing comments support the hardening gate.
7. [Civitai pixel-art guide](https://civitai.com/articles/8444/the-ultimate-guide-parameters-and-prompts-for-pixel-art-in-ai) - not incorporated because the page was blocked by the browsing safety layer. Reassess only from a user-provided export or an approved accessible copy.

Official Godot documentation was used to verify the engine claims: [multiple resolutions](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html) and [image importing](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_images.html).
