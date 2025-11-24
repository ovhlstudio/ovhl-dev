import fastGlob from 'fast-glob';
import fs from 'fs-extra';
import path from 'path';
import { IFeature } from '../IFeature.js';
import { Context } from '../../Core/Context.js';
import { LuaUtils } from '../../Utils/LuaUtils.js';

export default class SecurityAnalyzer implements IFeature {
    id = '03_Security';
    name = '🛡️ Security Sweep';
    description = 'Deep scan for race conditions and vulnerabilities';

    async run(ctx: Context): Promise<void> {
        const root = ctx.data.rootPath;
        const files = await fastGlob(['src/**/*.{lua,luau}'], { cwd: root });
        const issues: any[] = [];

        for (const file of files) {
            const content = await fs.readFile(path.join(root, file), 'utf-8');
            const lines = content.split('\n');
            const fileNameNoExt = path.basename(file).split('.')[0]; 
            
            lines.forEach((line, idx) => {
                const clean = line.trim();
                if (clean.startsWith('--')) return;

                if (clean.includes('while') && (clean.includes('wait(') || clean.includes('task.wait('))) {
                    if (clean.match(/while.*do.*wait/)) {
                        issues.push({
                            type: 'CRITICAL',
                            title: 'Polling Loop Detected',
                            message: 'Avoid using while-wait loops. They yield indefinitely. Use RunService events or Signals.',
                            file: file,
                            line: idx + 1,
                            snippet: clean,
                            penalty: 20
                        });
                    }
                }

                const globalMatch = line.match(/^local\s+([A-Z][A-Za-z0-9_]*)\s*=\s*\{/);
                if (globalMatch) {
                    const varName = globalMatch[1];
                    const isConstant = /^[A-Z0-9_]+$/.test(varName);
                    const isModuleDef = varName === fileNameNoExt;
                    const isSafeSuffix = varName.endsWith('Service') || varName.endsWith('Controller') || varName.endsWith('Component') || varName.endsWith('Page');
                    const whitelist = ['Components', 'Props', 'State', 'Actions'];
                    const isWhitelisted = whitelist.includes(varName);

                    if (!isConstant && !isModuleDef && !isSafeSuffix && !isWhitelisted) {
                        issues.push({
                            type: 'WARNING',
                            title: 'Potential Global Mutable State',
                            message: `Top-level table '${varName}' detected. If this stores state, it will persist. Ensure it is stateless or a Constant.`,
                            file: file,
                            line: idx + 1,
                            snippet: clean,
                            penalty: 5
                        });
                    }
                }
            });
        }

        let md = '### 🛡️ Security Analysis Results\n\n';
        if (issues.length === 0) {
            md += '✅ **CLEAN: No Security Vulnerabilities Found.**\n\n';
            md += '> **👮‍♂️ ENFORCEMENT NOTE:**\n';
            md += '> - **No Polling:** Never use `while wait()` loops. They destroy server performance.\n';
            md += '> - **No Global State:** Do not define mutable tables at the top level. Use `Init/Start` or `Context` to store state.\n';
        }
        
        ctx.addSection(this.id, '🛡️ Security Sweep', md, issues);
    }
}