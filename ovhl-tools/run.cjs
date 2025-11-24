const fs = require("fs");
const path = require("path");

function write(filePath, content) {
	const fullPath = path.join(process.cwd(), filePath);
	fs.writeFileSync(fullPath, content.trim());
	console.log(`✅ UX Upgraded: ${filePath}`);
}

console.log("🚀 EXECUTING V18: DASHBOARD UI & SINGLE-SELECT FLOW...\n");

// ==========================================
// 1. UPDATE TYPES (Add Duration Field)
// ==========================================
write(
	"src/Types/AuditResult.d.ts",
	`
export interface IAuditIssue {
    type: 'CRITICAL' | 'WARNING' | 'INFO';
    title: string;
    message: string;
    file?: string;
    line?: number;
    snippet?: string;
    penalty: number;
}

export interface IAuditSection {
    id: string;
    title: string;
    content: string;
    issues: IAuditIssue[];
    duration?: number; // 🔥 NEW: Execution time in ms
}

export interface IAuditContext {
    rootPath: string;
    timestamp: string;
    results: Map<string, IAuditSection>;
    globalScore: number;
    config: any;
    metadata?: {
        duration: string;
        command: string;
        version: string;
        gitInfo?: string;
        rojoMapping?: string;
    };
}
`
);

// ==========================================
// 2. UPDATE ORCHESTRATOR (Time Tracking)
// ==========================================
write(
	"src/Core/Orchestrator.ts",
	`
import ora from 'ora';
import chalk from 'chalk';
import { Context } from './Context.js';
import { IFeature } from '../Features/IFeature.js';
import { MarkdownAI } from '../Reporters/MarkdownAI.js';
import { JsonRaw } from '../Reporters/JsonRaw.js';
import { ConsolePretty } from '../Reporters/ConsolePretty.js';
import { ArtifactService } from '../Services/ArtifactService.js';

export class Orchestrator {
    private context: Context;
    private artifact: ArtifactService;

    constructor(context: Context) {
        this.context = context;
        this.artifact = new ArtifactService(context.data.config);
    }

    async execute(plugins: IFeature[], options: { md: boolean, json: boolean }) {
        const globalStart = performance.now();
        
        console.log(chalk.cyan('\\n🚀 Starting Orchestrated Audit Sequence...'));
        
        for (const plugin of plugins) {
            const spinner = ora(\`Running: \${plugin.name}\`).start();
            const start = performance.now();
            
            try {
                await plugin.run(this.context);
                
                // Calculate & Inject Duration
                const end = performance.now();
                const duration = Math.round(end - start);
                
                // Inject duration into the result section if it exists
                const section = this.context.data.results.get(plugin.id);
                if (section) {
                    section.duration = duration;
                }

                spinner.succeed();
            } catch (e: any) {
                spinner.fail(\`Error in \${plugin.name}: \${e.message}\`);
                console.error(chalk.dim(e.stack));
            }
        }

        const globalEnd = performance.now();
        const globalDuration = ((globalEnd - globalStart) / 1000).toFixed(2) + 's';

        this.context.data.metadata = {
            duration: globalDuration,
            command: 'ovhl audit',
            version: '0.1.0',
            rojoMapping: this.context.services.rojo.getMappingTable()
        };

        await this.finalize(options);
    }

    private async finalize(opts: { md: boolean, json: boolean }) {
        const spinner = ora('Generating Reports...').start();
        const reports: string[] = [];

        try {
            if (opts.md) {
                const path = await this.artifact.preparePath('markdown');
                new MarkdownAI().save(this.context.data, path);
                reports.push(\`📄 Markdown: \${path}\`);
            }

            if (opts.json) {
                const path = await this.artifact.preparePath('json');
                new JsonRaw().save(this.context.data, path);
                reports.push(\`🤖 JSON: \${path}\`);
            }

            spinner.succeed('Reports Generated');

            // 🔥 ALWAYS SHOW DASHBOARD
            console.log('');
            new ConsolePretty().print(this.context.data);
            
            const score = this.context.data.globalScore;
            console.log(chalk.green('\\n✅ Audit Complete!'));
            reports.forEach(r => console.log(r));
            console.log(\`⚖️  Health Score: \${this.getScoreColor(score)}\`);

        } catch (e: any) {
            spinner.fail('Reporting failed');
            console.error(e);
        }
    }

    private getScoreColor(score: number): string {
        if (score >= 90) return chalk.green(\`\${score}/100 (Excellent)\`);
        if (score >= 70) return chalk.yellow(\`\${score}/100 (Warning)\`);
        return chalk.red(\`\${score}/100 (Critical)\`);
    }
}
`
);

