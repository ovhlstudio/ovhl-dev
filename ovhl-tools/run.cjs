const fs = require("fs");
const path = require("path");

const ROOT_DIR = process.cwd();
const SRC_DIR = path.join(ROOT_DIR, "src");

console.log("🚀 OVHL AUDIT TOOL: THE TEACHER UPDATE (v3.0 - Visual Fix)");
console.log("=========================================================");

// ---------------------------------------------------------
// 1. STRUCTURE ANALYZER (VISUAL FIX: ~~~text)
// ---------------------------------------------------------
const FILE_01 = `import fastGlob from 'fast-glob';
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
            const lines = content.split('\\n').length;

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

        let md = '### 📦 Statistics Summary\\n\\n';
        md += '| Metric | Value |\\n|---|---|\\n';
        md += \`| **Files** | \${files.length} |\\n\`;
        md += \`| **Folders** | \${folders.length} |\\n\`;
        md += \`| **Lines** | \${totalLines} |\\n\`;
        md += \`| **Size** | \${TextUtils.formatBytes(totalSize)} |\\n\\n\`;

        md += '### 🗺️ Distribution\\n\\n';
        md += '| Scope | Files | Lines |\\n|---|---|---|\\n';
        for (const [key, val] of Object.entries(stats)) {
            if (val.count > 0) md += \`| **\${key}** | \${val.count} | \${val.lines} |\\n\`;
        }

        md += '\\n### 🌳 Project Scaffold\\n';
        // [VISUAL FIX] Use Tilde (~~~) instead of backticks to prevent nested code block issues
        md += \`~~~text\\n\${treeString}\\n~~~\`;
        
        md += '\\n> **👮‍♂️ OVHL LAW: STRUCTURE**\\n';
        md += '> *   **Server:** Logic that never trusts the client (DB, Auth).\\n';
        md += '> *   **Client:** Visuals & Input handling only.\\n';
        md += '> *   **Shared:** Configs, Constants, & Utility functions.\\n';

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
            output += \`\${prefix}\${connector}\${icon} \${key}\\n\`;
            const children = Object.keys(node).filter(k => k !== '__type');
            if (!isFile && children.length > 0) output += this.generateAsciiTree(node, prefix + childPrefix);
        });
        return output;
    }
}`;

// ---------------------------------------------------------
// 2. DEPENDENCY ANALYZER
// ---------------------------------------------------------
const FILE_02 = `import fastGlob from 'fast-glob';
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
        wally.packages.forEach((_, name) => pkgUsage[name] = 0);

        for (const file of files) {
            const content = await fs.readFile(path.join(root, file), 'utf-8');
            if (content.includes('Loader.Core')) loaderCoreCount++;
            wally.packages.forEach((_, name) => {
                if (wally.isUsed(name, content)) pkgUsage[name]++;
            });
        }

        let md = '### 📦 External Packages (Wally)\\n\\n';
        md += '| Package | Status | Refs |\\n|---|---|---|\\n';
        wally.packages.forEach((ver, name) => {
            const count = pkgUsage[name];
            const status = count > 0 ? '✅ Active' : '⚠️ Unused';
            md += \`| **\${name}** | \${status} | \${count} refs |\\n\`;
        });

        md += '\\n### 🕷️ Module Coupling\\n';
        md += \`- **Core Dependency:** \${loaderCoreCount} files depend heavily on \\\`Loader.Core\\\` frameworks.\\n\`;
        
        md += '\\n> **👮‍♂️ OVHL LAW: DEPENDENCIES**\\n';
        md += '> *   **Wally:** All external libs MUST be managed via \`wally.toml\`.\\n';
        md += '> *   **Dead Code:** Unused packages slow down Rojo sync. Remove them.\\n';

        ctx.addSection(this.id, '🔗 Dependencies', md);
    }
}`;

