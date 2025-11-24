import fs from 'fs-extra';
import path from 'path';
import fastGlob from 'fast-glob'; // 🔥 FIX: Top-level Import
import { IFeature } from '../IFeature.js';
import { Context } from '../../Core/Context.js';
import { GitService } from '../../Services/GitService.js';
import { LuaUtils } from '../../Utils/LuaUtils.js';

export default class BreakingChanges implements IFeature {
    id = '07_BreakingChanges';
    name = '⚠️ Anti-Breaking Changes';
    description = 'Compares API contracts with previous commit';

    async run(ctx: Context): Promise<void> {
        const root = ctx.data.rootPath;
        const git = new GitService(root);
        const issues: any[] = [];
        let md = '';

        if (!git.isGit) {
            md = '> ⚠️ Git not detected. Cannot compare history.';
            ctx.addSection(this.id, '⚠️ Breaking Changes', md);
            return;
        }

        // 🔥 FIX: Use imported fastGlob instead of require
        const configFiles = await fastGlob(['**/SharedConfig.luau'], { cwd: root });
        
        for (const file of configFiles) {
            const fullPath = path.join(root, file);
            const currentContent = await fs.readFile(fullPath, 'utf-8');
            const prevContent = git.getFileAtRevision(fullPath, 'HEAD~1');

            if (!prevContent) continue;

            const currentReqs = this.extractRequests(currentContent);
            const prevReqs = this.extractRequests(prevContent);

            for (const req of prevReqs) {
                if (!currentReqs.includes(req)) {
                    issues.push({
                        type: 'CRITICAL',
                        title: 'API Contract Broken',
                        message: `Request '${req}' removed from ${file}. This breaks backward compatibility for Clients.`,
                        file: file,
                        penalty: 50
                    });
                }
            }
        }

        md = `### 🕵️ API Contract Diff (HEAD vs HEAD~1)\n\n`;
        if (issues.length === 0) {
            md += '✅ **CLEAN: No Breaking Changes detected.**\n\n';
            md += '> **👮‍♂️ ENFORCEMENT NOTE:**\n';
            md += '> - **API Stability:** Never remove keys from `SharedConfig.Requests`. Deprecate them instead.\n';
            md += '> - **Contract First:** Always define Args and RateLimits before coding the implementation.\n';
        }

        md += `\n\n#### 🕰️ Git Stats\n`;
        // Triple backslash for template literal inside template literal
        md += `\`\`\`diff\n${git.getDiffStat()}\n\`\`\``;

        ctx.addSection(this.id, '⚠️ Breaking Changes', md, issues);
    }

    private extractRequests(code: string): string[] {
        const clean = LuaUtils.stripComments(code);
        const match = clean.match(/Requests\s*=\s*\{([^}]+)\}/);
        if (!match) return [];
        
        const block = match[1];
        const keys: string[] = [];
        const keyRegex = /([a-zA-Z0-9_]+)\s*=\s*\{/g;
        let k;
        while ((k = keyRegex.exec(block)) !== null) {
            keys.push(k[1]);
        }
        return keys;
    }
}