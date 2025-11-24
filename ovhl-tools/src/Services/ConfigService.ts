import { cosmiconfigSync } from 'cosmiconfig';
import path from 'path';
import fs from 'fs-extra';
import chalk from 'chalk';
import { IOVHLConfig } from '../Types/Config.js';

export class ConfigService {
    private config: IOVHLConfig;
    public rootTarget: string;

    constructor() {
        // THE MANIFESTO DEFAULT
        const defaults: IOVHLConfig = {
            project: { targetPath: '../ovhl-framework', rojoFile: 'default.project.json' },
            aiContext: {
                lifecycle: "Init(ctx) [Setup] -> Start() [Runtime] -> Shutdown() [Cleanup]",
                architecture: [
                    "**Pattern:** Singleton Service (Server) & Controller (Client).",
                    "**Memory:** Every module has \`self.Trove\` injected. USE IT for cleanup.",
                    "**Network:** NO manual RemoteEvents. Use \`self.Bridge\` with \`SharedConfig\` contracts.",
                    "**Logging:** NO print/warn. Use \`self.Logger:Info()\`, \`:Debug()\`, etc."
                ],
                testing: "TestEZ is MANDATORY. Mirror src/ structure in tests/. No Logic without Tests."
            },
            reporting: {
                outputDir: './reports',
                timestampFormat: 'YYYY-MM-DD_HH-mm-ss',
                maxHistory: 10,
                naming: { markdown: 'ovhl-snapshot-{TIMESTAMP}', json: 'ovhl-data-{TIMESTAMP}' },
                layout: [
                    '01_Structure',
                    '06_Telemetry',
                    '03_Security',
                    '08_Reusability', // NEW ANALYZER
                    '02_Dependencies',
                    '04_CodeQuality',
                    '05_UIStack',
                    '07_BreakingChanges',
                    '99_Snapshot'
                ]
            },
            audit: { ignore: ['**/Packages/**', '**/_Index/**'], maxSnapshotLines: 1000 },
            penalties: { raceCondition: 20, globalState: 5, missingTelemetry: 10 }
        };

        const explicitPath = path.join(process.cwd(), 'ovhl.config.json');
        let loadedConfig: any = null;

        if (fs.existsSync(explicitPath)) {
            try {
                loadedConfig = JSON.parse(fs.readFileSync(explicitPath, 'utf-8'));
                console.log(chalk.blue(`⚙️  Loaded Config: ${explicitPath}`));
            } catch (e) { console.error("Error parsing config", e); }
        }

        if (loadedConfig) {
            this.config = { ...defaults, ...loadedConfig };
            // Deep merge essential parts
            if(loadedConfig.aiContext) this.config.aiContext = { ...defaults.aiContext, ...loadedConfig.aiContext };
            if(loadedConfig.reporting) this.config.reporting = { ...defaults.reporting, ...loadedConfig.reporting };
            if(loadedConfig.project) this.config.project = { ...defaults.project, ...loadedConfig.project };
            if(loadedConfig.audit) this.config.audit = { ...defaults.audit, ...loadedConfig.audit };
        } else {
            this.config = defaults;
        }

        this.rootTarget = path.resolve(process.cwd(), this.config.project.targetPath);
        if (!fs.existsSync(this.rootTarget)) {
            process.exit(1); // Fail fast if target invalid
        }
    }

    get() { return this.config; }
}