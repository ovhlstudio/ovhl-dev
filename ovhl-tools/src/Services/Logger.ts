import chalk from 'chalk';

export class Logger {
    static info(msg: string) { console.log(chalk.blue('ℹ ' + msg)); }
    static success(msg: string) { console.log(chalk.green('✔ ' + msg)); }
    static warn(msg: string) { console.log(chalk.yellow('⚠ ' + msg)); }
    static error(msg: string, err?: any) { 
        console.log(chalk.red('✖ ' + msg));
        if(err) console.error(err);
    }
    static dim(msg: string) { console.log(chalk.dim(msg)); }
}