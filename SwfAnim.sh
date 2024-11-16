#!/bin/sh
pdf2swf "$1.pdf" -s zoom=96 -o "$1.swf"
swfcombine -r $2 -dz "$1.swf" -o "$1.swf"
swfdump --html "$1.swf" > "$1.html"

