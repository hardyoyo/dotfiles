#!/usr/bin/env ruby
# encoding: utf-8
# Language: Author name/url

### CONFIG [ THESE VALUES OVERRIDE weatherparser.rb ]
# "City, State" or "City, Country" or ZIP Code
$mycity = '65203'
# f for fahrenheit, c for celsius
$f_or_c = 'f'
# folder where the weather icons are located, no trailing slash
$basedir = '~/weathericons'
### END CONFIG

class Translate

  def translate_conditions(phrase)
    conditions_table = {
      'Overcast' => '',
      'Clear' => '',
      'Partly Cloudy' => '',
      'Mostly Cloudy' => '',
      'Scattered Clouds' => '',
      'Light' => '',
      'Heavy' => '',
      'Drizzle' => '',
      'Rain' => '',
      'Snow' => '',
      'Snow Grains' => '',
      'Ice Crystals' => '',
      'Ice Pellets' => '',
      'Hail' => '',
      'Mist' => '',
      'Fog' => '',
      'Smoke' => '',
      'Volcanic Ash' => '',
      'Widespread Dust' => '',
      'Sand' => '',
      'Haze' => '',
      'Spray' => '',
      'Dust Whirls' => '',
      'Sandstorm' => '',
      'Low Drifting Snow' => '',
      'Low Drifting Widespread Dust' => '',
      'Low Drifting Sand' => '',
      'Blowing Snow' => '',
      'Blowing Widespread Dust' => '',
      'Blowing Sand' => '',
      'Rain Mist' => '',
      'Rain Showers' => '',
      'Snow Showers' => '',
      'Ice Pellet Showers' => '',
      'Hail Showers' => '',
      'Small Hail Showers' => '',
      'Thunderstorm' => '',
      'Thunderstorms and Rain' => '',
      'Thunderstorms and Snow' => '',
      'Thunderstorms and Ice Pellets' => '',
      'Thunderstorms with Hail' => '',
      'Thunderstorms with Small Hail' => '',
      'Freezing Drizzle' => '',
      'Freezing Rain' => '',
      'Freezing Fog' => ''
    }
    res = conditions_table[phrase]
    return res == '' || res.nil? ? phrase : res
  end

  def translate_forecast(phrase)
    conditions_table = {
      'Chance of Flurries' => '',
      'Chance of Rain' => '',
      'Chance of Freezing Rain' => '',
      'Chance of Sleet' => '',
      'Chance of Snow' => '',
      'Chance of Thunderstorms' => '',
      'Chance of a Thunderstorm' => '',
      'Clear' => '',
      'Cloudy' => '',
      'Flurries' => '',
      'Fog' => '',
      'Haze' => '',
      'Mostly Cloudy' => '',
      'Mostly Sunny' => '',
      'Partly Cloudy' => '',
      'Partly Sunny' => '',
      'Freezing Rain' => '',
      'Rain' => '',
      'Sleet' => '',
      'Snow' => '',
      'Sunny' => '',
      'Thunderstorms' => '',
      'Thunderstorm' => '',
      'Unknown' => '',
      'Overcast' => '',
      'Scattered Clouds' => ''
    }

    res = conditions_table[phrase]
    return res == '' || res.nil? ? phrase : res
  end

  def translate_strings(phrase)
    strings_table = {
      'Forecast for' => ''
    }
    res = strings_table[phrase]
    return res == '' || res.nil? ? phrase : res
  end

  def translate_day(phrase)
    day_table = {
      'Sunday' => '',
      'Monday' => '',
      'Tuesday' => '',
      'Wednesday' => '',
      'Thursday' => '',
      'Friday' => '',
      'Saturday' => ''
    }
    res = day_table[phrase]
    return res == '' || res.nil? ? phrase : res
  end

  def current_time
    # set the format using strftime placeholders
    # http://apidock.com/ruby/DateTime/strftime
    # Example: 24-hour format
    # time_format = '%H:%M'
    time_format = '%-l:%M %p'
    Time.now.strftime(time_format)
  end
end
