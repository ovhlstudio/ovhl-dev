import { IAuditContext, IAuditSection } from '../Types/AuditResult.js';
import { RojoService } from '../Services/RojoService.js';

export class Context {
    public data: IAuditContext;
    public services: { rojo: RojoService };

    constructor(rootPath: string, config: any, rojoService: RojoService) {
        this.services = { rojo: rojoService };
        this.data = {
            rootPath,
            config,
            timestamp: new Date().toISOString(),
            results: new Map<string, IAuditSection>(), // Updated to Map
            globalScore: 100
        };
    }

    // ID wajib diisi agar layout engine bisa bekerja
    addSection(id: string, title: string, content: string, issues: any[] = []) {
        this.data.results.set(id, { id, title, content, issues });
        
        issues.forEach(i => {
            this.data.globalScore = Math.max(0, this.data.globalScore - (i.penalty || 0));
        });
    }
}