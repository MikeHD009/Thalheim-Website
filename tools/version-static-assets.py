"""Version image and stylesheet URLs by content before deployment."""

import hashlib
from pathlib import Path
import re
from urllib.parse import unquote, urlsplit, urlunsplit


root = Path(__file__).resolve().parent.parent
document = root / "index.html"


def version_url(match):
    attribute, url = match.groups()
    parts = urlsplit(url)
    if parts.scheme or parts.netloc:
        return match.group(0)
    asset = root / unquote(parts.path).lstrip("/")
    if asset.suffix.lower() not in {".avif", ".png", ".css"}:
        return match.group(0)
    digest = hashlib.sha256(asset.read_bytes()).hexdigest()[:12]
    versioned = urlunsplit(parts._replace(query=f"v={digest}"))
    return f'{attribute}="{versioned}"'


html = document.read_bytes().decode("utf-8")
html = re.sub(r'\b(src|srcset|href)="([^"]+)"', version_url, html)
document.write_bytes(html.encode("utf-8"))
