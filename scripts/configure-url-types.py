"""Declare HTTP(S) handling without selecting any system default handler."""
import plistlib
import sys
path = sys.argv[1]
with open(path, 'rb') as source:
    info = plistlib.load(source)
info['CFBundleURLTypes'] = [{
    'CFBundleURLName': 'dev.local.DesktopToolkit.web',
    'CFBundleTypeRole': 'Viewer',
    'CFBundleURLSchemes': ['http', 'https'],
}]
with open(path, 'wb') as target:
    plistlib.dump(info, target)
