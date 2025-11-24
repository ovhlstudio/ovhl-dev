import { Command } from "commander";
import fs from "fs-extra";
import path from "path";
import chalk from "chalk";
import { ICommand } from "../ICommand.js";
// Import ConfigService buat nyontek Defaults
import { ConfigService } from "../../Services/ConfigService.js";

export default class InitCommand implements ICommand {
	id = "00_Init";
	command = "init";
	description = "Generate configuration file (Standard Enterprise)";
	icon = "⚙️ ";

	register(program: Command) {
		program
			.command(this.command)
			.description(this.description)
			.action(async () => this.execute({}));
	}

	async execute(_opts: any) {
		const targetPath = path.join(process.cwd(), "ovhl.config.json");

		if (fs.existsSync(targetPath)) {
			console.log(
				chalk.yellow(
					"⚠️  Config file already exists. Delete it first if you want to regenerate."
				)
			);
			return;
		}

		// [MAGIC] Ambil template langsung dari SSOT (Single Source of Truth)
		const configTemplate = ConfigService.DEFAULTS;

		fs.writeFileSync(targetPath, JSON.stringify(configTemplate, null, 2)); // Indent 2 spasi biar cantik

		console.log(chalk.green(`\n✅ OVHL Enterprise Config generated at:`));
		console.log(chalk.gray(targetPath));
		console.log(chalk.cyan("\nNext Steps:"));
		console.log(`1. Open ${chalk.bold("ovhl.config.json")}`);
		console.log(
			`2. Adjust ${chalk.bold("targetPath")} to point to your project root.`
		);
		console.log(`3. Run ${chalk.bold("ovhl audit")} to verify.`);
	}
}
