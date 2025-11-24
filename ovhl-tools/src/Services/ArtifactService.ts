import fs from 'fs-extra';
import path from 'path';
import fastGlob from 'fast-glob';
import { TimeService } from './TimeService.js';
import { IOVHLConfig } from '../Types/Config.js';

export class ArtifactService {
    private config: IOVHLConfig['reporting'];

    constructor(config: IOVHLConfig) {
        this.config = config.reporting;
    }

    // Generate Path & Rotate Old Files
    public async preparePath(format: 'markdown' | 'json'): Promise<string> {
        const subDir = format; // 'markdown' or 'json'
        const dirPath = path.join(process.cwd(), this.config.outputDir, subDir);
        
        fs.ensureDirSync(dirPath);

        // 1. Generate Filename
        const timeStr = TimeService.format(this.config.timestampFormat);
        const nameTemplate = this.config.naming[format];
        const filename = nameTemplate.replace('{TIMESTAMP}', timeStr) + (format === 'markdown' ? '.md' : '.json');
        const fullPath = path.join(dirPath, filename);

        // 2. Rotation Logic (Housekeeping)
        await this.rotate(dirPath, format);

        return fullPath;
    }

    private async rotate(dir: string, format: 'markdown' | 'json') {
        try {
            // Ambil prefix file untuk pattern matching (misal "ovhl-data-")
            const template = this.config.naming[format];
            const prefix = template.split('{TIMESTAMP}')[0]; 
            
            // Scan file yang sesuai pattern di folder target
            const files = await fastGlob(`${prefix}*`, { cwd: dir, absolute: true });
            
            // Sort: Terlama di index 0
            files.sort((a, b) => fs.statSync(a).mtime.getTime() - fs.statSync(b).mtime.getTime());

            const excess = files.length - this.config.maxHistory;
            if (excess >= 0) { // Delete files to make room for the NEW one (so keep N-1)
                const toDelete = files.slice(0, excess + 1); // +1 karena kita akan nulis file baru
                for (const file of toDelete) {
                    fs.unlinkSync(file);
                    // console.log(`🗑️ Rotated: ${path.basename(file)}`);
                }
            }
        } catch (e) {
            console.error("⚠️ Rotation failed:", e);
        }
    }
}