import fastGlob from 'fast-glob';
import fs from 'fs-extra';
import path from 'path';
import { IFeature } from '../IFeature.js';
import { Context } from '../../Core/Context.js';

export default class UIAnalyzer implements IFeature {
    id = '05_UIStack';
    name = '🎨 UI Architecture & Standards';
    description = 'Enforces Fusion/Onyx usage and detects Vanilla anti-patterns';

    async run(ctx: Context): Promise<void> {
        const root = ctx.data.rootPath;
        const files = await fastGlob(['src/**/UI/**/*.{lua,luau}'], { cwd: root });
        const issues: any[] = [];
        
        let fusionCount = 0;
        let onyxCount = 0;

        for (const file of files) {
            const content = await fs.readFile(path.join(root, file), 'utf-8');
            const lines = content.split('\n');
            if (content.includes('Fusion')) fusionCount++;
            if (content.includes('onyx-ui') || content.includes('Onyx')) onyxCount++;

            lines.forEach((line, idx) => {
                const clean = line.trim();
                if (clean.startsWith('--')) return;
                const vanillaMatch = clean.match(/Instance\.new\s*\(\s*["'](Frame|TextLabel|TextButton|ImageLabel|ImageButton|ScrollingFrame|CanvasGroup|UIListLayout)["']/);
                
                if (vanillaMatch) {
                    issues.push({
                        type: 'WARNING',
                        title: 'Vanilla UI Detected (Anti-Pattern)',
                        message: 'Found `Instance.new("' + vanillaMatch[1] + '")`. Use **Fusion.New** or **Onyx Components**.',
                        file: file,
                        line: idx + 1,
                        snippet: clean,
                        penalty: 5
                    });
                }
                if (clean.includes('Color3.fromRGB') || clean.includes('Color3.new')) {
                    if (!file.includes('Theme') && !file.includes('Config')) {
                         issues.push({
                            type: 'INFO',
                            title: 'Hardcoded Color',
                            message: 'Avoid raw colors. Use **API.Theme** tokens (e.g. Theme.Colors.Base.Main).',
                            file: file,
                            line: idx + 1,
                            snippet: clean,
                            penalty: 1
                        });
                    }
                }
            });
        }

        let md = '### 🎨 UI Tech Stack Overview\n\n';
        md += `- **Fusion Usage:** ${fusionCount} files\n`;
        md += `- **Onyx Usage:** ${onyxCount} files\n\n`;
        if (issues.length === 0) md += '✅ **CLEAN: Modern UI Architecture detected.**\n\n';

        md += '> **👮‍♂️ OVHL LAW: UI SYSTEM**\n';
        md += '> *   **Declarative Only:** Use Fusion/Onyx. Vanilla `Instance.new` is messy.\n';
        md += '> *   **Theme First:** Use `API.Theme` tokens. Raw colors break Dark Mode support.\n';

        ctx.addSection(this.id, '🎨 UI System', md, issues);
    }
}