# Pixel-art prompt references and model test

The supplied references are visual vocabulary, not production specifications. They range from filtered pixel-style illustrations to isolated sprites and concept sheets. The most reusable patterns are full-body framing, simple backgrounds, a small number of identity traits, and explicit perspective. The least reusable pieces are named-character triggers, embedded LoRA tokens, contradictory bit-depth labels, and high-resolution quality fluff.

## Reference-image findings

- Images 1, 2, 3, 7, 8, 9, and 10 are portrait or scene concepts. Use them for palette, face, costume, and mood.
- Image 4 has stronger deliberate clusters and a restrained palette, but it is still a close portrait rather than gameplay art.
- Images 5 and 6 are duplicates. They demonstrate pose variety, not a complete idle/walk/run/jump/attack sheet.
- Images 11 and 12 are the best isolated full-body sprite references. Their clear silhouettes, simple backgrounds, and bounded costume detail translate well to atomic prompts.

## Prompt cleanup rules

- Studio applies LoRAs structurally. Remove `<lora:name:weight>` from prompt text.
- Keep only triggers that belong to the selected model and LoRA stack.
- Replace named characters and franchise-style calls with original visual traits for Aegis Shrine.
- Replace ambiguous `1girl` with `adult woman` when age clarity matters.
- Do not combine `16 bit`, `32 bit`, `64 bit`, `high resolution`, `8k`, and `extremely detailed`. Pick one native target and intended use.
- A request for many actions in one sprite sheet is a concept sheet. Production animation requires atomic poses or frames, normalized and packed afterward.

## Controlled Studio test, 2026-08-21

All runs used one original adult shrine-scout design and were submitted through the unmodified Studio API. Outputs were copied into an isolated sandbox.

| Stack | Result | Classification |
|---|---|---|
| Hyphoria v0.02 + Elin 0.9, contract-first | Model followed the silhouette but produced a blank face and circular backdrop | Reject |
| Hyphoria v0.02 + Elin 0.9, tag-heavy | Attractive 3/4 character with sword and scenery; ignored atomic-sprite constraints | Concept/reference |
| RDXL Pixel Art Pony 2 | Cleanest isolated full-body character and best silhouette | Single-sprite source |
| Sprite Shaper + ArsMJ 0.8 | Richest pixel illustration, but added a parchment frame | Concept/reference |
| Hyphoria + Elin three-view request | Produced front/back, palette chips, and two chibis rather than exactly three equal views | Concept sheet |

RDXL with Transparent Asset produced real alpha. It passed a deterministic 48x64, 16-color, binary-alpha hardening check. It still needs manual cleanup because hands, facial detail, and the ground pixels weaken at native size.

## Current routing decision

- Start single character sprites with RDXL.
- Use Hyphoria + Elin for chibi concept exploration and style sheets, with short prompts.
- Use Sprite Shaper + ArsMJ for illustration and mood boards, not final atomic sprites.
- Keep PX64 outside Studio until a separate SD 1.5 workflow is explicitly verified.
