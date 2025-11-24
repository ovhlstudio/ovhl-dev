#!/bin/bash

run_stats() {
    local output=$1
    write_section "$output" "📁 Project Structure & Statistics"
    
    # 1. Tree Generation (Strict)
    for dir in "${SCAN_DIRS[@]}"; do
        local target="$TARGET_ROOT/$dir"
        if [ -d "$target" ]; then
            generate_tree "$target" >> "$output"
        else
            echo "> ⚠️ Directory configured in SCAN_DIRS not found: $dir" >> "$output"
        fi
    done
    
    echo "" >> "$output"
    echo "### 📦 File Distribution Analysis" >> "$output"
    echo "| Directory | Files | Lines | Size |" >> "$output"
    echo "|---|---|---|---|" >> "$output"
    
    # 2. Statistics Counting (Strict & Dual Extension)
    for dir in "${SCAN_DIRS[@]}"; do
        target="$TARGET_ROOT/$dir"
        if [ -d "$target" ]; then
            # Fix: Hitung .lua DAN .luau
            count=$(find "$target" -type f \( -name "*.lua" -o -name "*.luau" \) | wc -l)
            lines=$(find "$target" -type f \( -name "*.lua" -o -name "*.luau" \) -exec cat {} + | wc -l)
            size=$(du -sh "$target" | cut -f1)
            echo "| $dir | $count | $lines | $size |" >> "$output"
        fi
    done
}