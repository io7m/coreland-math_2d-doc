#!/bin/sh
make clean html-split css txt package release &&
  rsync -avz --delete release/ www:/sites/waste/doc/math_2D-doc-release/
