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