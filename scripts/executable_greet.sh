#!/bin/sh

hour=`date +%H`

if [ $hour -ge 6 -a $hour -lt 12 ]; then
  echo Good morning, Raphael \${font Font Awesome 5 Pro:size=14:style=Solid}\$font
elif [ $hour -ge 12 -a $hour -lt 18 ]; then
  echo Good afternoon, Raphael \${font Font Awesome 5 Pro:size=14:style=Solid}\$font
else
  echo Good evening, Raphael \${font Font Awesome 5 Pro:size=14:style=Solid}\$font
fi
