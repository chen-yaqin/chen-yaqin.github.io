#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
build_dir="$project_dir/dist"
client_dir="$build_dir/client"
server_dir="$build_dir/server"

rm -rf "$client_dir" "$server_dir"
mkdir -p "$client_dir" "$server_dir"

for file in index.html 404.html feed.xml robots.txt sitemap.xml; do
  cp "$project_dir/$file" "$client_dir/$file"
done

for directory in assets images files experiences publications projects notes misc sitemap; do
  cp -R "$project_dir/$directory" "$client_dir/$directory"
done

# Sites limits individual static assets to 25 MiB. Keep the source paper at its
# original quality and optimize only the generated deployment copy.
large_paper="$client_dir/files/MVU-AE.pdf"
if [[ -f "$large_paper" ]]; then
  if ! command -v gs >/dev/null 2>&1; then
    printf 'Ghostscript is required to optimize %s for deployment.\n' "$large_paper" >&2
    exit 1
  fi

  optimized_paper="$client_dir/files/.MVU-AE.optimized.pdf"
  gs -sDEVICE=pdfwrite \
    -dCompatibilityLevel=1.6 \
    -dPDFSETTINGS=/ebook \
    -dNOPAUSE \
    -dBATCH \
    -dQUIET \
    -dDetectDuplicateImages=true \
    -dCompressFonts=true \
    -sOutputFile="$optimized_paper" \
    "$large_paper"
  mv "$optimized_paper" "$large_paper"
fi

cp "$project_dir/worker/index.js" "$server_dir/index.js"

printf 'Static Sites build ready at %s\n' "$build_dir"
