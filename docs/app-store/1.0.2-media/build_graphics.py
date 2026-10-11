"""Lay out verified native captures without generating or changing app UI.

ReportLab preserves an editable vector composition. PyMuPDF exports RGB PNGs
without alpha, matching App Store Connect's screenshot requirements.
"""
from pathlib import Path
import hashlib
import json
import fitz
from PIL import Image
from reportlab.pdfgen import canvas
from reportlab.lib.colors import HexColor

ROOT = Path(__file__).resolve().parent
CARDS = [
    ('01-pace', 'Your pace.', 'In either unit.', 'Convert min/km and min/mi.', 'PACE'),
    ('02-distance', 'Kilometers.', 'Miles. Sorted.', 'Convert a distance or a range.', 'DISTANCE'),
    ('03-time', 'Set your time.', 'Find your race pace.', 'Hours, minutes and seconds. No guesswork.', 'RACE TIME'),
    ('04-workout', 'Keep the workout.', 'Change the units.', 'Convert a run with a pace or pace range.', 'WORKOUT'),
    ('05-intervals', 'Work. Recover.', 'Repeat.', 'Build distance, time or open interval steps.', 'INTERVALS'),
]

def draw_text(c, text, x, y, size, color='#ffffff', bold=False):
    c.setFillColor(HexColor(color))
    c.setFont('Helvetica-Bold' if bold else 'Helvetica', size)
    assert c.stringWidth(text, c._fontname, size) <= 1062
    c.drawString(x, y, text)

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def build():
    records = []
    for theme in ['light', 'dark']:
        for slug, line1, line2, subtitle, label in CARDS:
            source = ROOT/'native'/theme/(slug+'.png')
            im = Image.open(source)
            assert im.size == (1206, 2622), (source, im.size)
            out = ROOT/'screenshots'/f'{slug}-{theme}.png'
            pdf = ROOT/'editable'/f'{slug}-{theme}.pdf'
            out.parent.mkdir(exist_ok=True)
            pdf.parent.mkdir(exist_ok=True)
            c = canvas.Canvas(str(pdf), pagesize=(1206, 2622))
            c.setFillColor(HexColor('#06162e'))
            c.rect(0, 0, 1206, 2622, fill=1, stroke=0)
            c.setLineWidth(3)
            for n, color in enumerate(['#092650', '#0b3263', '#0b3f77', '#0b4c8b']):
                c.setStrokeColor(HexColor(color))
                p = c.beginPath()
                p.moveTo(-120, 210 - 55*n)
                p.curveTo(300, 820, 780, -100, 1400, 570 - 55*n)
                c.drawPath(p)
            draw_text(c, 'RunConvert', 72, 2500, 34, '#78ddff', True)
            draw_text(c, line1, 72, 2378, 68, bold=True)
            draw_text(c, line2, 72, 2294, 68, bold=True)
            draw_text(c, subtitle, 72, 2215, 29, '#bfd2ec')
            # Fit the complete native screen, including navigation and tab bar.
            width = 844
            height = width*im.height/im.width
            x, y = (1206-width)/2, 260
            c.setFillColor(HexColor('#17253b'))
            c.roundRect(x-12, y-12, width+24, height+24, 56, fill=1, stroke=0)
            c.saveState()
            clip = c.beginPath()
            clip.roundRect(x, y, width, height, 48)
            c.clipPath(clip, stroke=0)
            c.drawImage(str(source), x, y, width=width, height=height)
            c.restoreState()
            draw_text(c, label, 72, 110, 24, '#78ddff', True)
            draw_text(c, 'OFFLINE · NO ACCOUNT', 660, 110, 24, '#bfd2ec')
            c.showPage()
            c.save()
            with fitz.open(pdf) as document:
                document[0].get_pixmap(alpha=False).save(out)
            rendered = Image.open(out)
            assert rendered.size == (1206, 2622) and rendered.mode == 'RGB'
            records.append({'file':str(out.relative_to(ROOT)), 'theme':theme,
                'source':str(source.relative_to(ROOT)), 'source_sha256':sha(source),
                'sha256':sha(out), 'dimensions':[1206,2622], 'mode':'RGB',
                'title':line1+' '+line2, 'capture':'Actual 1.0.2 Simulator UI; asserted results',
                'app_ui_generated':False})
    (ROOT/'asset-manifest.json').write_text(json.dumps({'version':'1.0.2',
        'build':'3','date':'2026-10-11','assets':records},indent=2)+'\n')
    print('Exported 10 screenshots with unchanged native UI, 1206 x 2622, RGB.')

if __name__ == '__main__':
    build()
