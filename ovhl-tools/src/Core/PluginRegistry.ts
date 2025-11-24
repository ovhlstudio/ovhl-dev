import fastGlob from 'fast-glob';
import path from 'path';
import { fileURLToPath, pathToFileURL } from 'url';
import { IFeature } from '../Features/IFeature.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export class PluginRegistry {
    private plugins: IFeature[] = [];

    async loadPlugins() {
        // [FIX 1] Dual Extension Support (Dev vs Prod)
        // Mencari .ts (saat dev) DAN .js (saat production/build)
        const pattern = path.join(__dirname, '../Features/{Analyzers,Extractors}/*.{ts,js}').replace(/\\/g, '/');
        
        const files = await fastGlob(pattern);

        for (const file of files) {
            try {
                // [FIX 2] Windows Path Safety
                // Absolute path Windows (E:\...) bikin import() crash.
                // Harus diubah jadi URL (file:///E:/...)
                const fileUrl = pathToFileURL(file).href;
                
                const module = await import(fileUrl);
                
                // Robust Class Detection
                const PluginClass = module.default || Object.values(module)[0];
                
                if (typeof PluginClass === 'function') {
                    const instance = new (PluginClass as any)();
                    // Validasi Interface IFeature
                    if (instance.id && instance.run && instance.name) {
                        this.plugins.push(instance);
                    }
                }
            } catch (e) {
                console.error(`❌ Failed to load plugin: ${file}`, e);
            }
        }
        
        // Sort by ID agar urutan menu konsisten
        this.plugins.sort((a, b) => a.id.localeCompare(b.id));
    }

    getPlugins() { return this.plugins; }
    getPlugin(id: string) { return this.plugins.find(p => p.id === id); }
}