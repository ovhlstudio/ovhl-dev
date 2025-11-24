export const LuaUtils = {
    // Menghapus komentar Lua (--... dan --[[ ... ]]) agar Regex tidak tertipu
    stripComments(code: string): string {
        return code
            .replace(/--\[\[[\s\S]*?\]\]/g, '') // Block comment
            .replace(/--.*/g, '');             // Single line comment
    },

    // Mengekstrak nama module dari require
    // require(game.ReplicatedStorage.OVHL...) -> OVHL
    extractRequirePath(line: string): string | null {
        const match = line.match(/require\(([^)]+)\)/);
        return match ? match[1] : null;
    }
};