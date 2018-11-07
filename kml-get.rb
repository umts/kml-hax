#!/usr/bin/env ruby
require_relative 'avail.rb'

Avail.routes.each do |route|
  filename = route['RouteTraceFilename']
  next unless filename
  File.open(filename, 'w') do |f|
    f.write(Avail.kml_for(route))
  end
end
