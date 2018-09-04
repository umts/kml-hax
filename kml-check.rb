#!/usr/bin/env ruby
require_relative 'avail.rb'

Avail.routes.each do |route|
  route_color = route['Color'].to_s.upcase
  next if route_color == ''
  kml_color = Avail.kml_color(Avail.kml_for route).upcase
  #puts route['RouteAbbreviation'], route_color, Avail.kml_color(Avail.kml_for(route))
  r, g, b = route_color[0,2], route_color[2,2], route_color[4,2]
  unless kml_color =~ /[0-9A-F]{2}#{b+g+r}/
    puts ["Route: #{route['RouteAbbreviation']} (#{route['RouteId']})",
          "Color: #{route_color}",
          "KML Color: #{kml_color}",
          "Difference: #{Avail.color_difference(route_color, kml_color)}"].join(', ')
  end
end
