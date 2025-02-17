#!/usr/bin/env python3

import os
from glob import glob
import subprocess

SVG_PATTERN = os.path.join(os.getcwd(), "*.svg")
SVG_PATHS = glob(SVG_PATTERN)
ICONDIR_NAME = "pngicons"
ICONDIR = os.path.join(os.getcwd(), ICONDIR_NAME)

def getArgs(svg_path: str, square_edge: int) -> list[str]:
    args = ["/usr/bin/env", "inkscape"]
    base_name = os.path.basename(svg_path).removesuffix(".svg")
    base_name += f"_{square_edge:03}px"
    
    args.append(f"--export-filename={ICONDIR}/{base_name}.png")
    args.append(f"--export-width={square_edge}")
    args.append(f"--export-height={square_edge}")
    args.append(svg_path)

    return args
    
for svg_path in SVG_PATHS:
    for edge_size in range (25,60,5):
        subprocess.run(getArgs(svg_path,edge_size))

