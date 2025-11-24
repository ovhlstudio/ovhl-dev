import fastGlob from 'fast-glob';
import path from 'path';
import { fileURLToPath, pathToFileURL } from 'url';
import { ICommand } from './ICommand.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export class CommandRegistry {
    private commands: ICommand[] = [];

    async loadCommands() {
        // [FIX 1] Dual Extension Support
        const pattern = path.join(__dirname, './Commands/*.{ts,js}').replace(/\\/g, '/');
        
        const files = await fastGlob(pattern);

        for (const file of files) {
            // Skip Base Class / Abstract / Interfaces
            if (file.includes('_Base') || file.includes('ICommand')) continue;

            try {
                // [FIX 2] Windows Path Safety
                const fileUrl = pathToFileURL(file).href;
                
                const module = await import(fileUrl);
                const CommandClass = module.default || Object.values(module)[0];

                if (typeof CommandClass === 'function') {
                    const instance = new (CommandClass as any)();
                    // Validasi Interface ICommand
                    if (instance.command && instance.execute) {
                        this.commands.push(instance);
                    }
                }
            } catch (e) {
                console.error(`❌ Failed to load command: ${file}`, e);
            }
        }
        
        this.commands.sort((a, b) => a.id.localeCompare(b.id));
    }

    getCommands() { return this.commands; }
}