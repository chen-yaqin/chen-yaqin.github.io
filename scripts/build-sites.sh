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

cp "$project_dir/worker/index.js" "$server_dir/index.js"

printf 'Static Sites build ready at %s\n' "$build_dir"
