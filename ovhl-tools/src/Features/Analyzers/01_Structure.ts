import fastGlob from 'fast-glob';
import fs from 'fs-extra';
import path from 'path';
import { IFeature } from '../IFeature.js';
import { Context } from '../../Core/Context.js';
import { TextUtils } from '../../Utils/TextUtils.js';

export default class StructureAnalyzer implements IFeature {
    id = '01_Structure';
    name = '📊 Project Structure & Stats';
    description = 'Counts files and generates full scaffold tree (including empty folders)';

    async run(ctx: Context): Promise<void> {
        const root = ctx.data.rootPath;
        const ignorePatterns = ctx.data.config.audit?.ignore || ['**/Packages/**', '**/_Index/**', '**/node_modules/**'];

        const folders = await fastGlob(['**/**'], { cwd: root, onlyDirectories: true, ignore: ignorePatterns });
        const files = await fastGlob(['**/*.{lua,luau}'], { cwd: root, ignore: ignorePatterns });

        let totalSize = 0;
        let totalLines = 0;
        
        const stats = {
            Server: { count: 0, lines: 0 },
            Client: { count: 0, lines: 0 },
            Shared: { count: 0, lines: 0 },
            Tests:  { count: 0, lines: 0 },
            Unknown:{ count: 0, lines: 0 }
        };

        const treeStructure: any = {};

        for (const folder of folders) {
            const parts = folder.split('/');
            let current = treeStructure;
            for (const part of parts) {
                if (!current[part]) current[part] = { '__type': 'folder' };
                current = current[part];
            }
        }

        for (const file of files) {
            const fullPath = path.join(root, file);
            const content = await fs.readFile(fullPath, 'utf-8');
            const stat = await fs.stat(fullPath);
            const lines = content.split('\n').length;

            totalSize += stat.size;
            totalLines += lines;

            const group = ctx.services.rojo.getGroup(fullPath);
            let statKey = 'Unknown';
            if (group.includes('Server')) statKey = 'Server';
            else if (group.includes('Client')) statKey = 'Client';
            else if (group.includes('Shared')) statKey = 'Shared';
            else if (group.includes('Test')) statKey = 'Tests';

            if (stats[statKey]) {
                stats[statKey].count++;
                stats[statKey].lines += lines;
            }

            const parts = file.split('/');
            let current = treeStructure;
            for (let i = 0; i < parts.length; i++) {
                const part = parts[i];
                if (!current[part]) current[part] = { '__type': 'folder' };
                if (i === parts.length - 1) current[part]['__type'] = 'file';
                current = current[part];
            }
        }

        const treeString = this.generateAsciiTree(treeStructure);

        let md = '### 📦 Statistics Summary\n\n';
        md += '| Metric | Value |\n|---|---|\n';
        md += `| **Files** | ${files.length} |\n`;
        md += `| **Folders** | ${folders.length} |\n`;
        md += `| **Lines** | ${totalLines} |\n`;
        md += `| **Size** | ${TextUtils.formatBytes(totalSize)} |\n\n`;

        md += '### 🗺️ Distribution\n\n';
        md += '| Scope | Files | Lines |\n|---|---|---|\n';
        for (const [key, val] of Object.entries(stats)) {
            if (val.count > 0) md += `| **${key}** | ${val.count} | ${val.lines} |\n`;
        }

        md += '\n### 🌳 Project Scaffold\n';
        // [VISUAL FIX] Use Tilde (~~~) instead of backticks to prevent nested code block issues
        md += `~~~text\n${treeString}\n~~~`;
        
        md += '\n> **👮‍♂️ OVHL LAW: STRUCTURE**\n';
        md += '> *   **Server:** Logic that never trusts the client (DB, Auth).\n';
        md += '> *   **Client:** Visuals & Input handling only.\n';
        md += '> *   **Shared:** Configs, Constants, & Utility functions.\n';

        ctx.addSection(this.id, '📁 Project Structure', md);
    }

    private generateAsciiTree(tree: any, prefix = ''): string {
        let output = '';
        const keys = Object.keys(tree).filter(k => k !== '__type').sort();
        keys.forEach((key, index) => {
            const isLast = index === keys.length - 1;
            const connector = isLast ? '└── ' : '├── ';
            const childPrefix = isLast ? '    ' : '│   ';
            const node = tree[key];
            const isFile = node['__type'] === 'file';
            const icon = isFile ? '🌙' : '📁';
            output += `${prefix}${connector}${icon} ${key}\n`;
            const children = Object.keys(node).filter(k => k !== '__type');
            if (!isFile && children.length > 0) output += this.generateAsciiTree(node, prefix + childPrefix);
        });
        return output;
    }
}