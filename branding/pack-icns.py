#!/usr/bin/env python3
"""Assemble un fichier ICNS a partir de PNG carres deja redimensionnes.

Utilise par branding/gen-icons.sh. Un ICNS moderne est un conteneur simple :
la signature icns, la taille totale, puis un enregistrement par definition,
compose du type sur quatre octets, de la taille et du PNG lui-meme.
"""
import os
import struct
import sys

src, dest = sys.argv[1], sys.argv[2]

# Type ICNS -> taille en pixels du PNG qu'il contient.
TYPES = [
    (b"icp4", 16), (b"icp5", 32), (b"ic11", 32), (b"ic12", 64),
    (b"ic07", 128), (b"ic13", 256), (b"ic08", 256), (b"ic14", 512),
    (b"ic09", 512), (b"ic10", 1024),
]

chunks = b""
for ostype, size in TYPES:
    data = open(os.path.join(src, "%d.png" % size), "rb").read()
    chunks += ostype + struct.pack(">I", len(data) + 8) + data

open(dest, "wb").write(b"icns" + struct.pack(">I", len(chunks) + 8) + chunks)
print("  %s : %d definitions, %d ko" % (dest, len(TYPES), (len(chunks) + 8) // 1024))
