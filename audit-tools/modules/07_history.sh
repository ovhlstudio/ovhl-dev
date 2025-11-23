#!/bin/bash
run_history_comparison() {
    local output=$1
    write_section "$output" "🕰️ Historical Git Diff"
    
    if git -C "$TARGET_ROOT" rev-parse --git-dir > /dev/null 2>&1; then
        echo "\`\`\`diff" >> "$output"
        git -C "$TARGET_ROOT" diff --stat >> "$output"
        echo "\`\`\`" >> "$output"
    else
        echo "⚠️ No Git Repository detected in target." >> "$output"
    fi
}
