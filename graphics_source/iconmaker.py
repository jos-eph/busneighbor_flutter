#!/usr/bin/env python3

import os
import sys
from glob import glob
import subprocess

"""
From Flutter documentation:
    Flutter can load resolution-appropriate images for the current device pixel ratio.

    AssetImage will map a logical requested asset onto one that most closely matches the current device pixel ratio.

    For this mapping to work, assets should be arranged according to a particular directory structure:

    .../image.png
    .../Mx/image.png
    .../Nx/image.png
    ...etc.

. . .
[e.g.]

    .../my_icon.png       (mdpi baseline)
    .../1.5x/my_icon.png  (hdpi)
    .../2.0x/my_icon.png  (xhdpi)
    .../3.0x/my_icon.png  (xxhdpi)
    .../4.0x/my_icon.png  (xxxhdpi)

    Bundling of resolution-aware image assets

    You only need to specify the main asset or its parent directory in the assets section of pubspec.yaml.
    Flutter bundles the variants for you. Each entry should correspond to a real file, with the exception of the main asset entry.
    If the main asset entry doesn't correspond to a real file, then the asset with the lowest resolution is used as the fallback
    for devices with device pixel ratios below that resolution. The entry should still be included in the pubspec.yaml manifest, however.
"""

### Set up constants

CACHED_SCALED_SIZES = [1.25, 1.5, 2.0, 3.0, 4.0]
BASE_EDGE_SIZE_AT_1X = 22

EDGE_SIZE_SUBDIR_NAME = {int(BASE_EDGE_SIZE_AT_1X * scaled_size) : f"{scaled_size}x" for scaled_size in CACHED_SCALED_SIZES}

SVG_PATTERN = os.path.join(os.getcwd(), "*.svg")
SVG_PATHS = glob(SVG_PATTERN)
ICONDIR_NAME = "pngicons"
ICONDIR = os.path.join(os.getcwd(), ICONDIR_NAME)

EDGE_SIZE_SUBDIR_PATH = {edge_size : os.path.join(ICONDIR, path) for edge_size, path in EDGE_SIZE_SUBDIR_NAME.items()}

### Make subdirectories if not present

for dir in EDGE_SIZE_SUBDIR_PATH.values():
    try:
        os.mkdir(dir)
    except FileExistsError:
        print(f"Dir {dir} already exists; expected condition for re-runs", file=sys.stderr)

def getArgs(svg_path: str, square_edge: int, subdir_path = ICONDIR) -> list[str]:
    args = ["/usr/bin/env", "convert", "-background", "none", "-transparent", "white", "+antialias", "-resize"]
    base_name = os.path.basename(svg_path).removesuffix(".svg")
    args.append(f"{square_edge}x{square_edge}")

    args.append(svg_path)
    args.append(f"{subdir_path}/{base_name}.png")
    print(args)

    return args
    

### Make 1x files
for svg_path in SVG_PATHS:
    subprocess.run(getArgs(svg_path, BASE_EDGE_SIZE_AT_1X, ICONDIR))

### Make scaled files
for svg_path in SVG_PATHS:
     for scaled_size, subdir in EDGE_SIZE_SUBDIR_PATH.items():
         subprocess.run(getArgs(svg_path,scaled_size,subdir))

