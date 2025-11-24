import fs from 'fs-extra';
import path from 'path';
import stripJsonComments from 'strip-json-comments';

interface RojoNode {
    $path?: string;
    $className?: string;
    [key: string]: any;
}

export class RojoService {
    private projectMap: Map<string, string> = new Map();
    private rootDir: string;
    public isLoaded = false;

    constructor(rootDir: string) {
        this.rootDir = rootDir;
    }

    async loadProject(projectFileName = 'default.project.json') {
        const projectPath = path.join(this.rootDir, projectFileName);
        if (!fs.existsSync(projectPath)) return;

        try {
            const content = await fs.readFile(projectPath, 'utf-8');
            const json = JSON.parse(stripJsonComments(content));
            this.parseTree(json.tree, ["game"]);
            this.isLoaded = true;
        } catch (e) {
            console.error("❌ Failed to parse Rojo project:", e);
        }
    }

    private parseTree(node: RojoNode, currentRobloxPath: string[]) {
        if (!node) return;
        if (node.$path) {
            const diskPath = path.resolve(this.rootDir, node.$path);
            const robloxPath = currentRobloxPath.join('.');
            this.projectMap.set(diskPath, robloxPath);
        }
        for (const key in node) {
            if (key.startsWith('$')) continue;
            this.parseTree(node[key], [...currentRobloxPath, key]);
        }
    }

    public getRobloxPath(diskPath: string): string | null {
        const absolutePath = path.resolve(diskPath);
        const sortedKeys = Array.from(this.projectMap.keys()).sort((a, b) => b.length - a.length);

        for (const registeredPath of sortedKeys) {
            if (absolutePath.startsWith(registeredPath)) {
                const baseRoblox = this.projectMap.get(registeredPath);
                if (!baseRoblox) continue;

                const relative = path.relative(registeredPath, absolutePath);
                const luaSuffix = relative
                    .replace(/(\.luau|\.lua)$/, '')
                    .replace(/init$/, '')
                    .split(path.sep)
                    .filter(Boolean)
                    .join('.');

                if (!luaSuffix) return baseRoblox;
                if (baseRoblox.endsWith('.')) return baseRoblox + luaSuffix;
                return baseRoblox + '.' + luaSuffix;
            }
        }
        return null; 
    }

    public getGroup(diskPath: string): string {
        const relativeToRoot = path.relative(this.rootDir, diskPath);
        if (!relativeToRoot.includes(path.sep)) return 'Automation / Root';

        const rbx = this.getRobloxPath(diskPath);
        if (!rbx) {
            if (diskPath.includes('tests')) return 'Tests (Misc)';
            return 'Unknown';
        }

        if (rbx.toLowerCase().includes('.tests') || diskPath.includes('.spec')) {
            if (rbx.startsWith('game.ReplicatedStorage')) return 'Tests (Shared)';
            if (rbx.startsWith('game.ServerScriptService') || rbx.startsWith('game.ServerStorage')) return 'Tests (Server)';
            if (rbx.startsWith('game.StarterPlayer') || rbx.startsWith('game.StarterGui')) return 'Tests (Client)';
            return 'Tests (Misc)';
        }

        if (rbx.startsWith('game.ServerScriptService') || rbx.startsWith('game.ServerStorage')) return 'Server';
        if (rbx.startsWith('game.StarterPlayer') || rbx.startsWith('game.StarterGui')) return 'Client';
        if (rbx.startsWith('game.ReplicatedStorage') || rbx.startsWith('game.ReplicatedFirst')) return 'Shared';
        
        return 'Unknown';
    }

    // 🔥 REAL DATA GENERATOR
    public getMappingTable(): string {
        if (this.projectMap.size === 0) return '> *No Rojo mapping loaded.*';

        let md = '| Source Folder (Disk) | Roblox Service (Virtual) |\n|---|---|\n';
        
        // Sort by path name for neatness
        const entries = Array.from(this.projectMap.entries())
            .sort((a, b) => a[1].localeCompare(b[1]));

        for (const [disk, rbx] of entries) {
            // Convert absolute path to relative for display
            const relDisk = path.relative(this.rootDir, disk).replace(/\\/g, '/');
            md += `| \`${relDisk}\` | \`${rbx}\` |\n`;
        }
        return md;
    }
}