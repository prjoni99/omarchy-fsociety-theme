#!/usr/bin/env python3
"""Render the fsociety HUD art: wallpapers, the lock-screen graphic, nothing else.

Every image is near-black with a faint grid, a lot of empty space, and one
small HUD element low in a corner. Nothing glows, nothing is noisy.

    ./art/render.py            # writes backgrounds/*.jpg and unlock.png
    ./art/render.py --check    # only reports what it would write

Needs Pillow. Colours come from colors.toml so a palette edit re-renders.
"""

import argparse
import re
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent.parent
SIZES = {"4k": (3840, 2160), "qhd": (2560, 1440)}
UNLOCK_SIZE = (640, 530)
JPEG_QUALITY = 92

FONT_CANDIDATES = [
    "/usr/share/fonts/TTF/CaskaydiaMonoNerdFont-Regular.ttf",
    "/usr/share/fonts/TTF/JetBrainsMonoNerdFont-Regular.ttf",
    "/usr/share/fonts/TTF/DejaVuSansMono.ttf",
    "/usr/share/fonts/dejavu/DejaVuSansMono.ttf",
]


def palette():
    colors = {}
    for line in (ROOT / "colors.toml").read_text().splitlines():
        m = re.match(r'^\s*([\w_]+)\s*=\s*"#([0-9a-fA-F]{6})"', line)
        if m:
            colors[m.group(1)] = tuple(int(m.group(2)[i : i + 2], 16) for i in (0, 2, 4))
    return colors


def font(size):
    for path in FONT_CANDIDATES:
        if Path(path).exists():
            return ImageFont.truetype(path, size)
    return ImageFont.load_default()


def mix(a, b, t):
    return tuple(round(a[i] + (b[i] - a[i]) * t) for i in range(3))


# --- primitives ---------------------------------------------------------------


def grid(draw, size, base, step, line):
    """Faint square grid. `line` is the colour, already close to `base`."""
    w, h = size
    for x in range(0, w, step):
        draw.line([(x, 0), (x, h)], fill=line, width=1)
    for y in range(0, h, step):
        draw.line([(0, y), (w, y)], fill=line, width=1)


def brackets(draw, box, color, arm, width, corners=("tl", "br")):
    """Lock-on corners: only the named corners of `box` are drawn."""
    x0, y0, x1, y1 = box
    if "tl" in corners:
        draw.line([(x0, y0 + arm), (x0, y0), (x0 + arm, y0)], fill=color, width=width)
    if "tr" in corners:
        draw.line([(x1 - arm, y0), (x1, y0), (x1, y0 + arm)], fill=color, width=width)
    if "bl" in corners:
        draw.line([(x0, y1 - arm), (x0, y1), (x0 + arm, y1)], fill=color, width=width)
    if "br" in corners:
        draw.line([(x1 - arm, y1), (x1, y1), (x1, y1 - arm)], fill=color, width=width)


def tick(draw, x, y, length, color, width):
    """A single short vertical mark: the one red thing in the frame."""
    draw.line([(x, y), (x, y + length)], fill=color, width=width)


def readout(draw, x, y, text, fnt, color):
    draw.text((x, y), text, font=fnt, fill=color)


# --- compositions -------------------------------------------------------------


def wallpaper_brackets(size, c):
    """A small bracket frame low-left, a red tick beside it. Nothing else."""
    w, h = size
    s = w / 2560
    img = Image.new("RGB", size, c["base"])
    d = ImageDraw.Draw(img)
    grid(d, size, c["base"], int(80 * s), c["grid"])
    box = (int(160 * s), int(h - 300 * s), int(420 * s), int(h - 160 * s))
    brackets(d, box, c["dim"], arm=int(28 * s), width=max(2, int(2 * s)))
    tick(d, int(140 * s), box[1], int(24 * s), c["red"], max(2, int(3 * s)))
    return img


def wallpaper_readout(size, c):
    """One thin horizontal readout line with a caption, low-right."""
    w, h = size
    s = w / 2560
    img = Image.new("RGB", size, c["base"])
    d = ImageDraw.Draw(img)
    grid(d, size, c["base"], int(80 * s), c["grid"])
    y = int(h - 220 * s)
    x0, x1 = int(w - 720 * s), int(w - 180 * s)
    d.line([(x0, y), (x1, y)], fill=c["dim"], width=max(1, int(1 * s)))
    # A few faint hash marks along the line; one lit.
    for i in range(0, 9):
        x = x0 + (x1 - x0) * i // 8
        d.line([(x, y - int(6 * s)), (x, y + int(6 * s))], fill=c["dim"], width=max(1, int(1 * s)))
    tick(d, x0 + (x1 - x0) * 6 // 8, y - int(14 * s), int(28 * s), c["red"], max(2, int(3 * s)))
    readout(d, x0, y + int(18 * s), "fsociety", font(int(18 * s)), c["dim"])
    return img


def wallpaper_crosshatch(size, c):
    """Denser crosshatch fading out, a bracket pair top-right, no red at all."""
    w, h = size
    s = w / 2560
    img = Image.new("RGB", size, c["base"])
    d = ImageDraw.Draw(img)
    step = int(40 * s)
    # Hatch only the bottom band so the top stays clean for windows.
    band_top = int(h * 0.72)
    for x in range(0, w, step):
        d.line([(x, band_top), (x, h)], fill=c["grid"], width=1)
    for y in range(band_top, h, step):
        d.line([(0, y), (w, y)], fill=c["grid"], width=1)
    d.line([(0, band_top), (w, band_top)], fill=c["dim"], width=1)
    box = (int(w - 520 * s), int(h - 260 * s), int(w - 200 * s), int(h - 120 * s))
    brackets(d, box, c["dim"], arm=int(24 * s), width=max(2, int(2 * s)), corners=("tr", "bl"))
    return img


def unlock(c):
    """Lock-screen graphic: brackets around empty space, the one text easter egg."""
    size = UNLOCK_SIZE
    w, h = size
    img = Image.new("RGB", size, c["base"])
    d = ImageDraw.Draw(img)
    grid(d, size, c["base"], 40, c["grid"])
    box = (120, 110, w - 120, h - 190)
    brackets(d, box, c["dim"], arm=36, width=2, corners=("tl", "tr", "bl", "br"))
    tick(d, box[0] + 40, box[3] - 60, 20, c["red"], 3)
    readout(d, 36, h - 48, "hello, friend", font(16), c["dim"])
    return img


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true", help="list outputs, write nothing")
    args = ap.parse_args()

    p = palette()
    c = {
        "base": (5, 6, 7),
        "grid": mix((5, 6, 7), p["lighter_background"], 0.35),
        "dim": p["dark_foreground"],
        "red": p["accent"],
    }

    outputs = []
    for name, fn in (("6-brackets", wallpaper_brackets), ("7-readout", wallpaper_readout), ("8-hatch", wallpaper_crosshatch)):
        for tag, size in SIZES.items():
            outputs.append((ROOT / "backgrounds" / f"{name}-{tag}.jpg", lambda fn=fn, size=size: fn(size, c)))
    outputs.append((ROOT / "unlock.png", lambda: unlock(c)))

    for path, render in outputs:
        print(path.relative_to(ROOT))
        if args.check:
            continue
        img = render()
        if path.suffix == ".jpg":
            img.save(path, quality=JPEG_QUALITY, subsampling=0)
        else:
            img.save(path)
    return 0


if __name__ == "__main__":
    sys.exit(main())
