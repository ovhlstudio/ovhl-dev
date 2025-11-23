#!/bin/bash
run_architecture() {
    local output=$1
    write_section "$output" "⚖️  Architecture Verdict (THE JUDGE)"
    
    # Check CI/CD
    if [ ! -d "$TARGET_ROOT/.github" ]; then
        register_issue "CRITICAL" $PENALTY_MISSING_DOCS "Missing CI/CD Pipeline"
    fi

    local final_score=$((SCORE_START - GLOBAL_PENALTY_POINTS))
    if [ $final_score -lt 0 ]; then final_score=0; fi
    
    echo "### 🏁 Final Health Score: **$final_score / 100**" >> "$output"
    echo "" >> "$output"
    echo "#### 📉 Penalty Breakdown:" >> "$output"
    
    if [ ${#ISSUE_LOG[@]} -eq 0 ]; then
        echo "✅ Clean Audit. No penalties applied." >> "$output"
    else
        for item in "${ISSUE_LOG[@]}"; do
            # Parse log: type|weight|message
            local type=$(echo "$item" | cut -d'|' -f1)
            local weight=$(echo "$item" | cut -d'|' -f2)
            local msg=$(echo "$item" | cut -d'|' -f3)
            echo "- **$type** (-$weight): $msg" >> "$output"
        done
    fi
}
