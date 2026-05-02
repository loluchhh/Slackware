
#!/bin/bash
 
OUTPUT="all_tagfiles.txt"
TAGFILES_DIR="${1:-.}"
 
> "$OUTPUT"
 
for series_dir in "$TAGFILES_DIR"/*/; do
    series=$(basename "$series_dir")
    tagfile="$series_dir/tagfile"
    
    if [ -f "$tagfile" ]; then
        echo "---- ${series^^} ----" >> "$OUTPUT"
        cat "$tagfile" >> "$OUTPUT"
        echo "" >> "$OUTPUT"
    fi
done
 
echo "Готово: $OUTPUT"
