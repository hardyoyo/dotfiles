#!/bin/sh

URL='https://www.accuweather.com/en/us/columbia-mo/65201/weather-forecast/329434'

wget -q -O- "$URL" | awk -F\' '/acm_RecentLocationsCarousel\.push/{print $2": "$16", "$12"°" }'| head -1
