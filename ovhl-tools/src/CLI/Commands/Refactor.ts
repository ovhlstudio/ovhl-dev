import { Command } from "commander";
import fs from "fs-extra";
import path from "path";
import fastGlob from "fast-glob";
import chalk from "chalk";
import { confirm } from "@inquirer/prompts";
import { ICommand } from "../ICommand.js";
import { ConfigService } from "../../Services/ConfigService.js";

interface IReplacementRule {
	alias: string;
	targetPath: string;
	regex: RegExp;
}

export default class RefactorCommand implements ICommand {
	id = "99_Refactor";
	command = "refactor";
	description = "🚑 Auto-upgrade codebase to Level 4 (Loader.Get)";
	icon = "🛠️ ";

	register(program: Command) {
		program
			.command(this.command)
			.description(this.description)
			.option("--apply", "Skip confirmation and apply immediately")
			.action(async (opts) => this.execute(opts));
	}

	async execute(opts: any) {
		const configService = new ConfigService();
		const config = configService.get();
		const rootPath = configService.rootTarget;
		const isDryRun = !opts.apply;

		console.log(
			chalk.bold.blue(`\n🚀 OVHL REFACTOR ENGINE (Smart Loader V4)`)
		);
		console.log(chalk.gray(`Target Root: ${rootPath}`));

		// 1. LOCATE LOADER
		let loaderRelativePath = config.refactor?.loaderPath;
		let loaderFullPath = "";

		if (loaderRelativePath) {
			loaderFullPath = path.join(rootPath, loaderRelativePath);
			if (!fs.existsSync(loaderFullPath)) {
				console.warn(
					chalk.yellow(
						`⚠️  Configured 'refactor.loaderPath' not found.`
					)
				);
				loaderRelativePath = undefined;
			}
		}

		if (!loaderRelativePath) {
			const candidates = await fastGlob(["**/OVHL/**/Loader.luau"], {
				cwd: rootPath,
			});
			if (candidates.length === 0) {
				console.error(
					chalk.red(`❌ Critical: Could not locate Loader.luau.`)
				);
				return;
			}
			loaderRelativePath = candidates[0];
			loaderFullPath = path.join(rootPath, loaderRelativePath);
			console.log(
				chalk.gray(`📍 Auto-detected Loader at: ${loaderRelativePath}`)
			);
		} else {
			console.log(
				chalk.gray(`📍 Using Configured Loader: ${loaderRelativePath}`)
			);
		}

		// 2. PARSE LOADER RULES
		const rules = await this.generateRulesFromLoader(loaderFullPath);
		if (rules.length === 0) return;

		console.log(
			chalk.cyan(
				`\n[INFO] Generated ${rules.length} smart replacement rules`
			)
		);

		// 3. DRY RUN
		const potentialChanges = await this.runSurgery(
			rootPath,
			rules,
			true,
			loaderRelativePath!
		);

		if (potentialChanges === 0) {
			console.log(
				chalk.green(
					"\n✨ No changes needed. Codebase is already up to date!"
				)
			);
			return;
		}

		// 4. CONFIRMATION
		if (!opts.apply) {
			console.log(
				chalk.dim(
					"\n---------------------------------------------------"
				)
			);
			const shouldApply = await confirm({
				message: `Found ${chalk.yellow(potentialChanges)} lines to change. Apply updates now?`,
				default: true,
			});

			if (!shouldApply) {
				console.log(chalk.yellow("\n🚫 Operation Cancelled."));
				return;
			}
		}

		// 5. EXECUTE
		console.log(chalk.bold("\n💉 Applying Fixes..."));
		await this.runSurgery(rootPath, rules, false, loaderRelativePath!);
	}

