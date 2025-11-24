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
        
        console.log(chalk.cyan('\n🚀 Starting Orchestrated Audit Sequence...'));
        
        for (const plugin of plugins) {
            const spinner = ora(`Running: ${plugin.name}`).start();
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
                spinner.fail(`Error in ${plugin.name}: ${e.message}`);
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
                reports.push(`📄 Markdown: ${path}`);
            }

            if (opts.json) {
                const path = await this.artifact.preparePath('json');
                new JsonRaw().save(this.context.data, path);
                reports.push(`🤖 JSON: ${path}`);
            }

            spinner.succeed('Reports Generated');

            // 🔥 ALWAYS SHOW DASHBOARD
            console.log('');
            new ConsolePretty().print(this.context.data);
            
            const score = this.context.data.globalScore;
            console.log(chalk.green('\n✅ Audit Complete!'));
            reports.forEach(r => console.log(r));
            console.log(`⚖️  Health Score: ${this.getScoreColor(score)}`);

        } catch (e: any) {
            spinner.fail('Reporting failed');
            console.error(e);
        }
    }

    private getScoreColor(score: number): string {
        if (score >= 90) return chalk.green(`${score}/100 (Excellent)`);
        if (score >= 70) return chalk.yellow(`${score}/100 (Warning)`);
        return chalk.red(`${score}/100 (Critical)`);
    }
}