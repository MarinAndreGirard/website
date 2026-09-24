#!/usr/bin/env python3
"""Build responsive display copies. Never write to original photo files."""
import hashlib
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
WIDTHS = (640, 1280, 1920)
RECIPE = 'webp-q88-v1'
manifest_path = ROOT / 'assets/photo-previews/manifest.json'
previous = json.loads(manifest_path.read_text()) if manifest_path.exists() else {}
manifest = {}
for post in sorted((ROOT / 'posts').glob('*/index.qmd')):
    text = post.read_text()
    if 'body-classes: photo-essay' not in text:
        continue
    for relative in sorted(set(re.findall(r'!\[[^\]]*\]\((images/[^)]+)\)', text))):
        original = post.parent / relative
        key = original.relative_to(ROOT).as_posix()
        digest = hashlib.sha256(original.read_bytes()).hexdigest()
        old = previous.get(key)
        if old and old['sha256'] == digest and old.get('recipe') == RECIPE and all((ROOT / v['src']).is_file() for v in old['variants']):
            manifest[key] = old
            continue
        try:
            from PIL import Image, ImageOps
        except ImportError:
            raise SystemExit('New photos need Pillow. Install it with: python3 -m pip install -r requirements-photos.txt\nExisting generated photos can be rendered without Pillow.')
        out_dir = ROOT / 'assets/photo-previews' / post.parent.name
        out_dir.mkdir(parents=True, exist_ok=True)
        with Image.open(original) as source:
            # Match browser orientation; preserve the embedded color profile.
            oriented = ImageOps.exif_transpose(source)
            width, height = oriented.size
            profile = source.info.get('icc_profile')
            image = oriented.convert('RGB')
            variants = []
            for target in sorted({min(width, w) for w in WIDTHS}):
                resized = image.resize((target, round(height * target / width)), Image.Resampling.LANCZOS)
                dest = out_dir / f'{original.stem}-{digest[:12]}-{target}.webp'
                options = {'quality': 88, 'method': 6}
                if profile:
                    options['icc_profile'] = profile
                resized.save(dest, 'WEBP', **options)
                variants.append({'src': dest.relative_to(ROOT).as_posix(), 'width': target})
        manifest[key] = {'width': width, 'height': height, 'sha256': digest, 'recipe': RECIPE, 'variants': variants}
manifest_path.parent.mkdir(parents=True, exist_ok=True)
content = json.dumps(manifest, indent=2, sort_keys=True) + '\n'
if not manifest_path.exists() or manifest_path.read_text() != content:
    manifest_path.write_text(content)
print(f'Responsive photos ready: {len(manifest)} originals preserved.')
