import { Command } from 'commander';
import chalk from 'chalk';
import figlet from 'figlet';
import boxen from 'boxen';
import { select } from '@inquirer/prompts';
import { CommandRegistry } from './CommandRegistry.js';

const program = new Command();
const registry = new CommandRegistry();

function showBanner() {
    console.clear();
    console.log(chalk.cyan(figlet.textSync('OVHL', { font: 'Slant', horizontalLayout: 'default' })));
    
    const meta = 
        chalk.bold(' Version ') + chalk.green('0.1.0') + chalk.dim(' | ') +
        chalk.bold(' Enterprise SDK ') + chalk.dim(' | ') +
        chalk.bold(' Node.js ') + chalk.green(process.version);
    
    console.log(boxen(meta, { 
        padding: 0, 
        borderStyle: 'classic', 
        borderColor: 'gray',
        dimBorder: true
    }));
    console.log('');
}

async function bootstrap() {
    await registry.loadCommands();
    const commands = registry.getCommands();

    program
        .name('ovhl')
        .description('OVHL Enterprise Developer Toolkit')
        .version('0.1.0');

    commands.forEach(cmd => cmd.register(program));

    // DEFAULT ACTION: HUB UI
    if (process.argv.length <= 2) {
        showBanner();
        
        const choices = commands.map(cmd => ({
            name: `${cmd.icon}  ${cmd.command.padEnd(12)} ${chalk.dim(cmd.description)}`,
            value: cmd
        }));
        
        choices.push({ name: '🚪  Exit', value: null as any });

        try {
            const selectedCommand = await select({
                message: 'Select Tool to launch:',
                choices: choices,
                pageSize: 10
            });

            if (selectedCommand) {
                console.log('');
                await selectedCommand.execute({});
            } else {
                process.exit(0);
            }
        } catch (e) {
            process.exit(0);
        }
    } else {
        program.parse(process.argv);
    }
}

bootstrap();