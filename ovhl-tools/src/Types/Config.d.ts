export interface IOVHLConfig {
    project: {
        targetPath: string;
        rojoFile: string;
    };
    aiContext?: {
        architecture: string[]; // List of Laws
        lifecycle: string;      // Init -> Start explanation
        testing: string;        // TestEZ rules
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
        missingTelemetry: number; // NEW PENALTY
    };
}