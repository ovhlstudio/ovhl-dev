#!/bin/bash

run_security() {
    local output=$1
    write_section "$output" "🛡️ Deep Security Scan (Logic & Vuln)"
    
    echo "Running Regex heuristics for Bad Practices..." >> "$output"
    echo "" >> "$output"

    local found_race=0

    # 1. DETECT: Race Conditions (Wait Loops)
    while IFS= read -r file; do
        local filename=$(basename "$file")
        if check_exclusion "$filename"; then continue; fi

        # Check Loop Wait (Strict: while + wait)
        if grep -q "while" "$file" && grep -q "wait" "$file"; then
            echo "- 🔴 **CRITICAL:** Polling Loop Detected in \`$filename\`" >> "$output"
            register_issue "CRITICAL" $PENALTY_RACE_CONDITION "Polling loop detected in $filename"
            found_race=1
        fi

        # Check Task Wait in Init (Stall)
        if grep -q ":Init" "$file" && grep -q "task.wait" "$file"; then
             echo "- 🔴 **CRITICAL:** Init Stalling Detected in \`$filename\`" >> "$output"
             register_issue "CRITICAL" $PENALTY_RACE_CONDITION "Init lifecycle yielding in $filename"
             found_race=1
        fi
    done < <(find "$TARGET_ROOT/src" -type f -name "*.luau")

    if [ $found_race -eq 0 ]; then echo "✅ No obvious race conditions found." >> "$output"; fi
    echo "" >> "$output"

    echo "### 🔓 Data Security & Leaks" >> "$output"
    
    # 2. DETECT: Raw Error Exposure
    grep -r "return.*Error.*=" "$TARGET_ROOT/src/ServerScriptService" | while read -r line; do
        echo "- ⚠️ **Raw Error Exposure:** \`$line\`" >> "$output"
    done

    # 3. DETECT: Global Mutable State (SMARTER)
    # Ignore: local Module = {}, local Constants = {}
    # Target: local Cache = {}, local Data = {}
    echo "" >> "$output"
    grep -r "^local [A-Z].* = {" "$TARGET_ROOT/src/ServerScriptService" | while read -r line; do
        # Exclude module definitions pattern usually named like the file
        if [[ "$line" != *"return"* ]] && [[ "$line" != *"Services"* ]] && [[ "$line" != *"Controller"* ]]; then
             # Exclude standard Module = {} pattern by heuristic (if followed by return later, tough to grep in bash)
             # We blacklist safe words
             if [[ "$line" == *"= {}"* ]] && [[ "$line" != *"Data"* ]] && [[ "$line" != *"Cache"* ]] && [[ "$line" != *"Players"* ]]; then
                continue # Likely safe module definition
             fi
             
             echo "- ⚠️ **Potential Global State:** \`$line\`" >> "$output"
             register_issue "WARNING" $PENALTY_BAD_PRACTICE "Module-level global table detected"
        fi
    done
}
