"""Generates the event illustrations used by the app (original artwork)."""
import math
import random
import sys
from PIL import Image, ImageDraw, ImageFilter

W, H = 1200, 800
OUT = sys.argv[1]


def gradient(c1, c2, diagonal=True):
    img = Image.new("RGB", (W, H))
    px = img.load()
    for y in range(H):
        for x in range(W):
            t = ((x / W) * 0.5 + (y / H) * 0.5) if diagonal else y / H
            px[x, y] = tuple(int(c1[i] + (c2[i] - c1[i]) * t) for i in range(3))
    return img


def overlay(img):
    return Image.new("RGBA", img.size, (0, 0, 0, 0))


def merge(img, layer, blur=0):
    if blur:
        layer = layer.filter(ImageFilter.GaussianBlur(blur))
    return Image.alpha_composite(img.convert("RGBA"), layer).convert("RGB")


def save(img, name):
    img.save(f"{OUT}/{name}", quality=86, optimize=True)


# 1. Flutter workshop: phone with layered UI blocks
def workshop():
    img = gradient((20, 60, 130), (40, 170, 220))
    lay = overlay(img); d = ImageDraw.Draw(lay)
    for i in range(14):
        x = random.randint(0, W); y = random.randint(0, H); r = random.randint(30, 120)
        d.ellipse([x - r, y - r, x + r, y + r], fill=(255, 255, 255, 18))
    img = merge(img, lay, blur=6)
    lay = overlay(img); d = ImageDraw.Draw(lay)
    d.rounded_rectangle([470, 120, 730, 680], 40, fill=(15, 30, 60, 255))
    d.rounded_rectangle([488, 150, 712, 650], 24, fill=(240, 248, 255, 255))
    d.rounded_rectangle([505, 170, 695, 260], 14, fill=(66, 165, 245, 255))
    for k in range(4):
        y = 280 + k * 88
        d.rounded_rectangle([505, y, 560, y + 66], 12, fill=(129, 212, 250, 255))
        d.rounded_rectangle([572, y + 8, 695, y + 26], 8, fill=(144, 164, 174, 255))
        d.rounded_rectangle([572, y + 38, 660, y + 54], 8, fill=(207, 216, 220, 255))
    # gear next to the phone
    gx, gy = 930, 400
    for a in range(0, 360, 45):
        r = math.radians(a)
        d.line([(gx, gy), (gx + 150 * math.cos(r), gy + 150 * math.sin(r))], fill=(255, 255, 255, 230), width=56)
    d.ellipse([gx - 120, gy - 120, gx + 120, gy + 120], fill=(255, 255, 255, 230))
    d.ellipse([gx - 50, gy - 50, gx + 50, gy + 50], fill=(30, 110, 180, 255))
    d.text((180, 330), "{ }", fill=(255, 255, 255, 220), font_size=150)
    return merge(img, lay)


# 2. AI & computer vision: eye made of neural network nodes
def ai_talk():
    img = gradient((30, 10, 60), (90, 30, 140))
    lay = overlay(img); d = ImageDraw.Draw(lay)
    random.seed(2)
    nodes = [(random.randint(40, W - 40), random.randint(40, H - 40)) for _ in range(60)]
    for a in nodes:
        for b in nodes:
            if a < b and math.dist(a, b) < 170:
                d.line([a, b], fill=(186, 104, 200, 90), width=2)
    for x, y in nodes:
        d.ellipse([x - 5, y - 5, x + 5, y + 5], fill=(225, 190, 231, 200))
    img = merge(img, lay)
    lay = overlay(img); d = ImageDraw.Draw(lay)
    cx, cy = W // 2, H // 2
    d.ellipse([cx - 330, cy - 160, cx + 330, cy + 160], fill=(255, 255, 255, 235))
    d.ellipse([cx - 140, cy - 140, cx + 140, cy + 140], fill=(0, 188, 212, 255))
    d.ellipse([cx - 70, cy - 70, cx + 70, cy + 70], fill=(10, 10, 30, 255))
    d.ellipse([cx + 20, cy - 60, cx + 55, cy - 25], fill=(255, 255, 255, 255))
    for k in range(3):
        o = 40 + k * 30
        d.line([cx - 330 - o, cy - 200 - o, cx - 330 - o, cy - 120 - o], fill=(0, 229, 255, 200), width=8)
        d.line([cx - 330 - o, cy - 200 - o, cx - 250 - o, cy - 200 - o], fill=(0, 229, 255, 200), width=8)
    d.line([cx + 380, cy + 200, cx + 380, cy + 120], fill=(0, 229, 255, 200), width=8)
    d.line([cx + 380, cy + 200, cx + 300, cy + 200], fill=(0, 229, 255, 200), width=8)
    return merge(img, lay)


