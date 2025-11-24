import { select, checkbox } from '@inquirer/prompts';
import { PluginRegistry } from '../Core/PluginRegistry.js';

export async function showMainMenu(registry: PluginRegistry) {
    const plugins = registry.getPlugins();
    
    // 1. Action Selection
    const action = await select({
        message: 'Apa yang ingin kamu lakukan?',
        choices: [
            { name: '🚀 One-Hit Audit (Default)', value: 'FULL' },
            { name: '⚙️  Custom Audit (Wizard)', value: 'CUSTOM' },
            { name: '🚪 Keluar', value: 'EXIT' }
        ]
    });

    if (action === 'EXIT') process.exit(0);

    let selectedPlugins = plugins;

    // 2. Plugin Selection (Only for Custom)
    if (action === 'CUSTOM') {
        const pluginChoices = plugins.map(p => ({
            name: p.name,
            value: p,
            checked: true
        }));

        selectedPlugins = await checkbox({
            message: 'Pilih Module Analisis:',
            choices: pluginChoices,
            validate: (choices) => choices.length > 0 ? true : 'Pilih minimal satu module!'
        });
    }

    // 3. Output Selection (SINGLE SELECT NOW)
    const format = await select({
        message: 'Pilih Format Output:',
        choices: [
            { name: '📄 Markdown Only (Standard)', value: 'md' },
            { name: '🤖 JSON Only (Data)', value: 'json' },
            { name: '📦 Both (Markdown + JSON)', value: 'both' }
        ]
    });

    return { 
        plugins: selectedPlugins, 
        format: format // 'md' | 'json' | 'both'
    };
}