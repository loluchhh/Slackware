#!/bin/bash
for series in ./*/; do
  name=$(basename "$series")
  cp "$series/tagfile" /home/loluchh/Документы/Slackware-VM/slackarchive/slackware64/$name/tagfile
done
