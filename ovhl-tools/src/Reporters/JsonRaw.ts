import fs from 'fs-extra';
import { IAuditContext } from '../Types/AuditResult.js';

export class JsonRaw {
    save(ctx: IAuditContext, fullPath: string) {
        // Convert Map to Array for JSON serialization
        const exportData = {
            ...ctx,
            results: Array.from(ctx.results.values())
        };
        fs.writeJsonSync(fullPath, exportData, { spaces: 2 });
    }
}