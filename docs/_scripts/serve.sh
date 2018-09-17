#!/bin/sh
set -e
cd "$(dirname "$0")/.."

if [ ! -s lab/fonts ]; then
  rm -f lab/fonts
  ln -fs ../../build/fonts lab/fonts
fi

# jekyll is a little dumb and resolves the lab/fonts symlink and copies
# all font files to _site when started. Bad jekyll.
# Let's work around that.
rm -rf _site
sh <<_EOF_ &
N=3
while [ \$N -gt 0 ]; do
  sleep 1
  mkdir -p _site/lab
  if [ -d _site/lab/fonts ]; then
    rm -rf _site/lab/fonts
  else
    rm -f _site/lab/fonts
  fi
  ln -fs ../../../build/fonts _site/lab/fonts
  let N=N-1
done
_EOF_

jekyll serve --limit_posts 20 --watch --host 127.0.0.1 --port 3002
