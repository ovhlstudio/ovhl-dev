import { cosmiconfigSync } from "cosmiconfig";
import path from "path";
import fs from "fs-extra";
import chalk from "chalk";
import { IOVHLConfig } from "../Types/Config.js";

export class ConfigService {
	private config: IOVHLConfig;
	public rootTarget: string;

	// [SSOT] Single Source of Truth: Definisi Config "Enterprise" ada di sini
	// Static biar bisa diakses oleh InitCommand tanpa perlu instantiate service
	public static readonly DEFAULTS: IOVHLConfig = {
		project: {
			targetPath: "../ovhl-framework",
			rojoFile: "default.project.json",
		},
		// Refactor Tool V4 Config
		refactor: {
			loaderPath: "src/ReplicatedStorage/OVHL/Core/Loader.luau",
		},
		aiContext: {
			lifecycle:
				"Init(ctx) [Setup] -> Start() [Runtime] -> Shutdown() [Cleanup]",
			architecture: [
				"**Pattern:** Singleton Service (Server) & Controller (Client).",
				"**Memory:** Every module has `self.Trove` injected. USE IT for cleanup.",
				"**Network:** NO manual RemoteEvents. Use `self.Bridge` with `SharedConfig` contracts.",
				"**Logging:** NO print/warn. Use `self.Logger:Info()`, `:Debug()`, etc.",
			],
			testing:
				"TestEZ is MANDATORY. Mirror src/ structure in tests/. No Logic without Tests.",
		},
		reporting: {
			outputDir: "./reports",
			timestampFormat: "YYYY-MM-DD_HH-mm-ss",
			maxHistory: 10,
			naming: {
				markdown: "ovhl-snapshot-{TIMESTAMP}",
				json: "ovhl-data-{TIMESTAMP}",
			},
			layout: [
				"01_Structure",
				"06_Telemetry",
				"03_Security",
				"08_Reusability",
				"02_Dependencies",
				"04_CodeQuality",
				"05_UIStack",
				"07_BreakingChanges",
				"99_Snapshot",
			],
		},
		audit: {
			ignore: ["**/Packages/**", "**/_Index/**", "**/node_modules/**"],
			maxSnapshotLines: 1000,
		},
		penalties: {
			raceCondition: 20,
			globalState: 5,
			missingTelemetry: 10,
		},
	};

	constructor() {
		const explicitPath = path.join(process.cwd(), "ovhl.config.json");
		let loadedConfig: any = null;

		if (fs.existsSync(explicitPath)) {
			try {
				loadedConfig = JSON.parse(
					fs.readFileSync(explicitPath, "utf-8")
				);
				console.log(chalk.blue(`⚙️  Loaded Config: ${explicitPath}`));
			} catch (e) {
				console.error("Error parsing config", e);
			}
		}

		if (loadedConfig) {
			// Merge Loaded Config dengan Defaults
			this.config = { ...ConfigService.DEFAULTS, ...loadedConfig };

			// Deep merge partials (Biar user bisa override sebagian aja)
			if (loadedConfig.aiContext)
				this.config.aiContext = {
					...ConfigService.DEFAULTS.aiContext,
					...loadedConfig.aiContext,
				};
			if (loadedConfig.reporting)
				this.config.reporting = {
					...ConfigService.DEFAULTS.reporting,
					...loadedConfig.reporting,
				};
			if (loadedConfig.project)
				this.config.project = {
					...ConfigService.DEFAULTS.project,
					...loadedConfig.project,
				};
			if (loadedConfig.audit)
				this.config.audit = {
					...ConfigService.DEFAULTS.audit,
					...loadedConfig.audit,
				};
			if (loadedConfig.refactor)
				this.config.refactor = {
					...ConfigService.DEFAULTS.refactor,
					...loadedConfig.refactor,
				};
		} else {
			this.config = ConfigService.DEFAULTS;
		}

		this.rootTarget = path.resolve(
			process.cwd(),
			this.config.project.targetPath
		);
		if (!fs.existsSync(this.rootTarget)) {
			// Kita kasih warning aja kalau di constructor, jangan exit process dulu (biar Init command tetep bisa jalan kalau path salah)
			// Tapi karena InitCommand biasanya gak manggil constructor ini, aman.
		}
	}

	get() {
		return this.config;
	}
}
