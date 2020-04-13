#!/usr/bin/python

import requests
import datetime
import argparse
from astral import moon

parser = argparse.ArgumentParser(description='Get the weather for a location.')
parser.add_argument('--location',
                    '-l',
                    default='London',
                    help='set weather location')
parser.add_argument('--conky',
                    '-c',
                    dest='conky',
                    default=False,
                    action='store_true',
                    help='display with Conky escape codes')

args = parser.parse_args()

conky_emoji_open = "${font 'Symbola'}" if args.conky else ""
conky_emoji_close = "${font}" if args.conky else ""

MOON_PHASES = (
    u"🌑", u"🌒", u"🌓", u"🌔", u"🌕", u"🌖", u"🌗", u"🌘"
)


def render_moonphase():
    """
    A symbol describing the phase of the moon
    """
    moon_index = int(
        int(32.0*moon.phase(date=datetime.datetime.today())/28+2) % 32/4
    )
    return MOON_PHASES[moon_index]


url = "https://wttr.in/" + args.location + "?format=j1"

try:
    r = requests.get(url)
    weather = r.json()

    current_temperature = weather["current_condition"][0]["temp_C"] + '°C'
    max_temperature = weather["weather"][0]["maxtempC"] + '°'
    min_temperature = weather["weather"][0]["mintempC"] + '°'
    weather_type = weather["current_condition"][0]["weatherDesc"][0]["value"]
    moon_illumination = render_moonphase()

    # current_temperature = weather["current_condition"][0]["temp_C"]
    # current_temperature = weather["current_condition"][0]["temp_C"]

    print(weather_type + ' ' + current_temperature + ' (' +
          max_temperature + '/' + min_temperature + ') ' + conky_emoji_open + moon_illumination + conky_emoji_close)
except requests.exceptions.RequestException as e:
    raise SystemExit(e)
