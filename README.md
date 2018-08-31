kml-hax
=======

Misc scripts for dealing with Avail's KML file peculiarities

* `kml-check.rb`: Crawls all of the routes available at the `GetAllRoutes`
  endpoint and compares the HTML color to the KML color; reports if they don't
  match.

* `kml-get.rb`: Downloads all of the KML files for routes available at the
  `GetAllRoutes` endpoint.

* `fixer.ps1`: Run this script from within a directory containing KML files. It
  will create a `fixed/` directory containing KML files with their colors
  corrected.
