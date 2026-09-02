from PIL import Image, ImageDraw, ImageFilter
import os
os.makedirs('assets/gen', exist_ok=True)

W,H = 2560,1440
def radial(size, cx, cy, rad, color, amax):
    layer = Image.new('RGBA', size, (0,0,0,0))
    d = ImageDraw.Draw(layer)
    d.ellipse([cx-rad, cy-rad, cx+rad, cy+rad], fill=color+(amax,))
    return layer.filter(ImageFilter.GaussianBlur(rad*0.42))

# content dark bg
base = Image.new('RGBA',(W,H),(11,11,15,255))
base = Image.alpha_composite(base, radial((W,H), int(W*0.86), int(H*0.12), 620, (124,58,237), 120))
base = Image.alpha_composite(base, radial((W,H), int(W*0.05), int(H*0.95), 720, (236,72,153), 60))
base.convert('RGB').save('assets/gen/bg_dark.png')

# cover / section bg (more dramatic)
cov = Image.new('RGBA',(W,H),(9,9,13,255))
cov = Image.alpha_composite(cov, radial((W,H), int(W*0.30), int(H*0.78), 900, (124,58,237), 150))
cov = Image.alpha_composite(cov, radial((W,H), int(W*0.72), int(H*0.30), 760, (236,72,153), 120))
cov = Image.alpha_composite(cov, radial((W,H), int(W*0.52), int(H*0.52), 500, (155,127,255), 70))
cov.convert('RGB').save('assets/gen/bg_cover.png')

# diagonal gradient (purple -> pink) for CTA button / gradient cards
gw,gh = 1600,1000
grad = Image.new('RGB',(gw,gh))
c0=(124,58,237); c1=(236,72,153)
px = grad.load()
for y in range(gh):
    for x in range(0,gw,2):
        t=(x/gw*0.6 + y/gh*0.4)
        r=int(c0[0]+(c1[0]-c0[0])*t); g=int(c0[1]+(c1[1]-c0[1])*t); b=int(c0[2]+(c1[2]-c0[2])*t)
        px[x,y]=(r,g,b); 
        if x+1<gw: px[x+1,y]=(r,g,b)
grad.save('assets/gen/grad_diag.png')
print('backgrounds + gradient done')
