#!/usr/bin/env ruby
# encoding: utf-8
# GeekTool WeatherParser by Brett Terpstra
# <http://brettterpstra.com>
# Localizations available:
#    Japanese: thanks to [Brandon Pittman](http://www.brandonpittman.net/)
#    French: thanks to [Guillaume Kuster](http://twitter.com/guikos)
#    Dutch: thanks to [Bart Tilburgs](http://twitter.com/barttilburgs)
#    Spanish: thanks to Pedro G
#    German: thanks to [Nils Fischer](http://nilsfischer.org/.)
#    German update: thanks to Stefan Kovalovsky

# This is public domain, do what you will with it. Credit/attribution is appreciated.

fmt = ARGV[0]
icon_override = ARGV[1]

# If you're using localization, skip the config in this file
# and set your values in weather_localization.rb

localization_file = "weather_localization.rb"
# For non-english languages, change the filename to match your localization file
# e.g. localization_file = "weather_localization_es.rb"
# The default file is blank and will use English automatically,
# and setting localization_file to false will remove the requirement for the
# additional file completely.

# IMPORTANT: If localization file is configured and present in the same folder,
# you can ignore the rest of the config. Anything in the localized file
# overrides these settings.

# CONFIG [ THESE VALUES WILL BE OVERRIDDEN BY YOUR LOCALIZATION FILE ]
# "City, State" or "City, Country" or ZIP Code
$mycity = '65203'
# f for fahrenheit, c for celsius
$f_or_c = 'f'
# folder where the weather icons are located, no trailing slash
$basedir = '~/weathericons'
### END CONFIG

require 'rexml/document'
require 'net/http'
require 'cgi'
require 'fileutils'


class Translate

  def translate_conditions(phrase)
    phrase
  end

  def translate_forecast(phrase)
    phrase
  end

  def translate_strings(phrase)
    phrase
  end

  def translate_day(phrase)
    phrase
  end

  def current_time
    time_format = '%-l:%M %p'
    Time.now.strftime(time_format).downcase
  end
end

if localization_file && File.exists?(File.join(File.dirname(__FILE__),File.basename(localization_file)))
  require File.join(File.dirname(__FILE__),File.basename(localization_file))
end

def the_time
  Translate.new.current_time
end

def current(mycity,icon_override=nil)
  tr = Translate.new
  response = Net::HTTP.get_response(URI.parse(URI.escape("http://api.wunderground.com/auto/wui/geo/WXCurrentObXML/index.xml?query=#{mycity}")))
  doc = REXML::Document.new(response.body)
  obs = doc.elements['current_observation'].elements
  temp = $f_or_c === 'f' ? obs['temp_f'].text : obs['temp_c'].text
  text = obs['weather'].text
  case text
  when /^(Heavy|Light)/
      pre = tr.translate_conditions($1)
      text = pre + " " + tr.translate_conditions(text.gsub(/^(Heavy|Light) /,''))
  else
    text = tr.translate_conditions(text)
  end
  unless icon_override.nil?
    icon_name = icon_override
  else
    icon_name = obs['icon'].text
  end

  nighttime_icons = ['cloudy','clear','mostlycloudy','rain','tstorms','snow']
  if (Time.now.hour > 19 || Time.now.hour < 8) && nighttime_icons.include?(icon_name)
    icon_name = "nt_#{icon_name}"
  end

  set_icon(icon_name)
  return "#{text}, #{temp}° #{$f_or_c.upcase}"
end

def set_icon(imgname)
  output = File.expand_path("#{$basedir}/#{imgname}.png")
  File.delete(File.expand_path("#{$basedir}/weathericon.png")) if File.exists?(File.expand_path("#{$basedir}/weathericon.png"))
  begin
    FileUtils.copy(output,File.expand_path("#{$basedir}/weathericon.png"))
  rescue
    FileUtils.copy(File.expand_path("#{$basedir}/unknown.png"),File.expand_path("#{$basedir}/weathericon.png"))
  end
end

def forecast(mycity)
  tr = Translate.new
  response = Net::HTTP.get_response(URI.parse(URI.escape("http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=#{mycity}")))
  curr_response = Net::HTTP.get_response(URI.parse(URI.escape("http://api.wunderground.com/auto/wui/geo/WXCurrentObXML/index.xml?query=#{mycity}")))
  if RUBY_VERSION.to_f > 1.9
    cast = response.body.force_encoding('utf-8')
    current = curr_response.body.force_encoding('utf-8')
  else
    cast = response.body
    current = curr_response.body
  end
  doc = REXML::Document.new(cast)
  curr_doc = REXML::Document.new(current)
  forecast = doc.elements['forecast/simpleforecast'].elements
  loc = curr_doc.elements['current_observation/display_location/full'].text



  o = tr.translate_strings('Forecast for').strip.gsub(/\s*\Z/," ") +loc + "\n"
  forecast.each('forecastday') {|day|
    wkday = tr.translate_day(day.elements['date'].elements['weekday'].text)
    if $f_or_c === 'c'
      high = day.elements['high'].elements['celsius'].text
      low = day.elements['low'].elements['celsius'].text
    else
      high = day.elements['high'].elements['fahrenheit'].text
      low = day.elements['low'].elements['fahrenheit'].text
    end
    cond = tr.translate_forecast(day.elements['conditions'].text)
    spacer = ''
    (10 - wkday.length).times do
      spacer += ' '
    end
    # o += "#{spacer}#{wkday}: #{high}/#{low}, #{cond}\n"
    o += "#{wkday}: #{high}/#{low}, #{cond}\n"
  }
  return o
end

if fmt == "current"
  print current($mycity,icon_override)
elsif fmt == "forecast"
  print forecast($mycity)
elsif fmt == "time"
  print the_time
else
  puts current($mycity,icon_override)
  print forecast($mycity)
end
