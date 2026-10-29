#!/usr/bin/env bash
# Descarga la «Imagen del día» de Wikimedia Commons de los últimos 30 días en photos/
# (AAAA-MM-DD.jpg a 960 px y AAAA-MM-DD.json con título, autor y licencia).
# Así la app la sirve desde el propio sitio. Si un día falla, se salta.
set -u
cd "$(dirname "$0")/../.."
mkdir -p photos
API="https://commons.wikimedia.org/w/api.php?format=json&formatversion=2"
UA="TacoDiario/1.0 (https://gborar.github.io/taco-diario/)"
for i in $(seq 0 29); do
  d=$(TZ=Europe/Madrid date -d "-$i day" +%F)
  file=$(curl -fsS -A "$UA" --get "$API" --data-urlencode "action=expandtemplates" --data-urlencode "prop=wikitext" \
    --data-urlencode "text={{Potd/$d}}" | jq -r '.expandtemplates.wikitext // empty' | tr -d '\n')
  [ -n "$file" ] || { echo "$d: sin archivo"; continue; }
  info=$(curl -fsS -A "$UA" --get "$API" --data-urlencode "action=query" --data-urlencode "prop=imageinfo" \
    --data-urlencode "iiprop=url|extmetadata" --data-urlencode "iiurlwidth=960" --data-urlencode "iiextmetadatalanguage=es" \
    --data-urlencode "titles=File:$file") || { echo "$d: falla imageinfo"; continue; }
  thumb=$(jq -r '.query.pages[0].imageinfo[0].thumburl // empty' <<<"$info")
  [ -n "$thumb" ] || { echo "$d: sin miniatura"; continue; }
  if curl -fsS -A "$UA" -o "photos/$d.jpg" "$thumb"; then
    jq --arg date "$d" --arg file "$file" -f .github/scripts/foto.jq <<<"$info" > "photos/$d.json"
    echo "$d: $file"
  else
    rm -f "photos/$d.jpg"; echo "$d: falla la descarga"
  fi
  sleep 1
done
