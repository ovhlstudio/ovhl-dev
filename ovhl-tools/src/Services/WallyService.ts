import fs from 'fs-extra';
import path from 'path';

export class WallyService {
    private root: string;
    public packages: Map<string, string> = new Map();

    constructor(root: string) {
        this.root = root;
    }

    async scan() {
        const wallyPath = path.join(this.root, 'wally.toml');
        if (fs.existsSync(wallyPath)) {
            try {
                const content = await fs.readFile(wallyPath, 'utf-8');
                this.parseSimpleToml(content);
            } catch (e) {
                console.error("Failed to read wally.toml", e);
            }
        }
    }

    private parseSimpleToml(content: string) {
        const lines = content.split('\n');
        let inDependencies = false;

        for (const line of lines) {
            const trimmed = line.trim();
            if (!trimmed || trimmed.startsWith('#')) continue;

            if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
                if (trimmed === '[dependencies]') {
                    inDependencies = true;
                } else {
                    inDependencies = false;
                }
                continue;
            }

            if (inDependencies) {
                const match = trimmed.match(/^([a-zA-Z0-9_\-]+)\s*=\s*(.+)$/);
                if (match) {
                    const key = match[1];
                    const val = match[2].replace(/['"]/g, '');
                    this.packages.set(key, val);
                }
            }
        }
    }

    isUsed(pkgName: string, codebase: string): boolean {
        // FIX: Escape BOTH parentheses correctly for Regex
        // Target Regex: /Loader.Pkg(["']PkgName["'])/i
        const regex = new RegExp(`Loader\\.Pkg\\(["']${pkgName}["']\\)`, 'i');
        return regex.test(codebase);
    }
}