// ---------------------------------------------------------
// 3. SECURITY ANALYZER (PATCHED)
// ---------------------------------------------------------
const FILE_03 = `import fastGlob from 'fast-glob';
import fs from 'fs-extra';
import path from 'path';
import { IFeature } from '../IFeature.js';
import { Context } from '../../Core/Context.js';

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
            const lines = content.split('\\n');
            
            const returnMatch = content.match(/return\\s+([A-Za-z0-9_]+)\\s*$/m);
            const returnedModuleVar = returnMatch ? returnMatch[1] : null;

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

                const globalMatch = line.match(/^local\\s+([A-Z][A-Za-z0-9_]*)\\s*=\s*\\{/);
                if (globalMatch) {
                    const varName = globalMatch[1];
                    const isConstant = /^[A-Z0-9_]+$/.test(varName);
                    
                    const isReturnedModule = returnedModuleVar === varName;
                    const isSafeSuffix = varName.endsWith('Service') || varName.endsWith('Controller') || varName.endsWith('Component') || varName.endsWith('Page') || varName.endsWith('Interface');
                    const whitelist = ['Components', 'Props', 'State', 'Actions', 'Config', 'Manifest'];
                    const isWhitelisted = whitelist.includes(varName);

                    if (!isConstant && !isReturnedModule && !isSafeSuffix && !isWhitelisted) {
                        issues.push({
                            type: 'WARNING',
                            title: 'Potential Global Mutable State',
                            message: \`Top-level table '\${varName}' detected. If this is a Service/Controller container, ensure it is returned at the end of the file. If it stores state, move it to 'self' or 'Init'.\`,
                            file: file,
                            line: idx + 1,
                            snippet: clean,
                            penalty: 5
                        });
                    }
                }
            });
        }

        let md = '### 🛡️ Security Analysis Results\\n\\n';
        if (issues.length === 0) md += '✅ **CLEAN: No Security Vulnerabilities Found.**\\n\\n';
        
        md += '\\n> **👮‍♂️ OVHL LAW: SECURITY**\\n';
        md += '> *   **No Polling:** Never use \`while wait()\` loops. They destroy server performance.\\n';
        md += '> *   **No Global State:** Do not define mutable tables at the top level. Use \`Init/Start\` or \`Context\` to store state.\\n';
        
        ctx.addSection(this.id, '🛡️ Security Sweep', md, issues);
    }
}`;

// ---------------------------------------------------------
// 4. CODE QUALITY ANALYZER (VISUAL FIX: ~~~lua)
// ---------------------------------------------------------
const FILE_04 = `import fastGlob from 'fast-glob';
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
            const lines = content.split('\\n');
            const isCoreFile = file.includes('/Core/') || file.includes('\\\\Core\\\\') || file.includes('Bootstrap');
            const isRuntimeFile = file.includes('Runtime') || file.includes('.server.luau') || file.includes('.client.luau');

            lines.forEach((line, idx) => {
                const clean = line.trim();
                if (clean.startsWith('--')) return; 

                if (clean.includes('game.ServerScriptService') || clean.includes('game.ReplicatedStorage') || clean.includes('game:GetService')) {
                    if (clean.includes('.') && !isCoreFile && !isRuntimeFile) {
                         if (clean.includes('OVHL.Core.Loader')) return;
                         if (clean.match(/game\\.(ServerScriptService|ReplicatedStorage|StarterPlayer)\\./)) {
                            issues.push({
                                type: 'CRITICAL',
                                title: 'Hardcoded Path (Maintenance Nightmare)',
                                message: 'STOP! Direct pathing creates tight coupling. Use **Loader** or **Context**.',
                                file: file,
                                line: idx + 1,
                                snippet: clean,
                                penalty: 10
                            });
                         }
                    }
                }

                const parentCount = (clean.match(/script\\.Parent/g) || []).length;
                if (parentCount >= 2) {
                    issues.push({
                        type: 'WARNING',
                        title: 'Fragile Relative Path',
                        message: \`Spaghetti Code Detected (\${parentCount} levels deep). Use Loader.Module('Name') instead.\`,
                        file: file,
                        line: idx + 1,
                        snippet: clean,
                        penalty: 5
                    });
                }
            });
        }

        let md = '### 📍 Path & Quality Analysis\\n\\n';
        if (issues.length === 0) md += '✅ **CLEAN: Architecture Compliant.**\\n\\n';
        
        md += '> **👮‍♂️ OVHL LAW: PATHING**\\n';
        md += '> *   **No Hardcoded Paths:** Never use \`game.ServerScriptService.X\`. Use \`Loader.Server("X")\`.\\n';
        md += '> *   **No Relative Hell:** Never use \`script.Parent.Parent\`. Use \`Loader.Module("Name")\`.\\n';
        
        md += '\\n#### 🧠 AI KNOWLEDGE BASE\\n';
        // [VISUAL FIX] Use Tilde (~~~) to display code blocks inside the markdown report safely
        md += '**❌ BAD:**\\n~~~lua\\nlocal Data = require(script.Parent.Parent.Services.DataService)\\n~~~\\n';
        md += '**✅ GOOD (OVHL Standard):**\\n~~~lua\\nlocal Loader = require(ReplicatedStorage.OVHL.Core.Loader)\\nlocal DataService = Loader.Service("DataService")\\n~~~\\n';

        ctx.addSection(this.id, '🧹 Code Quality', md, issues);
    }
}`;

