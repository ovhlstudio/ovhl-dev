import { Command } from 'commander';

export interface ICommand {
    id: string;
    command: string;
    description: string;
    icon: string;
    register(program: Command): void;
    execute(options: any): Promise<void>;
}