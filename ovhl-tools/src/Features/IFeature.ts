import { Context } from '../Core/Context.js';

export interface IFeature {
    id: string;
    name: string; // Tampil di menu
    description?: string;
    
    // Logic utama plugin
    run(context: Context): Promise<void>;
}