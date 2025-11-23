#!/bin/bash

# ULTIMATE Snapshot Script with Advanced Architecture Analysis  
# NEW FEATURES: Path Analysis, API Contract Validation, UI System Detection, Enterprise Metrics, Smart Package Detection
# Usage: ./audit.sh [options]
# Options:
#   -d, --diff      Include diff from last snapshot
#   -c, --compact   Compact mode (structure only, no code)  
#   -a, --analyze   Run dependency analysis
#   -t, --truncate  Truncate large files (>1000 lines)
#   -p, --path      Advanced path management analysis
#   -u, --ui        UI system detection and analysis
#   -h, --help      Show help

set -e

# Configuration
TARGET_DIRS=("src" "tests")
EXPORT_BASE="./lokal/exports/"
DATE=$(date +%Y-%m-%d)
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
EXPORT_DIR="${EXPORT_BASE}/${DATE}"
SNAPSHOT_FILE="${EXPORT_DIR}/project-snapshot-${TIMESTAMP}.md"

# Limits
MAX_FILE_LINES=1000  # Truncate files larger than this
MAX_TOTAL_FILES=200  # Safety limit

# Exclusion patterns
EXCLUDE_PATTERNS=("*.spec.lua" "*.test.lua" "*_temp.*" "*.bak" "*.old" "*.spec.luau" "*.test.luau")

# Options
SHOW_DIFF=false
COMPACT_MODE=false
ANALYZE_DEPS=false
TRUNCATE_LARGE=false
ANALYZE_PATHS=false
ANALYZE_UI=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--diff)
            SHOW_DIFF=true
            shift
            ;;
        -c|--compact)
            COMPACT_MODE=true
            shift
            ;;
        -a|--analyze)
            ANALYZE_DEPS=true
            shift
            ;;
        -t|--truncate)
            TRUNCATE_LARGE=true
            shift
            ;;
        -p|--path)
            ANALYZE_PATHS=true
            shift
            ;;
        -u|--ui)
            ANALYZE_UI=true
            shift
            ;;
        -h|--help)
            echo "Usage: ./audit.sh [options]"
            echo "Options:"
            echo "  -d, --diff      Include diff from last snapshot"
            echo "  -c, --compact   Compact mode (structure only, no code)"
            echo "  -a, --analyze   Run dependency analysis" 
            echo "  -t, --truncate  Truncate large files (>1000 lines)"
            echo "  -p, --path      Advanced path management analysis"
            echo "  -u, --ui        UI system detection and analysis"
            echo "  -h, --help      Show this help"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# [NEW] Auto-enable advanced analysis if -a is used
if [ "$ANALYZE_DEPS" = true ]; then
    ANALYZE_PATHS=true
    ANALYZE_UI=true
fi

# Check if target directories exist
for dir in "${TARGET_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        echo -e "${RED}Error: Target directory '$dir' not found${NC}"
        exit 1
    fi
done

# Create export directory
mkdir -p "$EXPORT_DIR"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   ULTIMATE Project Snapshot Generator${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${GREEN}Targets:${NC} ${TARGET_DIRS[*]}"
echo -e "${GREEN}Output:${NC} $SNAPSHOT_FILE"
echo -e "${GREEN}Analysis:${NC} $([ "$ANALYZE_DEPS" = true ] && echo "Enhanced + Smart Packages" || echo "Basic")"
echo -e "${GREEN}Path Analysis:${NC} $([ "$ANALYZE_PATHS" = true ] && echo "Enabled" || echo "Disabled")"
echo -e "${GREEN}UI Analysis:${NC} $([ "$ANALYZE_UI" = true ] && echo "Enabled" || echo "Disabled")"
echo -e "${GREEN}Truncate:${NC} $([ "$TRUNCATE_LARGE" = true ] && echo "Enabled (>${MAX_FILE_LINES} lines)" || echo "Disabled")"
echo ""

# ==========================================
# EXISTING CORE FUNCTIONS
# ==========================================

# Enhanced metrics functions
format_size() {
    local bytes=$1
    if [ $bytes -ge 1048576 ]; then
        echo "$((bytes / 1048576))M"
    elif [ $bytes -ge 1024 ]; then
        echo "$((bytes / 1024))K"
    else
        echo "${bytes}B"
    fi
}

format_lines() {
    local lines=$1
    if [ $lines -ge 1000 ]; then
        echo "$((lines / 1000))K lines"
    else
        echo "$lines lines"
    fi
}

analyze_distribution() {
    local server_files=0 client_files=0 shared_files=0
    local server_size=0 client_size=0 shared_size=0
    local server_lines=0 client_lines=0 shared_lines=0
    
    while IFS= read -r file; do
        size=$(wc -c < "$file" 2>/dev/null || echo 0)
        lines=$(wc -l < "$file" 2>/dev/null || echo 0)
        if [[ "$file" == *"ServerScriptService"* ]]; then
            server_files=$((server_files + 1))
            server_size=$((server_size + size))
            server_lines=$((server_lines + lines))
        elif [[ "$file" == *"StarterPlayerScripts"* ]]; then
            client_files=$((client_files + 1)) 
            client_size=$((client_size + size))
            client_lines=$((client_lines + lines))
        else
            shared_files=$((shared_files + 1))
            shared_size=$((shared_size + size))
            shared_lines=$((shared_lines + lines))
        fi
    done < <(find "${TARGET_DIRS[@]}" -type f \( -name "*.lua" -o -name "*.luau" \) 2>/dev/null)
    
    echo "**File Distribution:** Server: $server_files ($(format_size $server_size), $(format_lines $server_lines)) | Client: $client_files ($(format_size $client_size), $(format_lines $client_lines)) | Shared: $shared_files ($(format_size $shared_size), $(format_lines $shared_lines))"
}

count_folders_files() {
    local total_folders=0 total_files=0 lua_files=0 other_files=0
    
    for dir in "${TARGET_DIRS[@]}"; do
        total_folders=$((total_folders + $(find "$dir" -type d 2>/dev/null | wc -l)))
        total_files=$((total_files + $(find "$dir" -type f 2>/dev/null | wc -l)))
        lua_files=$((lua_files + $(find "$dir" -type f \( -name "*.lua" -o -name "*.luau" \) 2>/dev/null | wc -l)))
    done
    
    other_files=$((total_files - lua_files))
    echo "**Structure:** $total_folders folders | $total_files files ($lua_files Lua/Luau, $other_files other)"
}

get_total_size() {
    local total_bytes=0
    for dir in "${TARGET_DIRS[@]}"; do
        dir_bytes=$(du -sb "$dir" 2>/dev/null | cut -f1)
        total_bytes=$((total_bytes + dir_bytes))
    done
    format_size $total_bytes
}

# Function to get git info
get_git_info() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
        commit=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
        status=$(git status --short 2>/dev/null | wc -l)
        echo "Branch: $branch | Commit: $commit | Modified files: $status"
    else
        echo "Not a git repository"
    fi
}

