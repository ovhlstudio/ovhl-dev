#!/bin/bash
set -uo pipefail

# --- LOAD CONFIG & LIBS ---
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR"

source config.env
source lib/globals.sh
source lib/utils.sh
source lib/file_ops.sh
source lib/reporter.sh

# Load Modules
for mod in modules/*.sh; do source "$mod"; done

# --- DEFAULT CONFIG ---
DO_FULL_SCAN=true      
DO_CODE_DUMP=true      
REPORT_DIR="reports/$(date +%Y-%m-%d)"
TIMESTAMP="$(date +%d%m%y-%H-%M-%S)"

# --- HELPER: SHOW MENU ---
show_menu() {
    clear
    echo -e "${CYAN}=============================================${NC}"
    echo -e "${CYAN}   🕵️  OVHL AUDIT TOOL V3.5 (STRICT MODE)    ${NC}"
    echo -e "${CYAN}=============================================${NC}"
    echo ""
    echo "Pilih Mode Audit:"
    echo -e "  ${GREEN}[1] 🚀 FULL AUDIT (Default)${NC}"
    echo "      - Deep Analysis (Security, Arch, UI)"
    echo "      - Complete Source Code Dump (Grouped)"
    echo ""
    echo -e "  ${YELLOW}[2] 📉 COMPACT AUDIT${NC}"
    echo "      - Deep Analysis Only"
    echo "      - NO Source Code Dump (Hasil report kecil)"
    echo ""
    echo -e "  ${RED}[3] 🛡️  SECURITY SWEEP${NC}"
    echo "      - Focus on Race Conditions & Vulnerabilities"
    echo "      - Fast Execution"
    echo ""
    echo -e "  ${BLUE}[4] 📁 STATS ONLY${NC}"
    echo "      - Just structure and lines count"
    echo ""
    echo -n "Pilihan Anda [1-4] (Enter = Full): "
    read -r choice

    case $choice in
        2) 
            DO_FULL_SCAN=true; DO_CODE_DUMP=false; 
            echo -e "${YELLOW}>> Selected: Compact Mode${NC}"
            ;;
        3) 
            DO_FULL_SCAN="sec_only"; DO_CODE_DUMP=false;
            echo -e "${RED}>> Selected: Security Sweep${NC}"
            ;;
        4) 
            DO_FULL_SCAN=false; DO_CODE_DUMP=false;
            echo -e "${BLUE}>> Selected: Stats Only${NC}"
            ;;
        *) 
            echo -e "${GREEN}>> Selected: Full Audit${NC}" 
            ;;
    esac
    echo ""
}

# --- HELPER: SHOW HELP ---
show_help() {
    echo "Usage: ./audit.sh [options]"
    echo ""
    echo "Options:"
    echo "  -f, --full       Full Audit + Code Dump (Default)"
    echo "  -c, --compact    Compact Audit (No Code Dump)"
    echo "  -s, --security   Security Scan Only"
    echo "  -h, --help       Show this help"
    echo ""
    echo "Running without arguments will launch Interactive Mode."
}

# --- MAIN ARGUMENT PARSER ---
if [ $# -eq 0 ]; then
    show_menu
else
    while [[ $# -gt 0 ]]; do
        case $1 in
            -c|--compact)
                DO_CODE_DUMP=false
                shift
                ;;
            -s|--security)
                DO_FULL_SCAN="sec_only"
                DO_CODE_DUMP=false
                shift
                ;;
            -f|--full)
                DO_FULL_SCAN=true
                DO_CODE_DUMP=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                exit 1
                ;;
        esac
    done
fi

# --- GENERATE FILENAME ---
mkdir -p "$REPORT_DIR"
SUFFIX=""
if [ "$DO_CODE_DUMP" = false ]; then SUFFIX="-compact"; fi
if [ "$DO_FULL_SCAN" = "sec_only" ]; then SUFFIX="-security"; fi

REPORT_FILE="$REPORT_DIR/ovhl-snapshot-${TIMESTAMP}${SUFFIX}.md"

echo -e "${CYAN}Executing Audit...${NC}"
echo -e "Target Root: ${YELLOW}$TARGET_ROOT${NC}"
echo -e "Scan Scope:  ${YELLOW}${SCAN_DIRS[*]}${NC}"
echo -e "Output:      ${YELLOW}$REPORT_FILE${NC}"
echo "-------------------------------------"

# --- PHASE 1: HEADER & STATS (ALWAYS RUN) ---
write_header "$REPORT_FILE"
echo -e "1/8 📊 Analyzing Statistics..."; run_stats "$REPORT_FILE"

# --- PHASE 2: LOGIC SCAN ---
if [ "$DO_FULL_SCAN" = true ]; then
    echo -e "2/8 🔗 Mapping Dependencies...";    run_dependencies "$REPORT_FILE"
    echo -e "3/8 🛡️  Running Deep Security...";   run_security "$REPORT_FILE"
    echo -e "4/8 🧹 Checking Code Quality...";    run_code_quality "$REPORT_FILE"
    echo -e "5/8 🎨 Analyzing UI System...";      run_ui_analysis "$REPORT_FILE"
    echo -e "6/8 ⚖️  Final Scoring...";           run_architecture "$REPORT_FILE"
    echo -e "7.5 📡 Analyzing Telemetry...";      run_telemetry "$REPORT_FILE"
    echo -e "7.8 🕰️  Checking History...";        run_history_comparison "$REPORT_FILE"

elif [ "$DO_FULL_SCAN" = "sec_only" ]; then
    echo -e "Skipping general analysis..."
    echo -e "⚔️ 🛡️  Running DEEP SECURITY Scan..."; run_security "$REPORT_FILE"
    run_code_quality "$REPORT_FILE" 
fi

# --- PHASE 3: CODE DUMP (SMART GROUPED & STRICT) ---
if [ "$DO_CODE_DUMP" = true ]; then
    echo -e "8/8 📝 Dumping Codebase (Categorized & Strict)..."
    write_section "$REPORT_FILE" "📚 Complete Codebase Snapshot"

    dump_group() {
        local title=$1; local regex=$2
        echo -e "\n### $title\n" >> "$REPORT_FILE"
        
        # Loop SCAN_DIRS (src, tests) agar tidak bocor ke root
        for dir in "${SCAN_DIRS[@]}"; do
            local search_path="$TARGET_ROOT/$dir"
            
            if [ -d "$search_path" ]; then
                # Support .luau AND .lua
                find "$search_path" -type f \( -name "*.luau" -o -name "*.lua" \) | \
                grep -E "$regex" | sort | while read -r file; do
                    
                    local name=$(basename "$file")
                    if ! check_exclusion "$name"; then
                        local rel_path="${file#$TARGET_ROOT/}"
                        smart_dump_file "$file" "$rel_path" >> "$REPORT_FILE"
                    fi
                done
            fi
        done
    }

    # [REGEX UPDATE] Pake ^ (start of string) + TARGET_ROOT + /src/
    # Biar ReplicatedStorage di dalam Tests gak ketarik disini
    echo "    - Group: Shared"
    dump_group "🔄 Shared & Replicated" "^$TARGET_ROOT/src/ReplicatedStorage/|^$TARGET_ROOT/src/ReplicatedFirst/"
    
    echo "    - Group: Server"
    dump_group "🖥️ Server Logic" "^$TARGET_ROOT/src/ServerScriptService/|^$TARGET_ROOT/src/ServerStorage/"
    
    echo "    - Group: Client"
    dump_group "🎮 Client Logic" "^$TARGET_ROOT/src/StarterPlayer/|^$TARGET_ROOT/src/StarterGui/|^$TARGET_ROOT/src/StarterPack/"
    
    echo "    - Group: Tests"
    dump_group "🧪 Unit Tests" "^$TARGET_ROOT/tests/" 
    
    # Misc Fallback (Strict Mode)
    for dir in "${SCAN_DIRS[@]}"; do
        find "$TARGET_ROOT/$dir" -type f \( -name "*.luau" -o -name "*.lua" \) | \
        grep -vE "ReplicatedStorage|ReplicatedFirst|ServerScriptService|ServerStorage|StarterPlayer|StarterGui|StarterPack|tests/" | \
        sort | while read -r file; do
            local name=$(basename "$file")
            if ! check_exclusion "$name"; then
                smart_dump_file "$file" "${file#$TARGET_ROOT/}" >> "$REPORT_FILE"
            fi
        done
    done
else
    echo "🚫 Code Dumping Skipped (Compact Mode)"
    echo -e "\n> **Note:** Code snapshot skipped in Compact Mode.\n" >> "$REPORT_FILE"
fi

write_footer "$REPORT_FILE"
echo -e "${GREEN}✅ DONE! Report: $REPORT_FILE${NC}"