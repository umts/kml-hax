#!/usr/bin/env ruby

require 'json'
require 'net/http'
require 'nokogiri'
require 'pry'

module Avail
  def self.url(*path_components)
    uri_array = ['https://bustracker.pvta.com/InfoPoint'] + path_components
    URI(uri_array.join('/'))
  end

  def self.json_get(uri)
    JSON.parse(Net::HTTP.get uri)
  end

  def self.kml_get(uri)
    Nokogiri::XML(Net::HTTP.get uri)
  end

  def self.routes
    json_get(url %w[rest Routes GetAllRoutes])
  end

  def self.kml_for(route)
    kml_get(url 'Resources', 'Traces', route['RouteTraceFilename'])
  end

  def self.kml_color(doc)
    doc.css('#routestyle color').text
  end

  def self.color_difference(html, kml)
    hrg, hb = html.hex.divmod 256
    hr, hg = hrg.divmod 256
    kabg, kr = kml.hex.divmod 256
    kab, kg = kabg.divmod 256
    kb = kab % 256
    Math.sqrt((hr - kr)**2 + (hg - kg)**2 + (hb - kb)**2)
  end
end

Avail.routes.each do |route|
  route_color = route['Color'].to_s.upcase
  next if route_color == ''
  kml_color = Avail.kml_color(Avail.kml_for route).upcase
  #puts route['RouteAbbreviation'], route_color, Avail.kml_color(Avail.kml_for(route))
  r, g, b = route_color[0,2], route_color[2,2], route_color[4,2]
  unless kml_color =~ /[0-9A-F]{2}#{b+g+r}/
    puts ["Route: #{route['RouteAbbreviation']}",
          "Color: #{route_color}",
          "KML Color: #{kml_color}",
          "Difference: #{Avail.color_difference(route_color, kml_color)}"].join(', ')
  end
end