# 3. Hackathon: code brackets and clock
def hackathon():
    img = gradient((10, 25, 20), (20, 80, 60))
    lay = overlay(img); d = ImageDraw.Draw(lay)
    random.seed(3)
    for col in range(0, W, 40):
        for row in range(0, H, 34):
            if random.random() < 0.35:
                w = random.randint(10, 30)
                d.rectangle([col, row, col + w, row + 8], fill=(105, 240, 174, random.randint(20, 70)))
    img = merge(img, lay)
    lay = overlay(img); d = ImageDraw.Draw(lay)
    g = (105, 240, 174, 255)
    d.line([(330, 250), (180, 400), (330, 550)], fill=g, width=46, joint="curve")
    d.line([(870, 250), (1020, 400), (870, 550)], fill=g, width=46, joint="curve")
    d.line([(660, 220), (540, 580)], fill=(255, 255, 255, 255), width=46)
    cx, cy = 980, 160
    d.ellipse([cx - 90, cy - 90, cx + 90, cy + 90], outline=(255, 213, 79, 255), width=14)
    d.line([cx, cy, cx, cy - 55], fill=(255, 213, 79, 255), width=12)
    d.line([cx, cy, cx + 45, cy + 20], fill=(255, 213, 79, 255), width=12)
    return merge(img, lay)


# 4. Watercolor evening: soft paint blobs and brush
def watercolor():
    img = gradient((255, 248, 240), (250, 235, 225))
    random.seed(4)
    colors = [(239, 83, 80), (255, 167, 38), (66, 165, 245), (171, 71, 188), (102, 187, 106), (255, 238, 88)]
    for c in colors * 2:
        lay = overlay(img); d = ImageDraw.Draw(lay)
        x = random.randint(100, W - 100); y = random.randint(100, H - 100); r = random.randint(70, 190)
        d.ellipse([x - r, y - r * 0.8, x + r, y + r * 0.8], fill=c + (110,))
        img = merge(img, lay, blur=6)
    lay = overlay(img); d = ImageDraw.Draw(lay)
    d.line([(300, 700), (820, 180)], fill=(121, 85, 72, 255), width=26)
    d.line([(820, 180), (900, 100)], fill=(189, 189, 189, 255), width=34)
    d.ellipse([870, 50, 960, 140], fill=(55, 71, 79, 255))
    return merge(img, lay)


# 5. Jazz night: saxophone-ish curve, notes, spotlights
def jazz():
    img = gradient((25, 10, 5), (110, 40, 10))
    lay = overlay(img); d = ImageDraw.Draw(lay)
    d.polygon([(200, 0), (330, 0), (600, H), (0, H)], fill=(255, 224, 130, 45))
    d.polygon([(870, 0), (1000, 0), (1200, H), (600, H)], fill=(255, 224, 130, 45))
    img = merge(img, lay, blur=12)
    lay = overlay(img); d = ImageDraw.Draw(lay)
    gold = (255, 193, 7, 255)
    kx0, ky0, kw = 160, 560, 70
    for i in range(13):
        d.rectangle([kx0 + i * kw, ky0, kx0 + i * kw + kw - 6, ky0 + 200], fill=(250, 245, 235, 255))
    for i in [0, 1, 3, 4, 5, 7, 8, 10, 11]:
        x = kx0 + i * kw + kw * 0.65
        d.rectangle([x, ky0, x + kw * 0.6, ky0 + 120], fill=(20, 15, 10, 255))
    d.rounded_rectangle([530, 120, 670, 340], 70, fill=gold)
    for gy in range(160, 320, 30):
        d.line([(550, gy), (650, gy)], fill=(120, 80, 0, 255), width=6)
    d.arc([490, 230, 710, 420], 0, 180, fill=gold, width=14)
    d.line([(600, 420), (600, 470)], fill=gold, width=18)
    d.line([(520, 470), (680, 470)], fill=gold, width=18)
    for k, (x, y) in enumerate([(230, 260), (330, 200), (900, 520), (1000, 450)]):
        d.ellipse([x - 32, y - 24, x + 32, y + 24], fill=(255, 255, 255, 235))
        d.line([(x + 28, y), (x + 28, y - 120)], fill=(255, 255, 255, 235), width=10)
        if k % 2 == 0:
            d.line([(x + 28, y - 120), (x + 128, y - 150)], fill=(255, 255, 255, 235), width=14)
    return merge(img, lay)


