#!/bin/bash

run_code_quality() {
    local output=$1
    write_section "$output" "🧹 Code Quality & Standards"
    
    # 1. PATH ANALYSIS (SMART WHITELISTING)
    echo "### 📍 Path Management" >> "$output"
    local hardcoded_count=0
    
    grep -r "game\.\(ServerScriptService\|ReplicatedStorage\)\." "$TARGET_ROOT/src" \
        --exclude="Loader.luau" \
        --exclude="Bootstrap.luau" | while read -r line; do
        
        # WHITELIST: Ignore lines that are requiring the Loader itself
        # [FIXED] Syntax Error fixed here: Unified the wildcard pattern
        if [[ "$line" == *"require("*"Loader"* ]]; then
            continue
        fi
        
        echo "- ❌ **Hardcoded Path:** \`$line\`" >> "$output"
        hardcoded_count=$((hardcoded_count + 1))
    done
    
    if [ $hardcoded_count -gt 0 ]; then
        register_issue "WARNING" $PENALTY_HARDCODED_PATH "$hardcoded_count files use Hardcoded Paths (Bypassing Loader)"
    else
        echo "✅ Path resolution is clean." >> "$output"
    fi
    echo "" >> "$output"

    # 2. API CONTRACTS
    echo "### 📜 API Contract & Telemetry" >> "$output"
    
    echo "**Defined Network Endpoints:**" >> "$output"
    # Grep mencari Requests table dan mengambil 5 baris setelahnya
    grep -r "Requests.*=" "$TARGET_ROOT/src" -A 5 | grep "=" | grep -v "Requests" | while read -r line; do
        # Cleaning output for display
        clean_line=$(echo "$line" | sed 's/^[ \t]*//') 
        echo "- \`$clean_line\`" >> "$output"
    done
}
