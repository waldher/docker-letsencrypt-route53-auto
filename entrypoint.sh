#!/bin/sh
./dehydrated --register --accept-terms
./dehydrated --cron --hook ./dehydrated.default.sh --challenge dns-01 $@
