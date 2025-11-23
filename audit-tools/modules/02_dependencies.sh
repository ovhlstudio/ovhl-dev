#!/bin/bash

run_dependencies() {
    local output=$1
    write_section "$output" "🔗 Internal & External Dependencies"
    
    echo "### 📦 External Packages (Loader Analysis)" >> "$output"
    echo "| Package Name | Status | References |" >> "$output"
    echo "|---|---|---|" >> "$output"
    
    grep -r "Loader.Pkg" "$TARGET_ROOT/src" --include="*.luau" | awk -F'["'\'']' '{print $2}' | sort | uniq -c | while read count pkg; do
        if [[ ! -z "$pkg" ]]; then
            echo "| **$pkg** | ✅ Active | $count refs |" >> "$output"
        fi
    done

    echo "" >> "$output"
    echo "### 🕷️ Module Coupling (Loader Usage)" >> "$output"
    local loader_refs=$(grep -r "Loader.Core" "$TARGET_ROOT/src" | wc -l)
    echo "- **Central Core Refs:** $loader_refs files depend on Core modules directly." >> "$output"
}
