export interface IOVHLConfig {
	project: {
		targetPath: string;
		rojoFile: string;
	};
	refactor?: {
		loaderPath?: string;
	};
	aiContext?: {
		architecture: string[];
		lifecycle: string;
		testing: string;
	};
	reporting: {
		outputDir: string;
		timestampFormat: string;
		maxHistory: number;
		naming: {
			markdown: string;
			json: string;
		};
		layout: string[];
	};
	audit: {
		ignore: string[];
		maxSnapshotLines: number;
	};
	penalties: {
		raceCondition: number;
		globalState: number;
		missingTelemetry: number;
	};
}
