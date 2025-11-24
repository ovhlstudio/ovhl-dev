import figlet from 'figlet';
import chalk from 'chalk';
import boxen from 'boxen';

export const UX = {
    header() {
        console.log(chalk.cyan(figlet.textSync('OVHL CLI', { horizontalLayout: 'full' })));
        console.log(chalk.dim('v3.5.0 - Enterprise Framework Toolkit\n'));
    },

    summaryBox(filePath: string, score: number) {
        let color = score >= 80 ? 'green' : (score >= 60 ? 'yellow' : 'red');
        const text = [
            `✅ Audit Complete!`,
            ``,
            `📁 Report: ${chalk.underline(filePath)}`,
            `⚖️  Score:  ${score}/100`
        ].join('\n');
        
        console.log(boxen(text, { 
            padding: 1, 
            margin: 1, 
            borderStyle: 'round', 
            borderColor: color 
        }));
    }
};