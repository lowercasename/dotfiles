#!/bin/sh

h=`date +%H`

if (( h >= 6 && h < 12)); then
  echo Good morning, Raphael \${font Font Awesome 5 Pro:size=14:style=Solid}\$font
elif (( h >= 12 && h < 18)); then
  echo Good afternoon, Raphael \${font Font Awesome 5 Pro:size=14:style=Solid}\$font
else
  echo Good evening, Raphael \${font Font Awesome 5 Pro:size=14:style=Solid}\$font
fi
