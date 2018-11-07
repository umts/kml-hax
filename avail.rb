require 'bundler'
Bundler.require

require 'json'
require 'net/http'

module Avail
  class << self
    def url(*path_components)
      uri_array = ['https://bustracker.pvta.com/InfoPoint'] + path_components
      URI(uri_array.join('/'))
    end

    def json_get(uri)
      JSON.parse(Net::HTTP.get(uri))
    end

    def kml_get(uri)
      Nokogiri::XML(Net::HTTP.get(uri))
    end

    def routes
      json_get(url(%w[rest Routes GetAllRoutes]))
    end

    def kml_for(route)
      kml_get(url('Resources', 'Traces', route['RouteTraceFilename']))
    end

    def kml_color(doc)
      doc.css('#routestyle color').text
    end

    def color_difference(html, kml)
      hrg, hb = html.hex.divmod 256
      hr, hg = hrg.divmod 256
      kabg, kr = kml.hex.divmod 256
      kab, kg = kabg.divmod 256
      kb = kab % 256
      Math.sqrt((hr - kr)**2 + (hg - kg)**2 + (hb - kb)**2)
    end
  end
end
