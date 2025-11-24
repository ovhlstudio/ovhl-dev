import fastGlob from 'fast-glob';
import fs from 'fs-extra';
import path from 'path';
import { IFeature } from '../IFeature.js';
import { Context } from '../../Core/Context.js';
import { WallyService } from '../../Services/WallyService.js';

export default class DependencyAnalyzer implements IFeature {
    id = '02_Dependencies';
    name = '🔗 Dependency Graph';
    description = 'Analyzes internal coupling and Wally packages';

    async run(ctx: Context): Promise<void> {
        const root = ctx.data.rootPath;
        const wally = new WallyService(root);
        await wally.scan();

        const files = await fastGlob(['src/**/*.{lua,luau}'], { cwd: root });
        
        let loaderCoreCount = 0;
        const pkgUsage: Record<string, number> = {};

        // Init pkg counters
        wally.packages.forEach((_, name) => pkgUsage[name] = 0);

        for (const file of files) {
            const content = await fs.readFile(path.join(root, file), 'utf-8');
            
            // Check Internal Coupling
            if (content.includes('Loader.Core')) loaderCoreCount++;

            // Check External Usage
            wally.packages.forEach((_, name) => {
                if (wally.isUsed(name, content)) {
                    pkgUsage[name]++;
                }
            });
        }

        let md = '### 📦 External Packages (Wally)\n\n';
        md += '| Package | Status | Refs |\n|---|---|---|\n';
        
        wally.packages.forEach((ver, name) => {
            const count = pkgUsage[name];
            const status = count > 0 ? '✅ Active' : '⚠️ Unused';
            md += `| **${name}** | ${status} | ${count} refs |\n`;
        });

        md += '\n### 🕷️ Module Coupling\n';
        // FIX: Double escaping backticks
        md += `- **Core Dependency:** ${loaderCoreCount} files depend heavily on \`Loader.Core\` frameworks.\n`;

        ctx.addSection(this.id, '🔗 Dependencies', md);
    }
}