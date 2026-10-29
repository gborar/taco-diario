# Convierte la respuesta de imageinfo de Commons en la ficha de la foto del día.
def txt: (. // "") | tostring | gsub("<[^>]*>"; "") | gsub("&amp;"; "&") | gsub("&quot;"; "\"") | gsub("&#0?39;"; "'")
  | gsub("&lt;"; "<") | gsub("&gt;"; ">") | gsub("&nbsp;"; " ") | gsub("\\s+"; " ") | ltrimstr(" ") | rtrimstr(" ");
.query.pages[0].imageinfo[0] as $ii | ($ii.extmetadata // {}) as $m
| ($m.ObjectName.value | txt) as $name
| {
    date: $date,
    file: $file,
    title: (if $name == "" then ($file | sub("\\.[A-Za-z0-9]+$"; "") | gsub("_"; " ")) else $name end),
    desc: ($m.ImageDescription.value | txt),
    artist: ($m.Artist.value | txt),
    license: ($m.LicenseShortName.value | txt),
    page: $ii.descriptionurl
  }
