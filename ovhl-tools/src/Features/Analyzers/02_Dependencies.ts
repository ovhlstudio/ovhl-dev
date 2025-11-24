import fastGlob from "fast-glob";
import fs from "fs-extra";
import path from "path";
import { IFeature } from "../IFeature.js";
import { Context } from "../../Core/Context.js";
import { WallyService } from "../../Services/WallyService.js";

export default class DependencyAnalyzer implements IFeature {
	id = "02_Dependencies";
	name = "🔗 Dependency Graph";
	description =
		"Analyzes internal coupling, circular dependencies, and Wally packages";

	async run(ctx: Context): Promise<void> {
		const root = ctx.data.rootPath;
		const loaderMethods = ctx.data.config.analysis?.loaderMethods || [
			"Get",
			"Pkg",
			"Find",
		];

		const wally = new WallyService(root);
		await wally.scan();

		// [FIX] Anti-Crash Loader Parser
		let aliasMap = new Map<string, string>();
		try {
			aliasMap = await this.parseLoaderAliases(root);
		} catch (e) {
			console.warn(
				"⚠️ Dependency Analyzer: Failed to parse Loader aliases. Falling back to standard scan."
			);
		}

		const files = await fastGlob(["src/**/*.{lua,luau}"], { cwd: root });

		let loaderCoreCount = 0;
		let loaderGetCount = 0;
		const pkgUsage: Record<string, number> = {};

		// Graph for Circular Detection
		const depGraph: Map<string, string[]> = new Map();

		// Init pkg counters
		wally.packages.forEach((_, name) => (pkgUsage[name] = 0));

		for (const file of files) {
			const content = await fs.readFile(path.join(root, file), "utf-8");
			const fileName = path
				.basename(file)
				.replace(/(\.server|\.client)?\.luau?$/, "");

			// 1. Check Internal Coupling
			if (content.includes("Loader.Core")) loaderCoreCount++;

			// Check usage of Loader.Get(...)
			const getRegex = /Loader\.Get\s*\(\s*["']([^"']+)["']\s*\)/g;
			let match;
			const dependencies: string[] = [];

			while ((match = getRegex.exec(content)) !== null) {
				loaderGetCount++;
				const depName = match[1];
				dependencies.push(depName);
			}

			depGraph.set(fileName, dependencies);

			// 2. Check External Usage (Support Alias)
			wally.packages.forEach((_, pkgName) => {
				// Cek nama asli (Loader.Get("onyx-ui"))
				let isUsed = wally.isUsed(pkgName, content, loaderMethods);

				// Cek alias (Loader.Get("Onyx"))
				if (!isUsed) {
					for (const [alias, targetPkg] of aliasMap.entries()) {
						// Logic fuzzy match sederhana: apakah targetPkg mengandung nama paket wally?
						if (
							targetPkg
								.toLowerCase()
								.includes(pkgName.toLowerCase())
						) {
							// Cek apakah alias dipanggil di kode
							// Kita pake regex manual disini karena wally.isUsed nyari pkgName
							const aliasRegex = new RegExp(
								`Loader\\.Get\\(["']${alias}["']\\)`,
								"i"
							);
							if (aliasRegex.test(content)) {
								isUsed = true;
								break;
							}
						}
					}
				}

				if (isUsed) pkgUsage[pkgName]++;
			});
		}

		// --- CIRCULAR DEPENDENCY DETECTION (DFS) ---
		const cycles: string[][] = [];
		const visited = new Set<string>();
		const recursionStack = new Set<string>();

		const detectCycle = (node: string, path: string[]) => {
			visited.add(node);
			recursionStack.add(node);

			const neighbors = depGraph.get(node) || [];
			for (const neighbor of neighbors) {
				if (wally.packages.has(neighbor)) continue;

				if (!visited.has(neighbor)) {
					if (depGraph.has(neighbor)) {
						detectCycle(neighbor, [...path, neighbor]);
					}
				} else if (recursionStack.has(neighbor)) {
					cycles.push([...path, neighbor]);
				}
			}
			recursionStack.delete(node);
		};

		for (const [node] of depGraph) {
			if (!visited.has(node)) {
				detectCycle(node, [node]);
			}
		}

		// --- REPORTING ---
		let md = "### 🔗 Dependency Analysis\n\n";

		if (cycles.length > 0) {
			md += "🚨 **CRITICAL: CIRCULAR DEPENDENCIES DETECTED!**\n";
			cycles.forEach((cycle) => {
				md += `- ❌ Loop: \`${cycle.join(" -> ")}\`\n`;
			});
			md += "\n";
		} else {
			md += "✅ **CLEAN: No Circular Dependencies found.**\n\n";
		}

		md += "### 📦 External Packages (Wally)\n";
		md += "| Package | Status | Refs |\n|---|---|---|\n";

		wally.packages.forEach((ver, name) => {
			const count = pkgUsage[name];
			const status = count > 0 ? "✅ Active" : "⚠️ Unused";
			md += `| **${name}** | ${status} | ${count} refs |\n`;
		});

		md += "\n### 🕷️ Module Coupling\n";
		md += `- **Legacy Core Refs:** ${loaderCoreCount}\n`;
		md += `- **Modern Loader Refs:** ${loaderGetCount}\n`;

		md += "\n> **👮‍♂️ OVHL LAW: DEPENDENCIES**\n";
		md += "> *   **No Cycles:** A -> B -> A is forbidden.\n";
		md += "> *   **Wally:** Manage libs via `wally.toml`.\n";

		const issues: any[] = [];
		if (cycles.length > 0) {
			issues.push({
				type: "CRITICAL",
				title: "Circular Dependency",
				message: `Found ${cycles.length} dependency loops.`,
				penalty: 50,
			});
		}

		ctx.addSection(this.id, "🔗 Dependencies", md, issues);
	}

	private async parseLoaderAliases(
		root: string
	): Promise<Map<string, string>> {
		const map = new Map<string, string>();
		try {
			const candidates = await fastGlob(["**/OVHL/**/Loader.luau"], {
				cwd: root,
			});
			if (candidates.length === 0) return map;

			const content = await fs.readFile(
				path.join(root, candidates[0]),
				"utf-8"
			);

			// Regex: ["Alias"] = findPkg("RealName")
			const regex = /\["([a-zA-Z0-9_]+)"\]\s*=\s*findPkg\("([^"]+)"\)/g;
			let match;
			while ((match = regex.exec(content)) !== null) {
				map.set(match[1], match[2]);
			}
		} catch (e) {}
		return map;
	}
}
