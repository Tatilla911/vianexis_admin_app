#!/usr/bin/env python3
"""Generate ViaNexis Admin branding PNG assets."""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "assets" / "branding"
NAVY = (13, 27, 42)
BLUE = (79, 163, 227)
GOLD = (212, 175, 55)


def gradient(size: tuple[int, int], c1: tuple[int, int, int], c2: tuple[int, int, int]) -> Image.Image:
    img = Image.new("RGBA", size)
    px = img.load()
    for y in range(size[1]):
        for x in range(size[0]):
            t = (x / max(size[0] - 1, 1) * 0.35) + (y / max(size[1] - 1, 1) * 0.65)
            t = min(max(t, 0.0), 1.0)
            px[x, y] = (
                int(c1[0] + (c2[0] - c1[0]) * t),
                int(c1[1] + (c2[1] - c1[1]) * t),
                int(c1[2] + (c2[2] - c1[2]) * t),
                255,
            )
    return img


def _font(size: int) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    try:
        return ImageFont.truetype("arial.ttf", size)
    except OSError:
        return ImageFont.load_default()


def draw_vn(draw: ImageDraw.ImageDraw, box: tuple[int, int, int, int], *, gold: bool = False) -> None:
    fill = BLUE + (220,) if not gold else GOLD + (230,)
    draw.rounded_rectangle(box, radius=int(min(box[2] - box[0], box[3] - box[1]) * 0.18), fill=fill)
    font = _font(int((box[3] - box[1]) * 0.42))
    text = "VN"
    bbox = draw.textbbox((0, 0), text, font=font)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    draw.text(((box[0] + box[2] - tw) // 2, (box[1] + box[3] - th) // 2 - 2), text, fill=(255, 255, 255, 255), font=font)


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)

    mark = gradient((256, 256), NAVY, (30, 96, 145))
    d = ImageDraw.Draw(mark)
    draw_vn(d, (64, 64, 192, 192))
    mark.save(OUT / "vianexis_mark.png")

    logo = gradient((512, 160), NAVY, (30, 96, 145))
    d = ImageDraw.Draw(logo)
    draw_vn(d, (24, 24, 120, 136))
    font = _font(44)
    d.text((140, 52), "ViaNexis", fill=(244, 247, 251, 255), font=font)
    d.text((140, 98), "Admin", fill=GOLD + (255,), font=font)
    logo.save(OUT / "vianexis_logo.png")

    watermark = Image.new("RGBA", (640, 640), (0, 0, 0, 0))
    d = ImageDraw.Draw(watermark)
    d.rounded_rectangle((170, 170, 470, 470), radius=54, fill=BLUE + (28,))
    d.text((250, 250), "VN", fill=(255, 255, 255, 22), font=_font(160))
    watermark.save(OUT / "vianexis_watermark.png")

    print("Generated branding assets in", OUT)


if __name__ == "__main__":
    main()
