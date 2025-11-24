import { Command } from 'commander';
import fs from 'fs-extra';
import path from 'path';
import chalk from 'chalk';
import { ICommand } from '../ICommand.js';
import { select } from '@inquirer/prompts';

export default class InitCommand implements ICommand {
    id = '00_Init';
    command = 'init';
    description = 'Generate configuration file';
    icon = '⚙️';

    register(program: Command) {
        program
            .command(this.command)
            .description(this.description)
            .action(async () => this.execute({}));
    }

    async execute(_opts: any) {
        const targetPath = path.join(process.cwd(), 'ovhl.config.json');
        
        if (fs.existsSync(targetPath)) {
            console.log(chalk.yellow('⚠️  Config file already exists.'));
            return;
        }

        // Default V17 Config structure
        const config = {
            "project": { "targetPath": "../ovhl-framework", "rojoFile": "default.project.json" },
            "aiContext": {
                "lifecycle": "Init(ctx) -> Start()",
                "architecture": ["Singleton Service/Controller", "No wait()", "No script.Parent.Parent"],
                "testing": "TestEZ Mandatory"
            },
            "reporting": {
                "outputDir": "./reports",
                "timestampFormat": "YYYY-MM-DD_HH-mm-ss",
                "maxHistory": 5,
                "naming": { "markdown": "ovhl-snapshot-{TIMESTAMP}", "json": "ovhl-data-{TIMESTAMP}" },
                "layout": ["01_Structure", "06_Telemetry", "03_Security", "08_Reusability", "02_Dependencies", "04_CodeQuality", "07_BreakingChanges", "99_Snapshot"]
            },
            "audit": { "ignore": ["**/Packages/**", "**/_Index/**"], "maxSnapshotLines": 1000 },
            "penalties": { "raceCondition": 20, "globalState": 5, "missingTelemetry": 10 }
        };

        fs.writeFileSync(targetPath, JSON.stringify(config, null, 2));
        console.log(chalk.green(`\n✅ Config generated at: ${targetPath}`));
        console.log(chalk.dim('👉 Edit "targetPath" to point to your framework folder.'));
    }
}