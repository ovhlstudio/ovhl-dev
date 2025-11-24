#!/bin/bash

format_lines() {
    local lines=$1
    if [ $lines -ge 1000 ]; then echo "$((lines / 1000))K lines"; else echo "$lines lines"; fi
}

format_size() {
    local bytes=$1
    if [ $bytes -ge 1048576 ]; then echo "$((bytes / 1048576))M"; elif [ $bytes -ge 1024 ]; then echo "$((bytes / 1024))K"; else echo "${bytes}B"; fi
}

get_git_info() {
    local target=$1
    if [ -d "$target/.git" ] || git -C "$target" rev-parse --git-dir > /dev/null 2>&1; then
        local branch=$(git -C "$target" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
        local commit=$(git -C "$target" rev-parse --short HEAD 2>/dev/null || echo "unknown")
        local mod_count=$(git -C "$target" status --short 2>/dev/null | wc -l)
        echo "Branch: $branch | Commit: $commit | Modified files: $mod_count"
    else
        echo "Not a git repository"
    fi
}

# --- [UPDATED] SMART FILTER LOGIC ---
check_exclusion() {
    local filename=$1
    
    # 1. GLOBAL JUNK (Exclude)
    if [[ "$filename" == ".DS_Store" || "$filename" == "Thumbs.db" || "$filename" == ".git" ]]; then
        return 0 
    fi

    # 2. CODE WHITELIST (Keep)
    # Kunci biar .spec.luau lolos!
    if [[ "$filename" == *.lua || "$filename" == *.luau ]]; then
        return 1 
    fi

    # 3. CONFIG PATTERNS (Exclude)
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        if [[ "$filename" == $pattern ]]; then return 0; fi
    done
    
    return 1 # Keep default
}

# --- [FIXED] SMART STATS CALCULATION ---

get_structure_summary() {
    local root=$1
    local total_folders=0
    local total_files=0
    local lua_files=0
    
    for dir in "${SCAN_DIRS[@]}"; do
        if [ -d "$root/$dir" ]; then
            # Hitung Folder
            local f_count=$(find "$root/$dir" -type d -not -path '*/.*' -not -path '*/Packages*' -not -path '*/_Index*' | wc -l)
            total_folders=$((total_folders + f_count))
            
            # Hitung File
            local all_count=$(find "$root/$dir" -type f -not -path '*/.*' -not -path '*/Packages*' -not -path '*/_Index*' | wc -l)
            total_files=$((total_files + all_count))
            
            # Hitung Lua (Support dual extensions)
            local l_count=$(find "$root/$dir" -type f \( -name "*.lua" -o -name "*.luau" \) -not -path '*/Packages*' -not -path '*/_Index*' | wc -l)
            lua_files=$((lua_files + l_count))
        fi
    done
    
    local other_files=$((total_files - lua_files))
    echo "$total_folders folders | $total_files files ($lua_files Lua/Luau, $other_files other)"
}

get_file_distribution() {
    local root=$1
    local s_files=0; local s_size=0; local s_lines=0
    local c_files=0; local c_size=0; local c_lines=0
    local x_files=0; local x_size=0; local x_lines=0

    # Loop SCAN_DIRS biar aman
    for scan_dir in "${SCAN_DIRS[@]}"; do
        local search_path="$root/$scan_dir"
        if [ ! -d "$search_path" ]; then continue; fi
        
        while IFS= read -r file; do
            local lines=$(wc -l < "$file" 2>/dev/null || echo 0)
            local size=$(wc -c < "$file" 2>/dev/null || echo 0)
            
            if [[ "$file" == *"ServerScriptService"* ]] || [[ "$file" == *"ServerStorage"* ]]; then
                s_files=$((s_files + 1)); s_size=$((s_size + size)); s_lines=$((s_lines + lines))
            elif [[ "$file" == *"StarterPlayer"* ]] || [[ "$file" == *"StarterGui"* ]]; then
                c_files=$((c_files + 1)); c_size=$((c_size + size)); c_lines=$((c_lines + lines))
            else
                # Shared / Tests
                x_files=$((x_files + 1)); x_size=$((x_size + size)); x_lines=$((x_lines + lines))
            fi
        done < <(find "$search_path" -type f \( -name "*.lua" -o -name "*.luau" \) -not -path '*/Packages*' -not -path '*/_Index*')
    done

    echo "Server: $s_files ($(format_size $s_size), $s_lines lines) | Client: $c_files ($(format_size $c_size), $c_lines lines) | Shared: $x_files ($(format_size $x_size), $x_lines lines)"
}