# Function to generate pretty tree for a directory
generate_pretty_tree() {
    local target_dir=$1
    echo "📦 $target_dir/"
    find "$target_dir" -print | while read -r path; do
        if [ "$path" = "$target_dir" ]; then
            continue
        fi
        
        # Check if file should be excluded
        filename=$(basename "$path")
        for pattern in "${EXCLUDE_PATTERNS[@]}"; do
            if [[ "$filename" == $pattern ]]; then
                continue 2
            fi
        done
        
        depth=$(echo "$path" | sed "s|$target_dir||" | tr -cd '/' | wc -c)
        indent=""
        for ((i=0; i<depth; i++)); do
            indent="$indent  "
        done
        
        name=$(basename "$path")
        
        if [ "$name" = ".gitkeep" ]; then
            continue
        fi
        
        if [ -d "$path" ]; then
            echo "$indent├── 📁 $name/"
        elif [ -f "$path" ]; then
            case "$name" in
                *.lua|*.luau)
                    echo "$indent├── 🌙 $name"
                    ;;
                *.json)
                    echo "$indent├── 📋 $name"
                    ;;
                *.md)
                    echo "$indent├── 📝 $name"
                    ;;
                *.txt)
                    echo "$indent├── 📄 $name"
                    ;;
                *)
                    echo "$indent├── 📄 $name"
                    ;;
            esac
        fi
    done
}

