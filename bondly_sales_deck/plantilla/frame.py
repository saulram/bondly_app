from PIL import Image, ImageDraw, ImageFilter
import os
os.makedirs('assets/dev', exist_ok=True)

CROP_TOP = 122          # remove status bar + DEBUG ribbon
R_SCREEN = 74           # screen corner radius
BEZEL    = 26           # phone bezel thickness
PAD      = 150          # glow/shadow padding
GLOW     = (124, 92, 252)   # brand purple #7C5CFC

def rounded_mask(size, radius):
    m = Image.new('L', size, 0)
    d = ImageDraw.Draw(m)
    d.rounded_rectangle([0,0,size[0]-1,size[1]-1], radius=radius, fill=255)
    return m

def make_device(src, out):
    im = Image.open(src).convert('RGB')
    w,h = im.size
    screen = im.crop((0, CROP_TOP, w, h))          # 1080 x (2400-122)
    sw, sh = screen.size
    # round screen corners
    smask = rounded_mask((sw,sh), R_SCREEN)
    screen_rgba = screen.convert('RGBA'); screen_rgba.putalpha(smask)
    # device body (near-black bezel)
    dw, dh = sw+2*BEZEL, sh+2*BEZEL
    R_DEV = R_SCREEN + BEZEL
    device = Image.new('RGBA',(dw,dh),(0,0,0,0))
    dd = ImageDraw.Draw(device)
    dd.rounded_rectangle([0,0,dw-1,dh-1], radius=R_DEV, fill=(8,8,11,255))
    device.paste(screen_rgba,(BEZEL,BEZEL),screen_rgba)
    # subtle metallic edge
    dd.rounded_rectangle([0,0,dw-1,dh-1], radius=R_DEV, outline=(70,70,88,255), width=3)
    # canvas with glow + shadow
    cw, ch = dw+2*PAD, dh+2*PAD
    canvas = Image.new('RGBA',(cw,ch),(0,0,0,0))
    # purple glow
    glow = Image.new('RGBA',(cw,ch),(0,0,0,0))
    gd = ImageDraw.Draw(glow)
    gd.rounded_rectangle([PAD-30,PAD-10,PAD+dw+30,PAD+dh+10], radius=R_DEV+30, fill=GLOW+(115,))
    glow = glow.filter(ImageFilter.GaussianBlur(70))
    # dark drop shadow (depth)
    sh_l = Image.new('RGBA',(cw,ch),(0,0,0,0))
    sd = ImageDraw.Draw(sh_l)
    sd.rounded_rectangle([PAD+12,PAD+40,PAD+dw+12,PAD+dh+40], radius=R_DEV, fill=(0,0,0,160))
    sh_l = sh_l.filter(ImageFilter.GaussianBlur(48))
    canvas = Image.alpha_composite(canvas, sh_l)
    canvas = Image.alpha_composite(canvas, glow)
    canvas.paste(device,(PAD,PAD),device)
    canvas.save(out)
    return canvas.size

for f in ['1000048434','1000048435','1000048437','1000048439','1000048440','1000048442','1000048443']:
    sz = make_device(f'assets/raw/{f}.png', f'assets/dev/{f}_dev.png')
    print(f, '->', sz)