	private async generateRulesFromLoader(
		loaderFullPath: string
	): Promise<IReplacementRule[]> {
		const content = await fs.readFile(loaderFullPath, "utf-8");
		const rules: IReplacementRule[] = [];

		// --- PARSER 1: Standard ROOTS Mapping ---
		// Matches: ["Alias"] = ROOTS.Path...
		const rootsRegex =
			/\["([a-zA-Z0-9_]+)"\]\s*=\s*(ROOTS\.[a-zA-Z0-9_.]+)/g;
		let match;
		while ((match = rootsRegex.exec(content)) !== null) {
			const alias = match[1];
			const rawPath = match[2];
			let regexPattern = "";

			if (rawPath.includes("ROOTS.OVHL")) {
				// Convert ROOTS.OVHL.X.Y -> Loader.X("Y") or Loader.X.Y
				const relativeStruct = rawPath.replace("ROOTS.OVHL.", "");
				const segments = relativeStruct.split(".");
				const rootSegment = segments[0];
				const restSegments = segments.slice(1).join("[./]"); // Handle slash or dot

				// Regex captures: Loader.Core.Path OR Loader.Core("Path")
				regexPattern = `Loader\\.${rootSegment}(?:[("'.\\s]+)${restSegments}(?:[)"']*)?`;
			} else if (rawPath.includes("ROOTS.Packages")) {
				// Fallback for explicit ROOTS packages
				const pkgName = rawPath.split(".").pop();
				if (rawPath.includes('["')) continue;
				regexPattern = `Loader\\.Pkg(?:[("'.]+)${pkgName}(?:[)"']*)?`;
			}

			if (regexPattern) {
				rules.push({
					alias,
					targetPath: rawPath,
					regex: new RegExp(regexPattern, "g"),
				});
			}
		}

		// --- PARSER 2: findPkg Mapping (NEW) ---
		// Matches: ["Onyx"] = findPkg("onyx-ui")
		const pkgRegex = /\["([a-zA-Z0-9_]+)"\]\s*=\s*findPkg\("([^"]+)"\)/g;
		while ((match = pkgRegex.exec(content)) !== null) {
			const alias = match[1]; // e.g. Onyx
			const pkgName = match[2]; // e.g. onyx-ui

			// Create rule to replace Loader.Pkg("onyx-ui") -> Loader.Get("Onyx")
			// Supports: Loader.Pkg("onyx-ui") OR Loader.Pkg.onyx-ui (if strictly compliant names)
			// Note: Escape dashes in pkgName for regex safety
			const safePkgName = pkgName.replace(/-/g, "\\-");
			const regexPattern = `Loader\\.Pkg(?:[("'.]+)${safePkgName}(?:[)"']*)?`;

			rules.push({
				alias,
				targetPath: `Package:${pkgName}`,
				regex: new RegExp(regexPattern, "g"),
			});
		}

		// Sort by regex length (Safety Priority)
		rules.sort((a, b) => b.targetPath.length - a.targetPath.length);

		return rules;
	}

	private async runSurgery(
		rootPath: string,
		rules: IReplacementRule[],
		isDryRun: boolean,
		loaderRelPath: string
	): Promise<number> {
		const srcPath = path.join(rootPath, "src");

		if (!isDryRun) {
			const backupPath = path.join(rootPath, `src_BACKUP_${Date.now()}`);
			console.log(
				chalk.gray(
					`📦 Creating backup at ${path.basename(backupPath)}...`
				)
			);
			await fs.copy(srcPath, backupPath);
		}

		const files = await fastGlob(["**/*.{lua,luau}"], { cwd: srcPath });
		let totalLinesChanged = 0;

		for (const file of files) {
			if (
				file.replace(/\\/g, "/") ===
				loaderRelPath.replace("src/", "").replace(/\\/g, "/")
			)
				continue;

			const fullPath = path.join(srcPath, file);
			const originalContent = await fs.readFile(fullPath, "utf-8");

			const lines = originalContent.split("\n");
			const newLines: string[] = [];
			let fileHasChange = false;
			let fileHeaderPrinted = false;

			for (let i = 0; i < lines.length; i++) {
				const line = lines[i];
				let newLine = line;

				for (const rule of rules) {
					if (rule.regex.test(newLine)) {
						newLine = newLine.replace(
							rule.regex,
							`Loader.Get("${rule.alias}")`
						);
					}
				}

				if (newLine !== line) {
					fileHasChange = true;
					totalLinesChanged++;

					if (isDryRun) {
						if (!fileHeaderPrinted) {
							console.log(chalk.yellow.bold(`\n📄 ${file}`));
							fileHeaderPrinted = true;
						}
						console.log(chalk.gray(`   Line ${i + 1}:`));
						console.log(chalk.red(`   - ${line.trim()}`));
						console.log(chalk.green(`   + ${newLine.trim()}`));
					}
				}
				newLines.push(newLine);
			}

			if (fileHasChange && !isDryRun) {
				console.log(chalk.green(`   📝 Patched: ${file}`));
				await fs.writeFile(fullPath, newLines.join("\n"), "utf-8");
			}
		}

		if (!isDryRun) {
			console.log(chalk.bold(`\n🏁 Operation Complete.`));
			console.log(
				`   Successfully updated ${chalk.green(totalLinesChanged)} lines of code.`
			);
			console.log(
				chalk.bgBlue.white(` INFO `) + ` Check Roblox Studio to verify.`
			);
		}

		return totalLinesChanged;
	}
}