# 6. 5K run: running track lanes with finish line
def run5k():
    img = gradient((191, 54, 12), (255, 112, 67))
    lay = overlay(img); d = ImageDraw.Draw(lay)
    for k in range(6):
        o = k * 70
        d.arc([-300 + o, 300 + o, 1500 - o, 1500 - o], 180, 360, fill=(255, 255, 255, 200), width=8)
    for i in range(10):
        for j in range(2):
            if (i + j) % 2 == 0:
                d.rectangle([560 + j * 40, 300 + i * 40, 600 + j * 40, 340 + i * 40], fill=(255, 255, 255, 230))
            else:
                d.rectangle([560 + j * 40, 300 + i * 40, 600 + j * 40, 340 + i * 40], fill=(33, 33, 33, 230))
    d.ellipse([140, 90, 300, 250], fill=(255, 241, 118, 240))
    return merge(img, lay)


# 7. Basketball 3x3: ball over court lines
def basketball():
    img = gradient((13, 40, 90), (25, 90, 160))
    lay = overlay(img); d = ImageDraw.Draw(lay)
    d.rectangle([60, 60, W - 60, H - 60], outline=(255, 255, 255, 120), width=8)
    d.line([(W // 2, 60), (W // 2, H - 60)], fill=(255, 255, 255, 120), width=8)
    d.arc([-200, 140, 400, 660], 270, 90, fill=(255, 255, 255, 120), width=8)
    d.arc([800, 140, 1400, 660], 90, 270, fill=(255, 255, 255, 120), width=8)
    img = merge(img, lay)
    lay = overlay(img); d = ImageDraw.Draw(lay)
    cx, cy, r = W // 2, H // 2, 230
    d.ellipse([cx - r + 18, cy - r + 24, cx + r + 18, cy + r + 24], fill=(0, 0, 0, 90))
    d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=(245, 124, 0, 255))
    blk = (40, 20, 10, 255)
    d.line([(cx, cy - r), (cx, cy + r)], fill=blk, width=12)
    d.line([(cx - r, cy), (cx + r, cy)], fill=blk, width=12)
    d.arc([cx - r - 150, cy - r, cx - 60, cy + r], 300, 60, fill=blk, width=12)
    d.arc([cx + 60, cy - r, cx + r + 150, cy + r], 120, 240, fill=blk, width=12)
    return merge(img, lay)


# 8. Board game night: dice and meeples
def board_games():
    img = gradient((0, 77, 64), (0, 150, 136))
    lay = overlay(img); d = ImageDraw.Draw(lay)
    for i in range(0, W, 100):
        for j in range(0, H, 100):
            if (i // 100 + j // 100) % 2 == 0:
                d.rectangle([i, j, i + 100, j + 100], fill=(255, 255, 255, 18))
    img = merge(img, lay)
    lay = overlay(img); d = ImageDraw.Draw(lay)

    def die(x, y, s, pips):
        d.rounded_rectangle([x + 12, y + 16, x + s + 12, y + s + 16], 36, fill=(0, 0, 0, 80))
        d.rounded_rectangle([x, y, x + s, y + s], 36, fill=(255, 255, 255, 255))
        for px, py in pips:
            cx, cy = x + px * s, y + py * s
            d.ellipse([cx - 20, cy - 20, cx + 20, cy + 20], fill=(38, 50, 56, 255))

    die(300, 260, 260, [(0.25, 0.25), (0.75, 0.75), (0.5, 0.5), (0.25, 0.75), (0.75, 0.25)])
    die(640, 330, 220, [(0.3, 0.3), (0.7, 0.7)])
    for x, c in [(180, (255, 82, 82)), (960, (255, 235, 59)), (1040, (124, 77, 255))]:
        d.ellipse([x - 40, 520, x + 40, 600], fill=c + (255,))
        d.polygon([(x - 70, 720), (x + 70, 720), (x + 40, 590), (x - 40, 590)], fill=c + (255,))
    return merge(img, lay)


# Game programming workshop: gamepad with pixel sprites
def game_workshop():
    img = gradient((26, 35, 126), (106, 27, 154))
    lay = overlay(img); d = ImageDraw.Draw(lay)
    random.seed(11)
    for _ in range(40):
        x = random.randrange(0, W, 20); y = random.randrange(0, H, 20)
        d.rectangle([x, y, x + 18, y + 18], fill=(255, 255, 255, random.randint(15, 45)))
    img = merge(img, lay)
    lay = overlay(img); d = ImageDraw.Draw(lay)
    body = (236, 239, 241, 255)
    d.ellipse([260, 300, 520, 640], fill=body)
    d.ellipse([680, 300, 940, 640], fill=body)
    d.rounded_rectangle([360, 290, 840, 540], 120, fill=body)
    dk = (55, 71, 79, 255)
    d.rectangle([340, 400, 460, 440], fill=dk)
    d.rectangle([380, 360, 420, 480], fill=dk)
    for (x, y, c) in [(780, 360, (239, 83, 80)), (840, 420, (66, 165, 245)), (720, 420, (102, 187, 106)), (780, 480, (255, 202, 40))]:
        d.ellipse([x - 26, y - 26, x + 26, y + 26], fill=c + (255,))
    d.rounded_rectangle([550, 400, 590, 420], 8, fill=dk)
    d.rounded_rectangle([610, 400, 650, 420], 8, fill=dk)
    # pixel heart sprite
    sprite = [".XX...XX.", "XXXX.XXXX", "XXXXXXXXX", "XXXXXXXXX", ".XXXXXXX.", "..XXXXX..", "...XXX...", "....X...."]
    for r, row in enumerate(sprite):
        for c, ch in enumerate(row):
            if ch == "X":
                d.rectangle([500 + c * 22, 70 + r * 22, 520 + c * 22, 90 + r * 22], fill=(255, 82, 82, 255))
    return merge(img, lay)


# Campus bike race: bicycle on a road with speed lines
def bike_race():
    img = gradient((0, 105, 92), (128, 203, 196))
    lay = overlay(img); d = ImageDraw.Draw(lay)
    d.polygon([(0, 620), (W, 560), (W, H), (0, H)], fill=(55, 71, 79, 255))
    for x in range(40, W, 180):
        d.polygon([(x, 690 - x * 0.05), (x + 100, 685 - x * 0.05), (x + 100, 697 - x * 0.05), (x, 702 - x * 0.05)], fill=(255, 235, 59, 255))
    for k in range(5):
        y = 230 + k * 55
        d.line([(60, y), (60 + 140 + k * 30, y)], fill=(255, 255, 255, 150), width=10)
    d.ellipse([920, 70, 1060, 210], fill=(255, 241, 118, 230))
    c = (255, 87, 34, 255); w = 18
    rear, front, r = (430, 470), (790, 470), 120
    for (cx, cy) in (rear, front):
        d.ellipse([cx - r, cy - r, cx + r, cy + r], outline=(33, 33, 33, 255), width=22)
        for a in range(0, 180, 30):
            rr = math.radians(a)
            d.line([(cx - (r - 10) * math.cos(rr), cy - (r - 10) * math.sin(rr)), (cx + (r - 10) * math.cos(rr), cy + (r - 10) * math.sin(rr))], fill=(120, 120, 120, 200), width=4)
    crank = (580, 470); seat = (530, 300); head = (740, 290)
    d.line([rear, crank], fill=c, width=w); d.line([rear, seat], fill=c, width=w)
    d.line([seat, crank], fill=c, width=w); d.line([seat, head], fill=c, width=w)
    d.line([head, crank], fill=c, width=w); d.line([head, front], fill=c, width=w)
    d.line([(510, 270), (580, 270)], fill=(33, 33, 33, 255), width=20)
    d.line([head, (760, 240)], fill=c, width=w)
    d.line([(730, 235), (810, 235)], fill=(33, 33, 33, 255), width=16)
    d.ellipse([crank[0] - 26, crank[1] - 26, crank[0] + 26, crank[1] + 26], fill=(33, 33, 33, 255))
    return merge(img, lay)


# Kite flying day: colorful kites with tails over a field
def kite_day():
    img = gradient((79, 195, 247), (225, 245, 254), diagonal=False)
    lay = overlay(img); d = ImageDraw.Draw(lay)
    for (x, y, s) in [(140, 120, 1.0), (980, 180, 0.8), (600, 70, 0.6)]:
        for dx, dy, rr in [(0, 0, 50), (55, -20, 60), (115, 0, 48)]:
            d.ellipse([x + dx * s - rr * s, y + dy * s - rr * s, x + dx * s + rr * s, y + dy * s + rr * s], fill=(255, 255, 255, 230))
    d.ellipse([-300, 600, 800, 1200], fill=(124, 179, 66, 255))
    d.ellipse([400, 640, 1500, 1250], fill=(104, 159, 56, 255))
    img = merge(img, lay)
    lay = overlay(img); d = ImageDraw.Draw(lay)

    def kite(cx, cy, s, c1, c2, tail):
        top, right, bottom, left = (cx, cy - 110 * s), (cx + 80 * s, cy - 10 * s), (cx, cy + 150 * s), (cx - 80 * s, cy - 10 * s)
        center = (cx, cy - 10 * s)
        d.polygon([top, right, center], fill=c1 + (255,))
        d.polygon([top, left, center], fill=c2 + (255,))
        d.polygon([bottom, right, center], fill=c2 + (255,))
        d.polygon([bottom, left, center], fill=c1 + (255,))
        d.line([top, bottom], fill=(62, 39, 35, 255), width=4)
        d.line([left, right], fill=(62, 39, 35, 255), width=4)
        pts = [bottom]
        for i in range(1, 9):
            pts.append((cx + math.sin(i * 0.9) * 30 * s, bottom[1] + i * 28 * s))
        d.line(pts, fill=(62, 39, 35, 255), width=3, joint="curve")
        for i in range(2, 9, 2):
            x, y = pts[i]
            d.polygon([(x - 14 * s, y - 8 * s), (x + 14 * s, y + 8 * s), (x + 14 * s, y - 8 * s), (x - 14 * s, y + 8 * s)], fill=tail + (255,))
        return bottom

    b1 = kite(420, 260, 1.15, (244, 67, 54), (255, 193, 7), (33, 150, 243))
    b2 = kite(800, 330, 0.9, (156, 39, 176), (0, 188, 212), (255, 87, 34))
    kite(1030, 470, 0.55, (76, 175, 80), (255, 235, 59), (233, 30, 99))
    d.line([(420, 300), (560, 760)], fill=(255, 255, 255, 180), width=2)
    d.line([(800, 320), (600, 760)], fill=(255, 255, 255, 180), width=2)
    return merge(img, lay)


random.seed(1)
for fn, name in [
    (game_workshop, "game_workshop.jpg"), (ai_talk, "ai_vision_talk.jpg"),
    (hackathon, "hackathon.jpg"), (jazz, "jazz_night.jpg"),
    (bike_race, "bike_race.jpg"), (basketball, "basketball.jpg"),
    (kite_day, "kite_day.jpg"),
]:
    save(fn(), name)
    print("ok", name)
