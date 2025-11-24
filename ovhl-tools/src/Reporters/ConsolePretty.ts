import Table from 'cli-table3';
import chalk from 'chalk';
import { IAuditContext } from '../Types/AuditResult.js';

export class ConsolePretty {
    print(ctx: IAuditContext) {
        const table = new Table({
            head: [
                chalk.white.bold('Module'), 
                chalk.white.bold('Status'), 
                chalk.white.bold('Issues'),
                chalk.white.bold('Time')
            ],
            colWidths: [35, 15, 10, 10],
            style: { head: [], border: [] }
        });

        const layout = ctx.config.reporting.layout || [];
        
        layout.forEach(id => {
            const res = ctx.results.get(id);
            if(res) {
                const count = res.issues.length;
                let status = chalk.green('✅ PASS');
                let countStr = chalk.dim('-');

                if (count > 0) {
                    const hasCritical = res.issues.some(i => i.type === 'CRITICAL');
                    if (hasCritical) {
                        status = chalk.red('🔴 FAIL');
                        countStr = chalk.red(count.toString());
                    } else {
                        status = chalk.yellow('⚠️ WARN');
                        countStr = chalk.yellow(count.toString());
                    }
                }

                const time = res.duration ? `${res.duration}ms` : '-';
                
                // Truncate title if too long
                let title = res.title;
                if (title.length > 30) title = title.substring(0, 27) + '...';

                table.push([title, status, countStr, chalk.dim(time)]);
            }
        });

        console.log(table.toString());
    }
}