// ==========================================
// 3. UPDATE CONSOLE PRETTY (The Dashboard)
// ==========================================
write(
	"src/Reporters/ConsolePretty.ts",
	`
import Table from 'cli-table3';
import chalk from 'chalk';
import { IAuditContext } from '../Types/AuditResult.js';

export class ConsolePretty {
    print(ctx: IAuditContext) {
        const table = new Table({
            head: [
                chalk.white.bold('Module'), 
                chalk.white.bold('Status'), 
                chalk.white.bold('Issues'),
                chalk.white.bold('Time')
            ],
            colWidths: [35, 15, 10, 10],
            style: { head: [], border: [] }
        });

        const layout = ctx.config.reporting.layout || [];
        
        layout.forEach(id => {
            const res = ctx.results.get(id);
            if(res) {
                const count = res.issues.length;
                let status = chalk.green('✅ PASS');
                let countStr = chalk.dim('-');

                if (count > 0) {
                    const hasCritical = res.issues.some(i => i.type === 'CRITICAL');
                    if (hasCritical) {
                        status = chalk.red('🔴 FAIL');
                        countStr = chalk.red(count.toString());
                    } else {
                        status = chalk.yellow('⚠️ WARN');
                        countStr = chalk.yellow(count.toString());
                    }
                }

                const time = res.duration ? \`\${res.duration}ms\` : '-';
                
                // Truncate title if too long
                let title = res.title;
                if (title.length > 30) title = title.substring(0, 27) + '...';

                table.push([title, status, countStr, chalk.dim(time)]);
            }
        });

        console.log(table.toString());
    }
}
`
);

// ==========================================
// 4. UPDATE INTERACTIVE (Single Select Flow)
// ==========================================
write(
	"src/CLI/Interactive.ts",
	`
import { select, checkbox } from '@inquirer/prompts';
import { PluginRegistry } from '../Core/PluginRegistry.js';

export async function showMainMenu(registry: PluginRegistry) {
    const plugins = registry.getPlugins();
    
    // 1. Action Selection
    const action = await select({
        message: 'Apa yang ingin kamu lakukan?',
        choices: [
            { name: '🚀 One-Hit Audit (Default)', value: 'FULL' },
            { name: '⚙️  Custom Audit (Wizard)', value: 'CUSTOM' },
            { name: '🚪 Keluar', value: 'EXIT' }
        ]
    });

    if (action === 'EXIT') process.exit(0);

    let selectedPlugins = plugins;

    // 2. Plugin Selection (Only for Custom)
    if (action === 'CUSTOM') {
        const pluginChoices = plugins.map(p => ({
            name: p.name,
            value: p,
            checked: true
        }));

        selectedPlugins = await checkbox({
            message: 'Pilih Module Analisis:',
            choices: pluginChoices,
            validate: (choices) => choices.length > 0 ? true : 'Pilih minimal satu module!'
        });
    }

    // 3. Output Selection (SINGLE SELECT NOW)
    const format = await select({
        message: 'Pilih Format Output:',
        choices: [
            { name: '📄 Markdown Only (Standard)', value: 'md' },
            { name: '🤖 JSON Only (Data)', value: 'json' },
            { name: '📦 Both (Markdown + JSON)', value: 'both' }
        ]
    });

    return { 
        plugins: selectedPlugins, 
        format: format // 'md' | 'json' | 'both'
    };
}
`
);

// ==========================================
// 5. UPDATE AUDIT COMMAND (Wire New Flow)
// ==========================================
write(
	"src/CLI/Commands/Audit.ts",
	`
import { Command } from 'commander';
import chalk from 'chalk';
import { ICommand } from '../ICommand.js';
import { ConfigService } from '../../Services/ConfigService.js';
import { RojoService } from '../../Services/RojoService.js';
import { PluginRegistry } from '../../Core/PluginRegistry.js';
import { Context } from '../../Core/Context.js';
import { Orchestrator } from '../../Core/Orchestrator.js';
import { showMainMenu } from '../Interactive.js';
import { IFeature } from '../../Features/IFeature.js';

export default class AuditCommand implements ICommand {
    id = '01_Audit';
    command = 'audit';
    description = 'Analyze framework health & security';
    icon = '🕵️';

    register(program: Command) {
        program
            .command(this.command)
            .description(this.description)
            .option('-f, --full', 'Run full audit (Default output: MD)')
            .option('--md', 'Output Markdown')
            .option('--json', 'Output JSON')
            .action(async (opts) => this.execute(opts));
    }

    async execute(opts: any) {
        const configService = new ConfigService();
        const targetRoot = configService.rootTarget;
        const rojo = new RojoService(targetRoot);
        const registry = new PluginRegistry();

        await rojo.loadProject(configService.get().project.rojoFile);
        await registry.loadPlugins();

        let targets: IFeature[] = [];
        let outputOpts = { md: false, json: false };

        // HEADLESS MODE
        const isHeadless = opts.full || opts.md || opts.json;

        if (isHeadless) {
            targets = registry.getPlugins();
            if (opts.full) {
                // Default full = MD only (Clean)
                outputOpts = { md: true, json: false };
            } else {
                outputOpts = { md: !!opts.md, json: !!opts.json };
            }
        } 
        // INTERACTIVE MODE
        else {
            const selection = await showMainMenu(registry);
            targets = selection.plugins;
            
            if (selection.format === 'both') {
                outputOpts = { md: true, json: true };
            } else {
                outputOpts = { 
                    md: selection.format === 'md',
                    json: selection.format === 'json'
                };
            }
        }

        const context = new Context(targetRoot, configService.get(), rojo);
        const orchestrator = new Orchestrator(context);
        
        // Console is now ALWAYS active in Orchestrator finalize
        await orchestrator.execute(targets, outputOpts);
    }
}
`
);

console.log(
	"\n✨ V18 UX OVERHAUL COMPLETE! Dashboard & Single-Select deployed."
);