// ---------------------------------------------------------
// 5. UI STACK ANALYZER
// ---------------------------------------------------------
const FILE_05 = `import fastGlob from 'fast-glob';
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
            const lines = content.split('\\n');
            if (content.includes('Fusion')) fusionCount++;
            if (content.includes('onyx-ui') || content.includes('Onyx')) onyxCount++;

            lines.forEach((line, idx) => {
                const clean = line.trim();
                if (clean.startsWith('--')) return;
                const vanillaMatch = clean.match(/Instance\\.new\\s*\\(\\s*["'](Frame|TextLabel|TextButton|ImageLabel|ImageButton|ScrollingFrame|CanvasGroup|UIListLayout)["']/);
                
                if (vanillaMatch) {
                    issues.push({
                        type: 'WARNING',
                        title: 'Vanilla UI Detected (Anti-Pattern)',
                        message: 'Found \`Instance.new("' + vanillaMatch[1] + '")\`. Use **Fusion.New** or **Onyx Components**.',
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

        let md = '### 🎨 UI Tech Stack Overview\\n\\n';
        md += \`- **Fusion Usage:** \${fusionCount} files\\n\`;
        md += \`- **Onyx Usage:** \${onyxCount} files\\n\\n\`;
        if (issues.length === 0) md += '✅ **CLEAN: Modern UI Architecture detected.**\\n\\n';

        md += '> **👮‍♂️ OVHL LAW: UI SYSTEM**\\n';
        md += '> *   **Declarative Only:** Use Fusion/Onyx. Vanilla \`Instance.new\` is messy.\\n';
        md += '> *   **Theme First:** Use \`API.Theme\` tokens. Raw colors break Dark Mode support.\\n';

        ctx.addSection(this.id, '🎨 UI System', md, issues);
    }
}`;

// ---------------------------------------------------------
// 6. TELEMETRY ANALYZER (PATCHED v3)
// ---------------------------------------------------------
const FILE_06 = `import fastGlob from 'fast-glob';
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
            const regex = /(?:CreateLogger|\\.New)\\s*\\(\\s*["']([^"']+)["']\\s*\\)/;
            const match = content.match(regex);
            if (match) {
                domains.push({ file: fileName, domain: match[1] });
            }

            const isLogicFile = fileName.match(/(Service|Controller|Manager|View)\\.luau$/);
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
                            message: \`This file controls logic but has NO EYES. Ensure it uses OVHL.CreateController OR implements :Init(ctx).\`,
                            file: file,
                            penalty: PENALTY
                        });
                    }
                } else if (!hasDebugCall && !isView) {
                    issues.push({
                        type: 'INFO', 
                        title: 'Silent Logger (No Verbose)',
                        message: \`Logger seems available but no logs detected. Consider adding :Info() for traceability.\`,
                        file: file,
                        penalty: 0 
                    });
                }
            }
        }

        let md = '### 📡 Active Telemetry Domains\\n\\n';
        md += '| Module | Domain |\\n|---|---|\\n';
        domains.forEach(d => { md += \`| \\\`\${d.file}\\\` | **\${d.domain}** |\\n\`; });
        if (issues.length === 0) md += '\\n✅ **CLEAN: All logic modules have observability.**\\n\\n';

        md += '> **👮‍♂️ OVHL LAW: OBSERVABILITY**\\n';
        md += '> *   **No Blind Logic:** Logic files MUST have eyes (Logger).\\n';
        md += '> *   **Traceability:** Use \`self.Logger:Info()\` to track flow. NO \`print()\`.\\n';

        ctx.addSection(this.id, '📡 Telemetry', md, issues);
    }
}`;

// ---------------------------------------------------------
// 7. BREAKING CHANGES (Import Fix)
// ---------------------------------------------------------
const FILE_07 = `import fastGlob from 'fast-glob';
import fs from 'fs-extra';
import path from 'path';
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
                        message: \`Request '\${req}' removed from \${file}. This breaks backward compatibility.\`,
                        file: file,
                        penalty: 50
                    });
                }
            }
        }

        md = \`### 🕵️ API Contract Diff (HEAD vs HEAD~1)\\n\\n\`;
        if (issues.length === 0) md += '✅ **CLEAN: No Breaking Changes detected.**\\n\\n';
        md += \`\\n\\n#### 🕰️ Git Stats\\n\\\`\\\`\\\`diff\\n\${git.getDiffStat()}\\n\\\`\\\`\\\`\`;
        
        md += '\\n> **👮‍♂️ OVHL LAW: API STABILITY**\\n';
        md += '> *   **Never Remove:** Deprecate keys instead of deleting them.\\n';
        md += '> *   **Contract First:** Define Args in \`SharedConfig\` before coding.\\n';

        ctx.addSection(this.id, '⚠️ Breaking Changes', md, issues);
    }

    private extractRequests(code: string): string[] {
        const clean = LuaUtils.stripComments(code);
        const match = clean.match(/Requests\\s*=\\s*\\{([^}]+)\\}/);
        if (!match) return [];
        const block = match[1];
        const keys: string[] = [];
        const keyRegex = /([a-zA-Z0-9_]+)\\s*=\\s*\\{/g;
        let k;
        while ((k = keyRegex.exec(block)) !== null) keys.push(k[1]);
        return keys;
    }
}`;

