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
  filename = route['RouteTraceFilename']
  next unless filename
  File.open(filename, 'w') do |f|
    f.write(Avail.kml_for route)
  end
end
