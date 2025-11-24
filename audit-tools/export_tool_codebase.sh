#!/bin/bash

# Nama Output File
OUTPUT_FILE="audit_tools_context.txt"

# Folder ini sendiri (audit-tools)
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Header File TXT
echo "==============================================================================" > "$OUTPUT_FILE"
echo "🤖 CONTEXT FOR AI: EXISTING BASH AUDIT TOOL ARCHITECTURE" >> "$OUTPUT_FILE"
echo "Generated: $(date)" >> "$OUTPUT_FILE"
echo "Goal: Analyze this legacy codebase for porting to Node.js" >> "$OUTPUT_FILE"
echo "==============================================================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# 1. EXPORT STRUKTUR FOLDER (Tree View)
echo "##############################################################################" >> "$OUTPUT_FILE"
echo "📂 SECTION 1: DIRECTORY STRUCTURE (audit-tools/)" >> "$OUTPUT_FILE"
echo "##############################################################################" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Menggunakan find + sed untuk simulasi 'tree' command (biar jalan di git bash minimalis)
# Exclude .git, reports (biar gak kepanjangan), dan file output ini sendiri
cd "$CURRENT_DIR"
find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g' \
    | grep -v ".git" \
    | grep -v "$OUTPUT_FILE" \
    | grep -v "reports/" >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"

# 2. EXPORT ISI FILE (Codebase Dump)
echo "##############################################################################" >> "$OUTPUT_FILE"
echo "📝 SECTION 2: FILE CONTENTS" >> "$OUTPUT_FILE"
echo "##############################################################################" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Fungsi Helper buat Dump
dump_file() {
    local filepath=$1
    echo "------------------------------------------------------------------------------" >> "$OUTPUT_FILE"
    echo "FILE PATH: $filepath" >> "$OUTPUT_FILE"
    echo "------------------------------------------------------------------------------" >> "$OUTPUT_FILE"
    cat "$filepath" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE" # Newline separator
}

# Cari semua file .sh dan .env (Codebase Audit Tool)
# Kita skip folder reports/ karena itu hasil generate, bukan source code
find . -type f \( -name "*.sh" -o -name "*.env" \) -not -path '*/.git/*' -not -path '*/reports/*' | sort | while read -r file; do
    dump_file "$file"
done

echo "✅ Export Selesai: $OUTPUT_FILE"
echo "📂 Lokasi: $CURRENT_DIR/$OUTPUT_FILE"