#!/usr/bin/env python
"""
moonphase.py - Calculate Lunar Phase
Author: Sean B. Palmer, inamidst.com
Cf. http://en.wikipedia.org/wiki/Lunar_phase#Lunar_phase_calculation
"""

import math, decimal, datetime
dec = decimal.Decimal

conky_emoji_open = "${font 'Symbola'}"
conky_emoji_close = "${font}"

MOON_EMOJIS = (
    u"🌑", u"🌒", u"🌓", u"🌔", u"🌕", u"🌖", u"🌗", u"🌘"
)

def position(now=None): 
   if now is None: 
      now = datetime.datetime.now()

   diff = now - datetime.datetime(2001, 1, 1)
   days = dec(diff.days) + (dec(diff.seconds) / dec(86400))
   lunations = dec("0.20439731") + (days * dec("0.03386319269"))

   return lunations % dec(1)

def phase(pos): 
   index = (pos * dec(8)) + dec("0.5")
   index = math.floor(index)
   return {
      0: "New Moon", 
      1: "Waxing Crescent", 
      2: "First Quarter", 
      3: "Waxing Gibbous", 
      4: "Full Moon", 
      5: "Waning Gibbous", 
      6: "Last Quarter", 
      7: "Waning Crescent"
   }[int(index) & 7]

def emoji(pos):
  index = (pos * dec(8)) + dec("0.5")
  index = math.floor(index)
  emoji = {
    0: u"🌑",
    1: u"🌒",
    2: u"🌓",
    3: u"🌔",
    4: u"🌕",
    5: u"🌖",
    6: u"🌗",
    7: u"🌘"
  }[int(index) & 7]
  return conky_emoji_open + emoji + conky_emoji_close

def main(): 
   pos = position()
   phasename = phase(pos)
   phaseemoji = emoji(pos)

   roundedpos = round(float(pos)*100)
   print("%s %s (%s%%)" % (phaseemoji, phasename, roundedpos))

if __name__=="__main__": 
   main()
