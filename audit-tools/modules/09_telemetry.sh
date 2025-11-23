#!/bin/bash

run_telemetry() {
    local output=$1
    write_section "$output" "📡 Active Log Domains (Telemetry)"
    
    echo "| Module / File | Logger Domain |" >> "$output"
    echo "|---|---|" >> "$output"
    
    # Logic Original V1 yang hilang
    grep -r -E "CreateLogger\([\"']([^\"']+)[\"']|SmartLogger\.New\([\"']([^\"']+)[\"']" "$TARGET_ROOT/src" --include="*.luau" | while read -r line; do
        # Extract File Name
        file=$(echo "$line" | cut -d: -f1 | xargs basename)
        # Extract Domain Name (Regex magic via sed)
        domain=$(echo "$line" | sed -E 's/.*(CreateLogger|SmartLogger\.New)\(["'\'']([^"'\'']+)["'\''].*/\2/')
        
        echo "| \`$file\` | **$domain** |" >> "$output"
    done
}
