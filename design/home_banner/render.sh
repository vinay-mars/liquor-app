#!/bin/zsh
# Renders a banner page (default banner.html; 6th arg e.g. banner_deals.html) to PNG with headless Chrome.
#   ./render.sh phone  1200 600 2 phone.png    -> 2400x1200 (phones, ~2:1)
#   ./render.sh tablet 1032 200 3 tablet.png   -> 3096x600  (iPads, ~5:1)
# Then convert to the app assets:
#   sips -s format jpeg -s formatOptions 88 phone.png  --out ../../assets/images/home_banner_pringles_phone.jpg
#   sips -s format jpeg -s formatOptions 88 tablet.png --out ../../assets/images/home_banner_pringles_tablet.jpg
C="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"; D=${0:A:h}; P=$(mktemp -d)
"$C" --headless=new --disable-gpu --hide-scrollbars --no-first-run --user-data-dir=$P --allow-file-access-from-files \
  --virtual-time-budget=6000 --window-size=$2,$3 --force-device-scale-factor=$4 --screenshot=$D/$5 "file://$D/${6:-banner.html}?layout=$1" >/dev/null 2>&1 &
pid=$!; for i in {1..40}; do [ -f $D/$5 ] && sleep 1 && break; sleep 1; done; kill $pid 2>/dev/null; rm -rf $P
