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
            
            const regex = /(?:CreateLogger|SmartLogger\.New)\s*\(\s*["']([^"']+)["']/;
            const match = content.match(regex);
            if (match) {
                domains.push({
                    file: fileName,
                    domain: match[1]
                });
            }

            const isLogicFile = fileName.match(/(Service|Controller|Manager|View)\.luau$/);
            
            if (isLogicFile) {
                const hasManualLogger = match; 
                const hasFrameworkInjection = content.includes('OVHL.CreateController') || content.includes('OVHL.CreateService');
                const hasLogger = hasManualLogger || hasFrameworkInjection;
                const hasDebugCall = content.includes('Logger:Debug') || content.includes('Logger:Info') || content.includes('Logger:Warn') || content.includes('Logger:Error');
                
                if (!hasLogger) {
                    issues.push({
                        type: 'CRITICAL',
                        title: 'Blind Logic (Missing Logger)',
                        message: `This file controls logic but has NO EYES. AI cannot debug it. Inject 'SmartLogger' immediately.`,
                        file: file,
                        penalty: PENALTY
                    });
                } else if (!hasDebugCall) {
                    if (!fileName.includes('View')) {
                        issues.push({
                            type: 'WARNING',
                            title: 'Silent Logger (No Verbose)',
                            message: `Logger is available but never used. Add verbose logging to track flow.`,
                            file: file,
                            penalty: 2
                        });
                    }
                }
            }
        }

        let md = '### 📡 Active Telemetry Domains\n\n';
        md += '| Module | Domain |\n|---|---|\n';
        domains.forEach(d => {
            md += `| \`${d.file}\` | **${d.domain}** |\n`;
        });

        if (issues.length === 0) {
            md += '\n✅ **CLEAN: All logic modules have observability.**\n\n';
            md += '> **👮‍♂️ ENFORCEMENT NOTE:**\n';
            md += '> - **Mandatory Logging:** All Controllers/Services MUST have a Logger.\n';
            md += '> - **Verbose Debugging:** Don\'t just define it, USE it! (`:Debug()`, `:Info()`).\n';
        }

        ctx.addSection(this.id, '📡 Telemetry', md, issues);
    }
}