# Function to add line numbers to code
add_line_numbers() {
    local file=$1
    local line_number=1
    
    while IFS= read -r line; do
        printf "%4d | %s\n" "$line_number" "$line"
        line_number=$((line_number + 1))
    done < "$file"
    
    # Add empty line if file doesn't end with newline
    if [ ${#line} -gt 0 ]; then
        printf "%4d | %s\n" "$line_number" "$line"
    fi
}

# Function to truncate large files
truncate_file_with_lines() {
    local file=$1
    local max_lines=$2
    local total_lines=$(wc -l < "$file")
    
    if [ $total_lines -le $max_lines ]; then
        add_line_numbers "$file"
    else
        # Show first 60% and last 40% with truncation notice
        local first_part=$((max_lines * 6 / 10))
        local last_part=$((max_lines * 4 / 10))
        
        head -n $first_part "$file" | add_line_numbers
        echo "    ... [$(format_lines $((total_lines - first_part - last_part))) truncated] ..."
        tail -n $last_part "$file" | awk -v start=$((total_lines - last_part + 1)) '{printf "%4d | %s\n", start+NR-1, $0}'
    fi
}

# ==========================================
# SMART DEPENDENCY ANALYSIS (SUPPORT FILES & FOLDERS)
# ==========================================

analyze_smart_packages() {
    echo "## 📦 External Package Analysis (Auto-Detected)" >> "$SNAPSHOT_FILE"
    echo "" >> "$SNAPSHOT_FILE"

    # 1. Cek Lokasi Packages
    PACKAGES_DIR=""
    if [ -d "Packages" ]; then
        PACKAGES_DIR="Packages"
    elif [ -d "src/ReplicatedStorage/Packages" ]; then
        PACKAGES_DIR="src/ReplicatedStorage/Packages"
    else
        PACKAGES_DIR=$(find src -type d -name "Packages" -not -path "*/.*" 2>/dev/null | head -n 1)
    fi

    if [ -z "$PACKAGES_DIR" ]; then
        echo "⚠️ **No 'Packages' directory detected.**" >> "$SNAPSHOT_FILE"
        return
    fi

    echo "**Packages Location:** \`$PACKAGES_DIR\`" >> "$SNAPSHOT_FILE"
    echo "" >> "$SNAPSHOT_FILE"
    echo "| Package Name | Type | Status | Intelligence Note | Contexts |" >> "$SNAPSHOT_FILE"
    echo "|--------------|------|--------|-------------------|----------|" >> "$SNAPSHOT_FILE"

    found_any=0
    
    # Loop semua item di dalam Packages (File maupun Folder)
    for pkg_path in "$PACKAGES_DIR"/*; do
        # Skip jika glob tidak match (folder kosong)
        [ -e "$pkg_path" ] || continue
        
        filename=$(basename "$pkg_path")
        
        # Skip folder internal Wally (_Index) & file git
        if [[ "$filename" == "_Index" ]] || [[ "$filename" == ".git" ]] || [[ "$filename" == ".gitignore" ]]; then 
            continue 
        fi
        
        found_any=1
        
        # 1. Tentukan Nama Package (Hapus ekstensi .lua/.luau jika ada)
        pkg_name="${filename%.*}"
        
        # 2. Tentukan Tipe (File Redirector atau Folder Murni)
        pkg_type="Folder"
        if [ -f "$pkg_path" ]; then
            pkg_type="File Ref"
        fi
        
        # 3. Analisa Penggunaan (SMART: Case Insensitive & Loader Check)
        # [FIX] Added 2>/dev/null to suppress permission errors
        usage_count=$(grep -r -i "$pkg_name" "${TARGET_DIRS[@]}" --exclude-dir="Packages" --exclude-dir="_Index" 2>/dev/null | wc -l)
        
        # [FIX] Added 2>/dev/null and separated logic to avoid pipe errors
        loader_usage=$(grep -r "Loader.Pkg" "${TARGET_DIRS[@]}" 2>/dev/null | grep -i "$pkg_name" | wc -l)
        
        # 4. Tentukan Context (Safe Check using wc -l instead of grep -q)
        locations=""
        if [ $(grep -r -i "$pkg_name" src/ServerScriptService --exclude-dir="Packages" --exclude-dir="_Index" 2>/dev/null | wc -l) -gt 0 ]; then locations="${locations}Server "; fi
        if [ $(grep -r -i "$pkg_name" src/StarterPlayer --exclude-dir="Packages" --exclude-dir="_Index" 2>/dev/null | wc -l) -gt 0 ]; then locations="${locations}Client "; fi
        if [ $(grep -r -i "$pkg_name" src/ReplicatedStorage --exclude-dir="Packages" --exclude-dir="_Index" 2>/dev/null | wc -l) -gt 0 ]; then locations="${locations}Shared "; fi
        if [ -z "$locations" ]; then locations="-"; fi

        # 5. Status (Smart Decision)
        status="✅ Active"
        note="Found $usage_count refs"
        
        if [ "$usage_count" -eq 0 ]; then
            status="⚠️ **UNUSED**"
            note="No direct references found"
        elif [ "$loader_usage" -gt 0 ]; then
            status="✅ Active (Loader)"
            note="Mapped via Loader.Pkg ($loader_usage calls)"
        fi

        echo "| **$pkg_name** | $pkg_type | $status | $note | $locations |" >> "$SNAPSHOT_FILE"
    done

    if [ $found_any -eq 0 ]; then
        echo "| *No valid packages found in $PACKAGES_DIR* | - | - | - | - |" >> "$SNAPSHOT_FILE"
    fi
    echo "" >> "$SNAPSHOT_FILE"
}

analyze_manifest_dependencies() {
    echo "## 🔗 Internal Dependency Graph" >> "$SNAPSHOT_FILE"
    echo "" >> "$SNAPSHOT_FILE"
    
    # [FIX] Adjusted to detect Loader.Module dependencies instead of just Manifest files
    echo "### 📊 Module Dependencies (Detected via Loader)" >> "$SNAPSHOT_FILE"
    
    declare -A dependencies
    
    # Scan for Loader.Module("Name") patterns
    while IFS= read -r file; do
        # Extract module name from file path (simplified)
        if [[ "$file" == *"Modules"* ]]; then
            current_module=$(echo "$file" | grep -o "Modules/[^/]*" | cut -d'/' -f2)
            
            # Find dependencies in this file
            while read -r line; do
                # Regex to capture Loader.Module("Target")
                if [[ $line =~ Loader\.Module\(\"([^\"]+)\"\) ]]; then
                    target="${BASH_REMATCH[1]}"
                    if [ "$target" != "$current_module" ] && [ -n "$current_module" ]; then
                         # Avoid duplicates
                         if [[ "${dependencies[$current_module]}" != *"$target"* ]]; then
                             dependencies["$current_module"]="${dependencies[$current_module]} $target"
                         fi
                    fi
                fi
            done < "$file"
        fi
    done < <(find "${TARGET_DIRS[@]}" -type f \( -name "*.lua" -o -name "*.luau" \) 2>/dev/null)

    if [ ${#dependencies[@]} -eq 0 ]; then
        echo "*No explicit module dependencies detected via Loader.*" >> "$SNAPSHOT_FILE"
    else
        for module in "${!dependencies[@]}"; do
             echo "- **$module** depends on: \`${dependencies[$module]}\`" >> "$SNAPSHOT_FILE"
        done
    fi
    echo "" >> "$SNAPSHOT_FILE"
}

detect_race_conditions() {
    echo "### 🏁 Race Condition Analysis" >> "$SNAPSHOT_FILE"
    race_found=0
    
    while IFS= read -r file; do
        if grep -q "DataManager.*LoadData\|DataManager.*SaveData" "$file" && grep -q "before.*Start\|not.*initialized" "$file"; then
            echo "⏰ **Data Race:** $file - Data access before initialization" >> "$SNAPSHOT_FILE"
            race_found=1
        fi
        
        if grep -q "GetSystem.*before.*Initialize\|GetSystem.*not.*ready" "$file"; then
            echo "⏰ **Init Race:** $file - System access before ready" >> "$SNAPSHOT_FILE"
            race_found=1
        fi
    done < <(find "${TARGET_DIRS[@]}" -type f \( -name "*.lua" -o -name "*.luau" \))
    
    if [ $race_found -eq 0 ]; then
        echo "✅ No obvious race conditions detected" >> "$SNAPSHOT_FILE"
    fi
    echo "" >> "$SNAPSHOT_FILE"
}

detect_security_issues() {
    echo "### 🛡️ Security Analysis" >> "$SNAPSHOT_FILE"
    security_issues=0
    
    while IFS= read -r file; do
        if [[ "$file" == *"StarterPlayer"* ]] && grep -q "PermissionCore.*Check\|CheckPermission" "$file"; then
            echo "🔓 **Client Permission:** $file - Permission logic in client code" >> "$SNAPSHOT_FILE"
            security_issues=1
        fi
        
        # [FIX] Whitelist Bridge.luau because it's designed to be shared but run securely
        if [[ "$file" == *"ReplicatedStorage"* ]] && [[ "$file" != *"Bridge.luau"* ]] && grep -q "RateLimiter.*Check" "$file" 2>/dev/null; then
            echo "🔓 **Shared Rate Limit:** $file - Rate limiting in shared code" >> "$SNAPSHOT_FILE" 
            security_issues=1
        fi
    done < <(find "${TARGET_DIRS[@]}" -type f \( -name "*.lua" -o -name "*.luau" \))
    
    if [ $security_issues -eq 0 ]; then
        echo "✅ No obvious security issues detected" >> "$SNAPSHOT_FILE"
    fi
    echo "" >> "$SNAPSHOT_FILE"
}

generate_summary_stats() {
    echo "### 📈 Summary Statistics" >> "$SNAPSHOT_FILE"
    
    echo "#### 📊 Top 10 Largest Files" >> "$SNAPSHOT_FILE"
    find "${TARGET_DIRS[@]}" -type f \( -name "*.lua" -o -name "*.luau" \) -exec wc -l {} + 2>/dev/null | sort -rn | head -11 | tail -10 | while read lines file; do
        echo "- \`$file\` ($(format_lines $lines))" >> "$SNAPSHOT_FILE"
    done
    echo "" >> "$SNAPSHOT_FILE"
    
    echo "#### 📏 File Size Distribution" >> "$SNAPSHOT_FILE"
    declare -A size_ranges=([0-100]=0 [101-500]=0 [501-1000]=0 [1001+]=0)
    
    while IFS= read -r file; do
        lines=$(wc -l < "$file" 2>/dev/null || echo 0)
        if [ $lines -le 100 ]; then
            size_ranges["0-100"]=$((size_ranges["0-100"] + 1))
        elif [ $lines -le 500 ]; then
            size_ranges["101-500"]=$((size_ranges["101-500"] + 1))
        elif [ $lines -le 1000 ]; then
            size_ranges["501-1000"]=$((size_ranges["501-1000"] + 1))
        else
            size_ranges["1001+"]=$((size_ranges["1001+"] + 1))
        fi
    done < <(find "${TARGET_DIRS[@]}" -type f \( -name "*.lua" -o -name "*.luau" \) 2>/dev/null)
    
    for range in "0-100" "101-500" "501-1000" "1001+"; do
        echo "- **$range lines:** ${size_ranges[$range]} files" >> "$SNAPSHOT_FILE"
    done
    echo "" >> "$SNAPSHOT_FILE"
}

# ==========================================
# NEW ADVANCED ANALYSIS FUNCTIONS
# ==========================================

# [NEW] Advanced Path Management Analysis
analyze_path_management() {
    echo "## 🗺️ Advanced Path Management Analysis" >> "$SNAPSHOT_FILE"
    echo "" >> "$SNAPSHOT_FILE"
    
    local path_issues=0
    local absolute_paths=0
    local hardcoded_paths=0
    local valid_anchors=0
    
    echo "### 📍 Path Resolution Patterns" >> "$SNAPSHOT_FILE"
    
    # Analyze path usage patterns
    while IFS= read -r file; do
        # [UPGRADED] Whitelist Logic
        is_whitelisted=false
        if [[ "$file" == *"Bootstrap.luau"* ]] || [[ "$file" == *"Loader.luau"* ]]; then
            is_whitelisted=true
        fi

        # [FIX] Whitelist Core Infrastructure (Loader, Bootstrap) from hardcode check
        if [[ "$file" == *"Loader.luau"* ]] || [[ "$file" == *"Bootstrap.luau"* ]]; then
            # Keep loop running but might skip certain checks
            :
        fi

        if grep -q "game:GetService.*ReplicatedStorage.*OVHL" "$file" || \
           grep -q "script.Parent.Parent.Parent" "$file" || \
           grep -q "OVHL_ROOT" "$file"; then
            hardcoded_paths=$((hardcoded_paths + 1))
            echo "- **Hardcoded Path:** \`$file\`" >> "$SNAPSHOT_FILE"
        fi
        
        if grep -q "ServerScriptService.*OVHL\|StarterPlayerScripts.*OVHL" "$file" || \
           grep -q "game.ServerScriptService" "$file"; then
            
            if [ "$is_whitelisted" = true ]; then
                valid_anchors=$((valid_anchors + 1))
                echo "- ✅ **Valid Anchor:** \`$file\` (Bootstrapper/Loader allowed)" >> "$SNAPSHOT_FILE"
            else
                absolute_paths=$((absolute_paths + 1))
                echo "- ⚠️ **Absolute Path:** \`$file\`" >> "$SNAPSHOT_FILE"
            fi
        fi
    done < <(find "${TARGET_DIRS[@]}" -type f \( -name "*.lua" -o -name "*.luau" \) 2>/dev/null)
    
    # Path consistency analysis
    echo "" >> "$SNAPSHOT_FILE"
    echo "### 🔍 Path Consistency Report" >> "$SNAPSHOT_FILE"
    echo "- **Hardcoded Paths Found:** $hardcoded_paths" >> "$SNAPSHOT_FILE"
    echo "- **Absolute Paths Found:** $absolute_paths (Risky) | $valid_anchors (Valid Anchors)" >> "$SNAPSHOT_FILE"
    
    # [FIXED LOGIC] Safe Proxy Check (No SIGPIPE)
    resolver_count=$(find "${TARGET_DIRS[@]}" -type f \( -name "*.lua" -o -name "*.luau" \) -exec grep -l "Loader.*Proxy\|createProxy\|Loader\.Core" {} + 2>/dev/null | wc -l)
    if [ "$resolver_count" -gt 0 ]; then
        echo "- **Path Resolver:** ✅ Detected (Loader Proxy Pattern)" >> "$SNAPSHOT_FILE"
    else
        echo "- **Path Resolver:** ❌ Missing" >> "$SNAPSHOT_FILE"
        path_issues=$((path_issues + 1))
    fi
    
    # [FIXED LOGIC] Safe Alias Check (No SIGPIPE)
    alias_count=$(find "${TARGET_DIRS[@]}" -type f \( -name "*.lua" -o -name "*.luau" \) -exec grep -l "Loader\.Core\|Loader\.UI\|Loader\.Pkg" {} + 2>/dev/null | wc -l)
    if [ "$alias_count" -gt 0 ]; then
        echo "- **Path Aliasing:** ✅ Detected (Loader System)" >> "$SNAPSHOT_FILE"
    else
        echo "- **Path Aliasing:** ❌ Missing" >> "$SNAPSHOT_FILE"
        path_issues=$((path_issues + 1))
    fi
    
    # Recommendations
    echo "" >> "$SNAPSHOT_FILE"
    echo "### 💡 Path Management Recommendations" >> "$SNAPSHOT_FILE"
    if [ $path_issues -gt 0 ]; then
        echo "❌ **Critical Issues Found:**" >> "$SNAPSHOT_FILE"
        echo "- Implement centralized PathResolver service" >> "$SNAPSHOT_FILE"
        echo "- Replace hardcoded paths with alias system (@core, @ui, etc.)" >> "$SNAPSHOT_FILE"
    else
        echo "✅ Path management appears robust" >> "$SNAPSHOT_FILE"
    fi
    echo "" >> "$SNAPSHOT_FILE"
}

# [NEW] API Contract Analysis
analyze_api_contracts() {
    echo "## 📜 API Contract Analysis" >> "$SNAPSHOT_FILE"
    echo "" >> "$SNAPSHOT_FILE"
    
    local contract_issues=0
    local modules_with_contracts=0
    local modules_without_contracts=0
    
    echo "### 🔗 Module Contracts" >> "$SNAPSHOT_FILE"
    
    while IFS= read -r config; do
        module_name=$(basename $(dirname "$config"))
        
        # [FIX] Validasi Kontrak berdasarkan tabel Network/Requests di SharedConfig
        if grep -q "Network.*=" "$config" && grep -q "Requests.*=" "$config"; then
            modules_with_contracts=$((modules_with_contracts + 1))
            echo "- **$module_name:** ✅ Has Network Contract" >> "$SNAPSHOT_FILE"
            
            # Extract endpoint names
            grep -A10 "Requests.*=" "$config" | grep "=" | grep -v "Requests" | head -5 | while read -r line; do
                 # Simple extraction for display
                 endpoint=$(echo "$line" | cut -d'=' -f1 | xargs)
                 if [ -n "$endpoint" ] && [ "$endpoint" != "}" ]; then
                    echo "  - Endpoint: \`$endpoint\`" >> "$SNAPSHOT_FILE"
                 fi
            done
        else
            modules_without_contracts=$((modules_without_contracts + 1))
            echo "- **$module_name:** ❌ No Network Contract defined" >> "$SNAPSHOT_FILE"
            contract_issues=$((contract_issues + 1))
        fi
    done < <(find "${TARGET_DIRS[@]}" -name "SharedConfig.lua" -o -name "SharedConfig.luau" 2>/dev/null)
    
    echo "" >> "$SNAPSHOT_FILE"
    echo "### 📊 Contract Coverage" >> "$SNAPSHOT_FILE"
    echo "- **Modules with Contracts:** $modules_with_contracts" >> "$SNAPSHOT_FILE"
    echo "- **Modules without Contracts:** $modules_without_contracts" >> "$SNAPSHOT_FILE"
    
    if [ $contract_issues -gt 0 ]; then
        echo "❌ **Contract coverage needs improvement**" >> "$SNAPSHOT_FILE"
    else
        echo "✅ **Excellent contract coverage**" >> "$SNAPSHOT_FILE"
    fi
    echo "" >> "$SNAPSHOT_FILE"
}

# [NEW] UI System Analysis
analyze_ui_system() {
    echo "## 🎨 UI System Analysis" >> "$SNAPSHOT_FILE"
    echo "" >> "$SNAPSHOT_FILE"
    
    local ui_files=0
    local ui_components=0
    local fusion_detected=false
    local onyx_detected=false
    
    echo "### 🔍 UI Framework Detection" >> "$SNAPSHOT_FILE"
    
    # [FIXED LOGIC] Safe checks using wc -l instead of early-exit pipes to avoid SIGPIPE
    fusion_check=$(find "${TARGET_DIRS[@]}" -type f \( -name "*.lua" -o -name "*.luau" \) -exec grep -l "Loader.Pkg.*Fusion\|API\.Fusion\|API\.New" {} + 2>/dev/null | wc -l)
    if [ "$fusion_check" -gt 0 ]; then
        fusion_detected=true
        echo "- **Fusion UI:** ✅ Detected (via Loader/API)" >> "$SNAPSHOT_FILE"
    else
        echo "- **Fusion UI:** ❌ Not detected" >> "$SNAPSHOT_FILE"
    fi
    
    onyx_check=$(find "${TARGET_DIRS[@]}" -type f \( -name "*.lua" -o -name "*.luau" \) -exec grep -l "Loader.Pkg.*onyx\|API\.Onyx\|API\.Themer" {} + 2>/dev/null | wc -l)
    if [ "$onyx_check" -gt 0 ]; then
        onyx_detected=true
        echo "- **Onyx UI:** ✅ Detected (via Loader/API)" >> "$SNAPSHOT_FILE"
    else
        echo "- **Onyx UI:** ❌ Not detected" >> "$SNAPSHOT_FILE"
    fi
    
    # Count UI-related files (Safe Count)
    ui_files=$(find "${TARGET_DIRS[@]}" -type f \( -name "*.lua" -o -name "*.luau" \) -exec grep -l "ScreenGui\|TextLabel\|TextButton\|ImageButton\|Frame\|GridContainer\|SmartWindow" {} + 2>/dev/null | wc -l)
    ui_components=$(find "${TARGET_DIRS[@]}" -path "*/UI/*" -type f \( -name "*.lua" -o -name "*.luau" \) 2>/dev/null | wc -l)
    
    echo "" >> "$SNAPSHOT_FILE"
    echo "### 📊 UI System Metrics" >> "$SNAPSHOT_FILE"
    echo "- **UI-Related Files:** $ui_files" >> "$SNAPSHOT_FILE"
    echo "- **UI Components:** $ui_components" >> "$SNAPSHOT_FILE"
    
    # UI Architecture Assessment
    echo "" >> "$SNAPSHOT_FILE"
    echo "### 🏗️ UI Architecture Assessment" >> "$SNAPSHOT_FILE"
    
    if [ $ui_components -gt 0 ] && { [ "$fusion_detected" = true ] || [ "$onyx_detected" = true ]; }; then
        echo "✅ **Modern UI Architecture Detected**" >> "$SNAPSHOT_FILE"
        echo "- Component-based UI system" >> "$SNAPSHOT_FILE"
        echo "- Reactive framework integration" >> "$SNAPSHOT_FILE"
        echo "- Structured UI organization" >> "$SNAPSHOT_FILE"
    else
        echo "⚠️ **Potential Legacy UI Architecture**" >> "$SNAPSHOT_FILE"
    fi
    
    echo "" >> "$SNAPSHOT_FILE"
}

# [NEW] Enterprise Architecture Metrics
analyze_enterprise_metrics() {
    echo "## 🏢 Enterprise Architecture Metrics" >> "$SNAPSHOT_FILE"
    echo "" >> "$SNAPSHOT_FILE"
    
    local di_usage=0
    local service_count=0
    local module_count=0
    local config_count=0
    
    # Dependency Injection Usage
    di_usage=$(find "${TARGET_DIRS[@]}" -type f \( -name "*.lua" -o -name "*.luau" \) -exec grep -l "Context.New\|Context.V2" {} \; | wc -l)
    
    # Service Count
    service_count=$(find "${TARGET_DIRS[@]}" -path "*/Services/*" -type f \( -name "*.lua" -o -name "*.luau" \) | wc -l)
    
    # Module Count
    module_count=$(find "${TARGET_DIRS[@]}" -path "*/Modules/*" -type f \( -name "*.lua" -o -name "*.luau" \) | wc -l)
    
    # Config Count
    config_count=$(find "${TARGET_DIRS[@]}" -name "*Config*.lua" -o -name "*Config*.luau" | wc -l)

    # [ADD] Telemetry Check (Count)
    logger_usage=$(find "${TARGET_DIRS[@]}" -type f \( -name "*.lua" -o -name "*.luau" \) -exec grep -l "CreateLogger\|SmartLogger\.New" {} \; | wc -l)
    
    # [NEW] GRANULAR TELEMETRY DISPLAY
    echo "### 📡 Active Log Domains (Telemetry)" >> "$SNAPSHOT_FILE"
    echo "| Module/File | Logger Domain |" >> "$SNAPSHOT_FILE"
    echo "|-------------|---------------|" >> "$SNAPSHOT_FILE"
    grep -r -E "CreateLogger\([\"']([^\"']+)[\"']|SmartLogger\.New\([\"']([^\"']+)[\"']" "${TARGET_DIRS[@]}" --include="*.luau" --include="*.lua" | head -10 | while read -r line; do
        file=$(echo "$line" | cut -d: -f1 | xargs basename)
        domain=$(echo "$line" | grep -o -E "[\"'][^\"']+[\"']" | head -1 | tr -d "\"'")
        echo "| \`$file\` | **$domain** |" >> "$SNAPSHOT_FILE"
    done
    echo "" >> "$SNAPSHOT_FILE"

    echo "### 📈 Architecture Health Score" >> "$SNAPSHOT_FILE"
    echo "- **Dependency Injection Usage:** $di_usage files" >> "$SNAPSHOT_FILE"
    echo "- **Service Count:** $service_count services" >> "$SNAPSHOT_FILE"
    echo "- **Module Count:** $module_count modules" >> "$SNAPSHOT_FILE"
    echo "- **Configuration Files:** $config_count configs" >> "$SNAPSHOT_FILE"
    echo "- **Telemetry Coverage:** $logger_usage modules" >> "$SNAPSHOT_FILE"
    
    # Calculate health score (refined)
    local health_score=0
    if [ $di_usage -ge 2 ]; then ((health_score+=20)); fi
    if [ $service_count -ge 2 ]; then ((health_score+=20)); fi
    if [ $module_count -ge 2 ]; then ((health_score+=20)); fi
    if [ $config_count -ge 2 ]; then ((health_score+=20)); fi
    if [ $logger_usage -ge 4 ]; then ((health_score+=20)); fi
    
    echo "" >> "$SNAPSHOT_FILE"
    echo "### 🎯 Architecture Quality Assessment" >> "$SNAPSHOT_FILE"
    echo "- **Overall Health Score:** $health_score/100" >> "$SNAPSHOT_FILE"
    
    if [ $health_score -ge 75 ]; then
        echo "✅ **Enterprise Grade Architecture**" >> "$SNAPSHOT_FILE"
    elif [ $health_score -ge 50 ]; then
        echo "⚠️ **Good Foundation, Needs Polish**" >> "$SNAPSHOT_FILE"
    else
        echo "❌ **Needs Architecture Work**" >> "$SNAPSHOT_FILE"
    fi
    echo "" >> "$SNAPSHOT_FILE"
}

# [NEW] Deep Health Check Function
analyze_deep_health() {
    echo "## 🏥 Deep Health Check (Stability & Leaks)" >> "$SNAPSHOT_FILE"
    echo "" >> "$SNAPSHOT_FILE"
    
    # 1. ProfileService Memory Leak Check
    echo "### 🧠 ProfileService Safety Check" >> "$SNAPSHOT_FILE"
    local leak_risk=0
    while IFS= read -r file; do
        if grep -q "LoadProfileAsync" "$file"; then
            if ! grep -q ":Release()" "$file"; then
                 echo "- 🔴 **HIGH RISK:** \`$file\` loads Profile but never calls \`:Release()\` (Memory Leak)" >> "$SNAPSHOT_FILE"
                 leak_risk=$((leak_risk + 1))
            else
                 echo "- ✅ **Safe:** \`$file\` handles Profile Release correctly." >> "$SNAPSHOT_FILE"
            fi
        fi
    done < <(find "${TARGET_DIRS[@]}" -type f \( -name "*.lua" -o -name "*.luau" \) 2>/dev/null)
    if [ $leak_risk -eq 0 ]; then echo "No obvious ProfileService leaks detected." >> "$SNAPSHOT_FILE"; fi
    echo "" >> "$SNAPSHOT_FILE"

    # 2. Basic Circular Dependency Hint
    echo "### 🔄 Circular Dependency Heuristics" >> "$SNAPSHOT_FILE"
    if grep -r "require(script.Parent)" "${TARGET_DIRS[@]}" > /dev/null; then
        echo "- ⚠️ **Warning:** Detected \`require(script.Parent)\`. This pattern is fragile and can cause loops." >> "$SNAPSHOT_FILE"
    else
        echo "- ✅ No direct \`require(script.Parent)\` usage detected." >> "$SNAPSHOT_FILE"
    fi
    echo "" >> "$SNAPSHOT_FILE"
}

# [NEW] Enterprise Pre-flight
check_enterprise_readiness() {
    echo "## 🏢 Enterprise Readiness Checklist (Pre-flight)" >> "$SNAPSHOT_FILE"
    echo "" >> "$SNAPSHOT_FILE"
    
    echo "| Component | File Check | Status | Action Plan |" >> "$SNAPSHOT_FILE"
    echo "|-----------|------------|--------|-------------|" >> "$SNAPSHOT_FILE"
    
    if [ -d ".github/workflows" ]; then
        echo "| **CI/CD Pipeline** | \`.github/workflows\` | ✅ Ready | - |" >> "$SNAPSHOT_FILE"
    else
        echo "| **CI/CD Pipeline** | \`.github/workflows\` | ❌ Missing | Setup Github Actions |" >> "$SNAPSHOT_FILE"
    fi
    
    if [ -f "moonwave.toml" ]; then
        echo "| **Documentation** | \`moonwave.toml\` | ✅ Ready | - |" >> "$SNAPSHOT_FILE"
    else
        echo "| **Documentation** | \`moonwave.toml\` | ❌ Missing | Install Moonwave |" >> "$SNAPSHOT_FILE"
    fi
    echo "" >> "$SNAPSHOT_FILE"
}

# ==========================================
# MAIN EXECUTION
# ==========================================

echo -e "${YELLOW}Generating snapshot...${NC}"

# [UPGRADED] Write AI Context Header
cat > "$SNAPSHOT_FILE" << 'EOF'
---
type: project-snapshot  
purpose: AI Analysis & Debugging Context
generated_by: OVHL Audit Tool v2.1
---

# 🧠 OVHL FRAMEWORK INTERNALS (AI-TO-AI CONTEXT)

> **ATTENTION AI AGENT:** Read this architecture summary BEFORE analyzing the code.

### 1. Architecture Philosophy
- **Singleton Service Pattern:** All logic resides in Services (Server) or Controllers (Client).
- **Lifecycle:** `Init(ctx)` [Setup Phase] -> `Start()` [Runtime Phase].
- **Rule:** Never execute runtime logic (loops, events) in `Init`. Use `Start`.

### 2. Core Systems
- **Loader:** Uses `Proxy` metatables. `Loader.Pkg("Name")` fuzzy matches folders in `Packages`.
- **Bridge:** Networking Layer. Enforces `SharedConfig` contracts (Args type, Rate Limit).
- **Context:** Dependency Injection container passed to `Init`. Use `ctx:CreateLogger("DOMAIN")`.

---

# 📊 Project Snapshot

EOF

# Add enhanced metadata
cat >> "$SNAPSHOT_FILE" << EOF
**Generated:** $(date '+%Y-%m-%d %H:%M:%S')  
**Target Directories:** \`${TARGET_DIRS[*]}\`  
**Git Info:** $(get_git_info)  
$(count_folders_files)
$(analyze_distribution)
**Total Size:** $(get_total_size)

---

## 📁 Project Structure

EOF

# Generate tree for each directory
for dir in "${TARGET_DIRS[@]}"; do
    echo "\`\`\`" >> "$SNAPSHOT_FILE"
    generate_pretty_tree "$dir" >> "$SNAPSHOT_FILE"
    echo "\`\`\`" >> "$SNAPSHOT_FILE"
    echo "" >> "$SNAPSHOT_FILE"
done

# Add directory breakdown
echo "## 📂 Directory Overview" >> "$SNAPSHOT_FILE"
echo "" >> "$SNAPSHOT_FILE"

for target_dir in "${TARGET_DIRS[@]}"; do
    echo "### 📦 $target_dir" >> "$SNAPSHOT_FILE"
    echo "" >> "$SNAPSHOT_FILE"
    
    find "$target_dir" -type d | while read -r dir; do
        if [ "$dir" = "$target_dir" ]; then
            continue
        fi
        
        rel_dir=${dir#$target_dir/}
        file_count=$(find "$dir" -maxdepth 1 -type f \( -name "*.lua" -o -name "*.luau" \) 2>/dev/null | wc -l)
        
        if [ $file_count -gt 0 ]; then
            echo "- 📁 **$rel_dir**: $file_count Lua/Luau file(s)" >> "$SNAPSHOT_FILE"
        fi
    done
    echo "" >> "$SNAPSHOT_FILE"
done

echo "---" >> "$SNAPSHOT_FILE"
echo "" >> "$SNAPSHOT_FILE"

# Run enhanced analysis if requested
if [ "$ANALYZE_DEPS" = true ]; then
    echo -e "${YELLOW}Running enhanced dependency analysis...${NC}"
    analyze_smart_packages    # [MODIFIED] Smart Logic
    analyze_manifest_dependencies
    detect_race_conditions
    detect_security_issues
    generate_summary_stats
    
    # [NEW] Run advanced analyses
    if [ "$ANALYZE_PATHS" = true ]; then
        echo -e "${CYAN}Running advanced path analysis...${NC}"
        analyze_path_management # [MODIFIED] Whitelist Logic
        analyze_api_contracts
    fi
    
    if [ "$ANALYZE_UI" = true ]; then
        echo -e "${CYAN}Running UI system analysis...${NC}"
        analyze_ui_system
    fi
    
    # [NEW] Always run enterprise metrics for comprehensive analysis
    echo -e "${CYAN}Running enterprise architecture metrics...${NC}"
    analyze_enterprise_metrics # [MODIFIED] Granular Telemetry
    analyze_deep_health        # [NEW] Deep Check
    check_enterprise_readiness # [NEW] Pre-flight
fi

# Generate compact or full snapshot
if [ "$COMPACT_MODE" = true ]; then
    echo -e "${YELLOW}Compact mode: Structure only${NC}"
    echo "## 📄 Lua/Luau Files List" >> "$SNAPSHOT_FILE"
    echo "" >> "$SNAPSHOT_FILE"
    
    for target_dir in "${TARGET_DIRS[@]}"; do
        echo "### 📦 $target_dir" >> "$SNAPSHOT_FILE"
        echo "" >> "$SNAPSHOT_FILE"
        find "$target_dir" -type f \( -name "*.lua" -o -name "*.luau" \) | sort | while read -r file; do
            rel_path=${file}
            size=$(wc -l < "$file")
            echo "- 🌙 \`$rel_path\` ($(format_lines $size))" >> "$SNAPSHOT_FILE"
        done
        echo "" >> "$SNAPSHOT_FILE"
    done
else
    echo -e "${YELLOW}Full mode: Including file contents with line numbers${NC}"
    
    echo "## 📚 Complete Codebase" >> "$SNAPSHOT_FILE"
    echo "" >> "$SNAPSHOT_FILE"
    
    for target_dir in "${TARGET_DIRS[@]}"; do
        echo "### 📦 $target_dir/" >> "$SNAPSHOT_FILE"
        echo "" >> "$SNAPSHOT_FILE"
        
        # Get all Lua files
        files=()
        while IFS= read -r file; do
            # Check exclusion patterns
            filename=$(basename "$file")
            excluded=false
            for pattern in "${EXCLUDE_PATTERNS[@]}"; do
                if [[ "$filename" == $pattern ]]; then
                    excluded=true
                    break
                fi
            done
            if [ "$excluded" = false ]; then
                files+=("$file")
            fi
        done < <(find "$target_dir" -type f \( -name "*.lua" -o -name "*.luau" \) | sort)
        
        total_files=${#files[@]}
        current_file=0
        
        # Safety limit
        if [ $total_files -gt $MAX_TOTAL_FILES ]; then
            echo "⚠️ **Too many files ($total_files), processing first $MAX_TOTAL_FILES**" >> "$SNAPSHOT_FILE"
            total_files=$MAX_TOTAL_FILES
        fi
        
        for file in "${files[@]:0:$MAX_TOTAL_FILES}"; do
            current_file=$((current_file + 1))
            rel_path=${file}
            line_count=$(wc -l < "$file" 2>/dev/null || echo 0)
            size=$(wc -c < "$file" 2>/dev/null || echo 0)
            
            echo -ne "  ${CYAN}Processing:${NC} $current_file/$total_files ($((current_file * 100 / total_files))%) - ${PURPLE}$rel_path${NC}\r"
            
            echo "<details>" >> "$SNAPSHOT_FILE"
            echo "<summary><strong>🌙 $rel_path</strong> ($(format_lines $line_count), $(format_size $size))</summary>" >> "$SNAPSHOT_FILE"
            echo "" >> "$SNAPSHOT_FILE"
            echo "**Full Path:** \`$file\`" >> "$SNAPSHOT_FILE"
            echo "" >> "$SNAPSHOT_FILE"
            echo "\`\`\`lua" >> "$SNAPSHOT_FILE"
            
            if [ "$TRUNCATE_LARGE" = true ] && [ $line_count -gt $MAX_FILE_LINES ]; then
                echo "⚠️ **TRUNCATED:** Showing first 60% and last 40% of $(format_lines $line_count)" >> "$SNAPSHOT_FILE"
                truncate_file_with_lines "$file" $MAX_FILE_LINES >> "$SNAPSHOT_FILE"
            else
                add_line_numbers "$file" >> "$SNAPSHOT_FILE"
            fi
            
            echo "\`\`\`" >> "$SNAPSHOT_FILE"
            echo "" >> "$SNAPSHOT_FILE"
            echo "</details>" >> "$SNAPSHOT_FILE"
            echo "" >> "$SNAPSHOT_FILE"
        done
        echo -e "\n" >> "$SNAPSHOT_FILE"
    done
fi

# Generate diff if requested
if [ "$SHOW_DIFF" = true ]; then
    echo -e "${YELLOW}Checking for previous snapshot...${NC}"
    LAST_SNAPSHOT=$(find "$EXPORT_BASE" -name "snapshot-*.md" -type f ! -path "$SNAPSHOT_FILE" | sort -r | head -n 1)
    
    if [ -n "$LAST_SNAPSHOT" ]; then
        echo -e "${GREEN}Found previous snapshot:${NC} $(basename $LAST_SNAPSHOT)"
        echo "" >> "$SNAPSHOT_FILE"
        echo "---" >> "$SNAPSHOT_FILE"
        echo "" >> "$SNAPSHOT_FILE"
        echo "## 📊 Changes Since Last Snapshot" >> "$SNAPSHOT_FILE"
        echo "" >> "$SNAPSHOT_FILE"
        echo "**Previous:** \`$(basename $LAST_SNAPSHOT)\`" >> "$SNAPSHOT_FILE"
        echo "" >> "$SNAPSHOT_FILE"
        
        if git rev-parse --git-dir > /dev/null 2>&1; then
            echo "### 📋 Git Changes" >> "$SNAPSHOT_FILE"
            echo "\`\`\`diff" >> "$SNAPSHOT_FILE"
            git diff --stat >> "$SNAPSHOT_FILE" 2>/dev/null || echo "No git changes detected" >> "$SNAPSHOT_FILE"
            echo "\`\`\`" >> "$SNAPSHOT_FILE"
        else
            echo "*Git not available for diff*" >> "$SNAPSHOT_FILE"
        fi
    else
        echo -e "${YELLOW}No previous snapshot found${NC}"
    fi
fi

# Add footer with AI instructions
cat >> "$SNAPSHOT_FILE" << 'EOF'

---

## 🎯 AI Quick Reference

### Common Analysis Tasks:

1. **🐛 Debug Error**
   - Locate the error message in the relevant file (use line numbers!)
   - Check surrounding context and dependencies  
   - Suggest fixes with specific line numbers

2. **📝 Code Review**
   - Check for best practices and patterns
   - Identify potential bugs or improvements
   - Suggest refactoring opportunities

3. **🗂️ Architecture Analysis**
   - Review module organization  
   - Check separation of concerns (client/server/shared)
   - Validate dependency graphs and race conditions

4. **📚 Documentation**
   - Identify undocumented functions
   - Suggest comments for complex logic
   - Generate API documentation

### File Organization:
- **src/StarterPlayer/StarterPlayerScripts/OVHL/**: Client-side code (runs on player's game client)
- **src/ServerScriptService/OVHL/**: Server-side code (runs on game server)  
- **src/ReplicatedStorage/OVHL/**: Shared code (accessible by both client and server)
- **tests/**: Test files for automated testing

---

*Generated by OVHL Framework ULTIMATE Snapshot Tool*
EOF

# Final summary
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✅ ULTIMATE snapshot generated successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}File created:${NC}"
echo -e "  📄 $SNAPSHOT_FILE"
echo ""
echo -e "${CYAN}Snapshot includes:${NC}"
echo -e "  📊 Enhanced metrics (size distribution, file counts, line counts)"
if [ "$ANALYZE_DEPS" = true ]; then
    echo -e "  📦 Smart External Package Detection"
    echo -e "  🔗 Dependency analysis (circular deps, race conditions)" 
    echo -e "  🛡️ Security analysis (client-side permission checks)"
    echo -e "  📈 Summary statistics (top files, size distribution)"
fi
if [ "$ANALYZE_PATHS" = true ]; then
    echo -e "  🗺️ Advanced path management analysis"
    echo -e "  📜 API contract validation"
fi
if [ "$ANALYZE_UI" = true ]; then
    echo -e "  🎨 UI system detection and analysis"
fi
if [ "$TRUNCATE_LARGE" = true ]; then
    echo -e "  ✂️  Smart truncation (files > $MAX_FILE_LINES lines)"
fi
echo -e "  🏢 Enterprise architecture metrics"
echo -e "  📁 Full project structure with exclusions"
if [ "$COMPACT_MODE" = false ]; then
    echo -e "  📚 Complete codebase with line numbers"
fi
echo -e "  🔢 Line numbers for easy reference"
echo ""
echo -e "${BLUE}Quick commands:${NC}"
echo -e "  View: ${YELLOW}cat $SNAPSHOT_FILE | head -50${NC}"
echo -e "  Check size: ${YELLOW}ls -lh $SNAPSHOT_FILE${NC}"
echo -e "  Open: ${YELLOW}code $SNAPSHOT_FILE${NC}"
echo ""

# Statistics
SNAPSHOT_SIZE=$(du -h "$SNAPSHOT_FILE" | cut -f1)
SNAPSHOT_LINES=$(wc -l < "$SNAPSHOT_FILE")
echo -e "${BLUE}Snapshot stats:${NC} $SNAPSHOT_SIZE, $SNAPSHOT_LINES lines"
echo -e "${BLUE}Ready for AI upload!${NC} 🚀"

# Cleanup old snapshots (keep last 10)
echo -e "${YELLOW}Cleaning up old snapshots...${NC}"
find "$EXPORT_BASE" -name "snapshot-*.md" -type f | sort -r | tail -n +11 | xargs rm -f 2>/dev/null || true
echo -e "${GREEN}Cleanup complete!${NC}"

# Final message
echo ""
echo -e "${PURPLE}========================================${NC}"
echo -e "${PURPLE}🎉 ENHANCED ULTIMATE SNAPSHOT READY!${NC}"
echo -e "${PURPLE}========================================${NC}"
echo -e "${CYAN}Next: Upload to AI and use the enterprise analysis prompt!${NC}"
echo ""