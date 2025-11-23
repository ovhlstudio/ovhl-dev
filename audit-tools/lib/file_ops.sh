#!/bin/bash

# Add Line Numbers Style (0001 | code)
add_line_numbers() {
    local file=$1
    # Fallback if nl not available, simple cat -n
    nl -ba -w4 -s" | " "$file" 2>/dev/null || cat -n "$file"
}

# Smart Truncate (RESTORED from V1)
# Shows Head 60% + Tail 40% if file > MAX lines
smart_dump_file() {
    local file=$1
    local rel_path=$2
    local total_lines=$(wc -l < "$file" 2>/dev/null || echo 0)
    local size=$(wc -c < "$file" 2>/dev/null || echo 0)

    echo "<details>"
    echo "<summary><strong>🌙 $rel_path</strong> ($(format_lines $total_lines), $(format_size $size))</summary>"
    echo ""
    echo "**Full Path:** \`$file\`"
    echo ""
    echo "\`\`\`lua"

    if [ $total_lines -le $MAX_FILE_LINES ]; then
        add_line_numbers "$file"
    else
        # Calculate splits
        local first_part=$((MAX_FILE_LINES * 6 / 10))
        local last_part=$((MAX_FILE_LINES * 4 / 10))
        local hidden=$((total_lines - first_part - last_part))
        
        head -n $first_part "$file" | add_line_numbers
        echo "      ... [TRUNCATED: $hidden lines hidden by Audit Tool] ..."
        tail -n $last_part "$file" | awk -v start=$((total_lines - last_part + 1)) '{printf "%4d | %s\n", start+NR-1, $0}'
    fi

    echo "\`\`\`"
    echo "</details>"
}

generate_tree() {
    local dir=$1
    echo "\`\`\`"
    echo "📦 $(basename "$dir")/"
    find "$dir" -print | sort | while read -r path; do
        if [ "$path" = "$dir" ]; then continue; fi
        
        local name=$(basename "$path")
        # Apply Exclusion
        if check_exclusion "$name"; then continue; fi

        # Visual Indent
        local depth=$(echo "$path" | sed "s|$dir||" | tr -cd '/' | wc -c)
        local indent=""
        for ((i=0; i<depth; i++)); do indent="$indent  "; done

        if [ -d "$path" ]; then
            echo "$indent├── 📁 $name/"
        else
            echo "$indent├── 🌙 $name"
        fi
    done
    echo "\`\`\`"
}
