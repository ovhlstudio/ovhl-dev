import fastGlob from 'fast-glob';
import fs from 'fs-extra';
import path from 'path';
import { IFeature } from '../IFeature.js';
import { Context } from '../../Core/Context.js';

export default class TelemetryAnalyzer implements IFeature {
    id = '06_Telemetry';
    name = '📡 Telemetry & Observability';
    description = 'Enforces logging standards on logic files';

    async run(ctx: Context): Promise<void> {
        const root = ctx.data.rootPath;
        const files = await fastGlob(['src/**/*.{lua,luau}'], { cwd: root });
        const domains: {file: string, domain: string}[] = [];
        const issues: any[] = [];
        const PENALTY = ctx.data.config.penalties?.missingTelemetry || 10;

        for (const file of files) {
            const content = await fs.readFile(path.join(root, file), 'utf-8');
            const fileName = path.basename(file);
            
            // [PATCH v3] Regex Ultimate
            const regex = /(?:CreateLogger|\.New)\s*\(\s*["']([^"']+)["']\s*\)/;
            const match = content.match(regex);
            if (match) {
                domains.push({ file: fileName, domain: match[1] });
            }

            const isLogicFile = fileName.match(/(Service|Controller|Manager|View)\.luau$/);
            const isView = fileName.includes('View'); 
            
            if (isLogicFile) {
                const hasManualLogger = match; 
                const hasFrameworkInjection = content.includes('OVHL.CreateController') || content.includes('OVHL.CreateService');
                const hasLifecycleInit = content.includes(':Init(');
                const hasLogger = hasManualLogger || hasFrameworkInjection || hasLifecycleInit;
                const hasDebugCall = content.includes('Logger:Debug') || content.includes('Logger:Info') || content.includes('Logger:Warn') || content.includes('self.Logger:');
                
                if (!hasLogger) {
                    if (!isView) { 
                        issues.push({
                            type: 'CRITICAL',
                            title: 'Blind Logic (Missing Logger)',
                            message: `This file controls logic but has NO EYES. Ensure it uses OVHL.CreateController OR implements :Init(ctx).`,
                            file: file,
                            penalty: PENALTY
                        });
                    }
                } else if (!hasDebugCall && !isView) {
                    issues.push({
                        type: 'INFO', 
                        title: 'Silent Logger (No Verbose)',
                        message: `Logger seems available but no logs detected. Consider adding :Info() for traceability.`,
                        file: file,
                        penalty: 0 
                    });
                }
            }
        }

        let md = '### 📡 Active Telemetry Domains\n\n';
        md += '| Module | Domain |\n|---|---|\n';
        domains.forEach(d => { md += `| \`${d.file}\` | **${d.domain}** |\n`; });
        if (issues.length === 0) md += '\n✅ **CLEAN: All logic modules have observability.**\n\n';

        md += '> **👮‍♂️ OVHL LAW: OBSERVABILITY**\n';
        md += '> *   **No Blind Logic:** Logic files MUST have eyes (Logger).\n';
        md += '> *   **Traceability:** Use `self.Logger:Info()` to track flow. NO `print()`.\n';

        ctx.addSection(this.id, '📡 Telemetry', md, issues);
    }
}