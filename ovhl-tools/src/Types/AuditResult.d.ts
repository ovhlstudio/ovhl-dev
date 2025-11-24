export interface IAuditIssue {
    type: 'CRITICAL' | 'WARNING' | 'INFO';
    title: string;
    message: string;
    file?: string;
    line?: number;
    snippet?: string;
    penalty: number;
}

export interface IAuditSection {
    id: string;
    title: string;
    content: string;
    issues: IAuditIssue[];
    duration?: number; // 🔥 NEW: Execution time in ms
}

export interface IAuditContext {
    rootPath: string;
    timestamp: string;
    results: Map<string, IAuditSection>;
    globalScore: number;
    config: any;
    metadata?: {
        duration: string;
        command: string;
        version: string;
        gitInfo?: string;
        rojoMapping?: string;
    };
}