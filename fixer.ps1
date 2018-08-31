if (!(Test-Path './fixed')) {
  New-Item -ItemType directory -Path ./fixed
}

Get-ChildItem "./*.kml" |
Foreach-Object {
  Write-Host $_.FullName
  [xml]$document = Get-Content $_.FullName
  $nsmgr = New-Object System.Xml.XmlNamespaceManager $document.NameTable
  $nsmgr.AddNamespace('kml','http://www.opengis.net/kml/2.2')
  
  $colornode = $document.SelectSingleNode('//kml:Style//kml:color', $nsmgr)
  if ($colornode) {
    $red = $colornode.InnerText.Substring(2,2)
    $green = $colornode.InnerText.Substring(4,2)
    $blue = $colornode.InnerText.Substring(6,2)
  
    $colornode.InnerText = "ff" + $blue + $green + $red
  }
  
  $newname = "./fixed/" + $_.Name
  if (Test-Path $newname) {
    Remove-Item -Path $newname
  }
  $file = New-Item -ItemType file -Path $newname
  $document.save($file.FullName)
}
