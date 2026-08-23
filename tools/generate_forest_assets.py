"""Generate original native-grid forest props. Author-time only; Pillow is not a game dependency."""
from pathlib import Path
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1] / "art" / "props"
ROOT.mkdir(parents=True, exist_ok=True)

INK = "#102f36"
DARK = "#17444a"
TEAL = "#21645a"
GREEN = "#37865c"
LIGHT = "#79b85b"
MOSS = "#a4d45d"
BROWN = "#704733"
WOOD = "#9a6138"
AMBER = "#ffc857"


def save(name, size, draw_fn):
    image = Image.new("RGBA", size, (0, 0, 0, 0))
    draw_fn(ImageDraw.Draw(image))
    image.save(ROOT / name)


def tree(d):
    d.polygon([(29, 92), (35, 92), (38, 55), (26, 55)], fill=INK)
    d.rectangle((29, 52, 34, 91), fill=BROWN)
    d.rectangle((30, 55, 32, 88), fill=WOOD)
    d.polygon([(6, 58), (19, 43), (13, 43), (27, 27), (22, 27), (32, 6),
               (42, 27), (37, 27), (51, 43), (45, 43), (58, 58)], fill=INK)
    d.polygon([(9, 56), (22, 42), (17, 42), (29, 27), (25, 27), (32, 10),
               (39, 27), (35, 27), (48, 42), (42, 42), (55, 56)], fill=DARK)
    d.polygon([(14, 52), (26, 39), (22, 39), (32, 26), (42, 41), (38, 41), (50, 52)], fill=TEAL)
    d.polygon([(20, 36), (31, 14), (38, 32), (33, 30), (42, 43), (30, 38)], fill=GREEN)
    d.polygon([(26, 23), (32, 11), (34, 26), (39, 34), (31, 31)], fill=LIGHT)
    d.rectangle((28, 60, 36, 62), fill=BROWN)
    d.rectangle((27, 63, 29, 66), fill=AMBER)
    d.rectangle((35, 63, 37, 66), fill=AMBER)
    d.polygon([(20, 93), (29, 89), (39, 90), (45, 94), (38, 96), (25, 96)], fill=DARK)


def rock(d):
    d.polygon([(6, 26), (11, 13), (23, 6), (37, 8), (45, 17), (43, 27), (34, 32), (15, 31)], fill=INK)
    d.polygon([(9, 24), (14, 14), (24, 9), (36, 11), (42, 18), (39, 25), (31, 29), (16, 28)], fill=DARK)
    d.polygon([(14, 15), (25, 9), (34, 12), (29, 17), (17, 20)], fill="#42666a")
    d.polygon([(12, 13), (24, 8), (31, 10), (24, 13), (17, 17)], fill=GREEN)
    d.rectangle((10, 16, 15, 18), fill=LIGHT)
    d.rectangle((16, 13, 21, 15), fill=MOSS)
    d.rectangle((35, 21, 40, 24), fill="#285258")


def stump(d):
    d.polygon([(12, 37), (16, 18), (32, 16), (37, 37), (31, 44), (18, 44)], fill=INK)
    d.polygon([(15, 35), (18, 20), (30, 19), (34, 36), (29, 41), (19, 41)], fill=BROWN)
    d.ellipse((16, 13, 32, 24), fill=INK)
    d.ellipse((18, 15, 30, 22), fill=WOOD)
    d.rectangle((21, 17, 27, 19), fill=BROWN)
    d.rectangle((22, 18, 26, 19), fill=INK)
    d.rectangle((27, 8, 39, 25), fill=INK)
    d.rectangle((29, 10, 37, 23), fill=BROWN)
    d.rectangle((30, 13, 36, 20), fill=AMBER)
    d.rectangle((32, 14, 35, 18), fill="#fff09a")
    d.rectangle((30, 7, 36, 9), fill=TEAL)
    d.rectangle((29, 23, 38, 25), fill=TEAL)
    d.rectangle((14, 30, 20, 33), fill=GREEN)
    d.rectangle((12, 33, 17, 35), fill=MOSS)


save("sacred_pine.png", (64, 98), tree)
save("moss_boulder.png", (48, 34), rock)
save("lantern_stump.png", (48, 48), stump)
print("generated sacred_pine.png, moss_boulder.png, lantern_stump.png")
