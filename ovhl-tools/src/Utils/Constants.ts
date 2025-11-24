export const CONSTANTS = {
    PENALTIES: {
        RACE_CONDITION: 20,
        GLOBAL_STATE: 5,
        HARDCODED_PATH: 5,
        MISSING_DOCS: 10
    },
    PATTERNS: {
        // Regex yang lebih pintar (akan dipakai di Phase 2)
        LUA_COMMENT: /--\[\[.*?\]\]|--.*/g,
        SERVICE_DEF: /Request\s*=\s*\{/,
        GLOBAL_VAR: /^local\s+([A-Z][A-Za-z0-9_]*)\s*=\s*\{/
    }
};