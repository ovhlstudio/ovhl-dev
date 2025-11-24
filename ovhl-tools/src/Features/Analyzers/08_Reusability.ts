import fastGlob from 'fast-glob';
import fs from 'fs-extra';
import path from 'path';
import { IFeature } from '../IFeature.js';
import { Context } from '../../Core/Context.js';

export default class ReusabilityAnalyzer implements IFeature {
    id = '08_Reusability';
    name = '♻️ UI Reusability (DRY)';
    description = 'Detects hardcoded UI components inside Views that should be shared';

    async run(ctx: Context): Promise<void> {
        const root = ctx.data.rootPath;
        // Target: Hanya folder UI/Views
        const files = await fastGlob(['src/**/UI/Views/**/*.{lua,luau}'], { cwd: root });
        const issues: any[] = [];

        for (const file of files) {
            const fullPath = path.join(root, file);
            const content = await fs.readFile(fullPath, 'utf-8');
            const lines = content.split('\n');

            // Logic: Mencari definisi fungsi komponen LOKAL di dalam View
            // Pola Fusion: local function NamaKomponen(scope, props)
            lines.forEach((line, idx) => {
                const clean = line.trim();
                if (clean.startsWith('--')) return;

                const localComponentMatch = clean.match(/local\s+function\s+([A-Z][a-zA-Z0-9]*)\s*\(scope/);
                
                if (localComponentMatch) {
                    const compName = localComponentMatch[1];
                    // Ignore standard naming like 'View' or 'Main'
                    if (!file.includes(compName) && compName !== 'Main') {
                        issues.push({
                            type: 'WARNING',
                            title: 'Hardcoded Local Component',
                            message: `Detected local UI component '${compName}' defined inside a View. If this UI element is used in other views (e.g. ItemCard), move it to 'UI/Components' to avoid duplication.`,
                            file: file,
                            line: idx + 1,
                            snippet: clean,
                            penalty: 5
                        });
                    }
                }
            });
        }

        let md = '### ♻️ Reusability Analysis\n\n';
        if (issues.length === 0) md += '✅ UI Architecture looks modular.\n';
        
        ctx.addSection(this.id, '♻️ UI Reusability', md, issues);
    }
}