// ---------------------------------------------------------
// 8. REUSABILITY ANALYZER
// ---------------------------------------------------------
const FILE_08 = `import fastGlob from 'fast-glob';
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
        const files = await fastGlob(['src/**/UI/Views/**/*.{lua,luau}'], { cwd: root });
        const issues: any[] = [];

        for (const file of files) {
            const content = await fs.readFile(path.join(root, file), 'utf-8');
            const lines = content.split('\\n');
            lines.forEach((line, idx) => {
                const clean = line.trim();
                if (clean.startsWith('--')) return;
                const localComponentMatch = clean.match(/local\\s+function\\s+([A-Z][a-zA-Z0-9]*)\\s*\\(scope/);
                if (localComponentMatch) {
                    const compName = localComponentMatch[1];
                    if (!file.includes(compName) && compName !== 'Main') {
                        issues.push({
                            type: 'WARNING',
                            title: 'Hardcoded Local Component',
                            message: \`Detected local UI component '\${compName}' defined inside a View. Move it to 'UI/Components' to avoid duplication.\`,
                            file: file,
                            line: idx + 1,
                            snippet: clean,
                            penalty: 5
                        });
                    }
                }
            });
        }

        let md = '### ♻️ Reusability Analysis\\n\\n';
        if (issues.length === 0) md += '✅ UI Architecture looks modular.\\n';
        
        md += '\\n> **👮‍♂️ OVHL LAW: MODULARITY**\\n';
        md += '> *   **DRY (Don\\'t Repeat Yourself):** If a UI piece appears twice, make it a Component.\\n';
        md += '> *   **Dumb Views:** Views should only handle Layout & Data Binding, not complex logic.\\n';

        ctx.addSection(this.id, '♻️ UI Reusability', md, issues);
    }
}`;

// ---------------------------------------------------------
// 9. SCORING ENGINE (Capped Penalty)
// ---------------------------------------------------------
const FILE_SCORING = `import { IAuditIssue } from '../Types/AuditResult.js';

export class ScoringEngine {
    static calculate(currentScore: number, issues: IAuditIssue[]): number {
        let newScore = currentScore;
        
        const penaltyByTitle: { [key: string]: number } = {};
        const MAX_PENALTY_PER_TYPE = 20; 

        issues.forEach(issue => {
            const p = issue.penalty || 0;
            const t = issue.title;
            if (!penaltyByTitle[t]) penaltyByTitle[t] = 0;
            if (penaltyByTitle[t] < MAX_PENALTY_PER_TYPE) {
                const remaining = MAX_PENALTY_PER_TYPE - penaltyByTitle[t];
                const deduct = Math.min(p, remaining);
                penaltyByTitle[t] += deduct;
                newScore -= deduct;
            }
        });

        return Math.max(0, newScore);
    }

    static getGrade(score: number): string {
        if (score >= 90) return 'A';
        if (score >= 80) return 'B';
        if (score >= 70) return 'C';
        if (score >= 60) return 'D';
        return 'F';
    }
}`;

// ---------------------------------------------------------
// MAPPING & EXECUTION
// ---------------------------------------------------------
const TARGETS = [
	{ path: "Features/Analyzers/01_Structure.ts", content: FILE_01 },
	{ path: "Features/Analyzers/02_Dependencies.ts", content: FILE_02 },
	{ path: "Features/Analyzers/03_Security.ts", content: FILE_03 },
	{ path: "Features/Analyzers/04_CodeQuality.ts", content: FILE_04 },
	{ path: "Features/Analyzers/05_UIStack.ts", content: FILE_05 },
	{ path: "Features/Analyzers/06_Telemetry.ts", content: FILE_06 },
	{ path: "Features/Analyzers/07_BreakingChanges.ts", content: FILE_07 },
	{ path: "Features/Analyzers/08_Reusability.ts", content: FILE_08 },
	{ path: "Core/ScoringEngine.ts", content: FILE_SCORING },
];

async function applyPatch() {
	for (const target of TARGETS) {
		const fullPath = path.join(SRC_DIR, target.path);
		if (fs.existsSync(fullPath)) {
			// Backup (Overwrite existing backup)
			fs.copyFileSync(fullPath, fullPath + ".bak");
		}
		// Write New Content
		fs.writeFileSync(fullPath, target.content, "utf-8");
		console.log(`✅ Patched: ${target.path}`);
	}
	console.log(
		"\\n✨ ALL ANALYZERS UPGRADED WITH EDUCATIONAL LOGIC & VISUAL FIX."
	);
	console.log("👉 PLEASE RUN: npm run build");
}

applyPatch();
