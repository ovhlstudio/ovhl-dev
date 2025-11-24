import fastGlob from 'fast-glob';
import fs from 'fs-extra';
import path from 'path';
import { IFeature } from '../IFeature.js';
import { Context } from '../../Core/Context.js';
import { TextUtils } from '../../Utils/TextUtils.js';

export default class SmartSnapshot implements IFeature {
    id = '99_Snapshot';
    name = '📝 Codebase Snapshot';
    description = 'Dumps source code with smart grouping';

    async run(ctx: Context): Promise<void> {
        const root = ctx.data.rootPath;
        const maxLines = ctx.data.config.audit?.maxSnapshotLines || 1000;
        const ignorePatterns = ctx.data.config.audit?.ignore || [];

        const files = await fastGlob(
            ['**/*.{lua,luau}'], 
            { cwd: root, ignore: ignorePatterns }
        );

        // Initialize ALL groups explicitly
        const groups: Record<string, string[]> = {
            'Shared': [],
            'Server': [],
            'Client': [],
            'Tests (Shared)': [],
            'Tests (Server)': [],
            'Tests (Client)': [],
            'Automation / Root': [],
            'Unknown': []
        };

        for (const file of files) {
            const fullPath = path.join(root, file);
            let groupName = ctx.services.rojo.getGroup(fullPath);
            
            // Fallback for weird groups
            if (!groups[groupName]) {
                if (groupName.includes('Tests')) groupName = 'Tests (Misc)';
                else groupName = 'Unknown';
            }

            const rawContent = await fs.readFile(fullPath, 'utf-8');
            const size = (await fs.stat(fullPath)).size;
            const lineCount = rawContent.split('\n').length;
            const processedContent = TextUtils.smartTruncate(rawContent, maxLines, file);
            const virtualPath = ctx.services.rojo.getRobloxPath(fullPath) || 'Unmapped';

            const block = `
<details>
<summary><strong>🌙 ${file}</strong> (${lineCount} lines, ${TextUtils.formatBytes(size)})</summary>

**Rojo Path:** \`${virtualPath}\`

\`\`\`lua
${processedContent}
\`\`\`
</details>
`;
            groups[groupName].push(block);
        }

        let md = '';
        // Define Display Order
        const order = [
            'Shared', 'Server', 'Client', 
            'Tests (Shared)', 'Tests (Server)', 'Tests (Client)', 
            'Automation / Root', 'Unknown'
        ];
        
        for (const grp of order) {
            md += `\n### 📦 Group: ${grp}\n\n`;
            
            if (groups[grp] && groups[grp].length > 0) {
                md += groups[grp].join('\n');
            } else {
                // FIX: Explicitly state if empty
                md += '> *(No files found in this category)*\n';
            }
        }

        ctx.addSection(this.id, '📚 Complete Codebase Snapshot', md);
    }
}