import fastGlob from 'fast-glob';
import fs from 'fs-extra';
import path from 'path';
import { IFeature } from '../IFeature.js';
import { Context } from '../../Core/Context.js';

export default class CodeQualityAnalyzer implements IFeature {
    id = '04_CodeQuality';
    name = '🧹 Code Quality';
    description = 'Checks for hardcoded paths and relative requirement hell';

    async run(ctx: Context): Promise<void> {
        const root = ctx.data.rootPath;
        const files = await fastGlob(['src/**/*.{lua,luau}'], { cwd: root });
        const issues: any[] = [];

        for (const file of files) {
            const fullPath = path.join(root, file);
            const content = await fs.readFile(fullPath, 'utf-8');
            const lines = content.split('\n');
            
            const isCoreFile = file.includes('/Core/') || file.includes('\\Core\\') || file.includes('Bootstrap');
            const isRuntimeFile = file.includes('Runtime') || file.includes('.server.luau') || file.includes('.client.luau');

            lines.forEach((line, idx) => {
                const clean = line.trim();
                if (clean.startsWith('--')) return; 

                if (clean.includes('game.ServerScriptService') || clean.includes('game.ReplicatedStorage') || clean.includes('game:GetService')) {
                    if (clean.includes('.') && !isCoreFile && !isRuntimeFile) {
                         if (clean.includes('OVHL.Core.Loader')) return;
                         if (clean.match(/game\.(ServerScriptService|ReplicatedStorage|StarterPlayer)\./)) {
                            issues.push({
                                type: 'CRITICAL',
                                title: 'Hardcoded Path (Maintenance Nightmare)',
                                message: 'STOP! Direct pathing creates tight coupling. If you move folders, this breaks. Use **Loader** or **Context**.',
                                file: file,
                                line: idx + 1,
                                snippet: clean,
                                penalty: 10
                            });
                         }
                    }
                }

                const parentCount = (clean.match(/script\.Parent/g) || []).length;
                if (parentCount >= 2) {
                    let suggestion = 'Use Loader.Module(...)';
                    const myRojoPath = ctx.services.rojo.getRobloxPath(fullPath);
                    if (myRojoPath) {
                        const parts = myRojoPath.split('.');
                        if (parts.length > parentCount) {
                            const targetParentPath = parts.slice(0, parts.length - parentCount).join('.');
                            let loaderSyntax = targetParentPath;
                            if (targetParentPath.includes('Modules.')) {
                                const modName = targetParentPath.split('Modules.')[1].split('.')[0];
                                loaderSyntax = `Loader.Module("${modName}")`;
                            } else if (targetParentPath.includes('Core.')) {
                                const coreName = targetParentPath.split('Core.')[1];
                                loaderSyntax = `Loader.Core("${coreName}")`;
                            }
                            suggestion = `Based on Rojo, you are trying to reach: \`${targetParentPath}\`.\n💡 **Better:** \`${loaderSyntax}\``;
                        }
                    }
                    issues.push({
                        type: 'WARNING',
                        title: 'Fragile Relative Path',
                        message: `Spaghetti Code Detected (${parentCount} levels deep). If you move this file, the path breaks.\n${suggestion}`,
                        file: file,
                        line: idx + 1,
                        snippet: clean,
                        penalty: 5
                    });
                }
            });
        }

        let md = '### 📍 Path & Quality Analysis\n\n';
        if (issues.length === 0) {
            md += '✅ **CLEAN: Architecture Compliant.**\n\n';
            md += '> **👮‍♂️ ENFORCEMENT NOTE:**\n';
            md += '> - **No Hardcoded Paths:** Never use `game.ServerScriptService.X`. Use `Loader.Server("X")`.\n';
            md += '> - **No Relative Hell:** Never use `script.Parent.Parent`. Use `Loader.Module("Name")`.\n';
        }
        
        ctx.addSection(this.id, '🧹 Code Quality', md, issues);
    }
}