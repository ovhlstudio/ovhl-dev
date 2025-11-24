import { execSync } from 'child_process';
import path from 'path';

export class GitService {
    private root: string;
    public isGit: boolean = false;

    constructor(root: string) {
        this.root = root;
        try {
            // Pastikan CWD diarahkan ke ROOT TARGET, bukan process.cwd()
            execSync('git rev-parse --is-inside-work-tree', { stdio: 'ignore', cwd: this.root });
            this.isGit = true;
        } catch {
            this.isGit = false;
        }
    }

    getShortInfo() {
        if (!this.isGit) return 'Not a Git Repository';
        try {
            const branch = execSync('git rev-parse --abbrev-ref HEAD', { cwd: this.root }).toString().trim();
            const commit = execSync('git rev-parse --short HEAD', { cwd: this.root }).toString().trim();
            // Cek status clean/dirty
            const status = execSync('git status --porcelain', { cwd: this.root }).toString();
            const dirty = status ? '*' : '';
            return `Branch: ${branch} | Commit: ${commit}${dirty}`;
        } catch {
            return 'Git Error';
        }
    }

    getFileAtRevision(filePath: string, revision = 'HEAD~1'): string | null {
        if (!this.isGit) return null;
        try {
            const relPath = path.relative(this.root, filePath).replace(/\\/g, '/');
            return execSync(`git show ${revision}:${relPath}`, { cwd: this.root, stdio: ['pipe', 'pipe', 'ignore'] }).toString();
        } catch (e) {
            return null;
        }
    }

    getDiffStat() {
        if (!this.isGit) return '';
        try {
            return execSync('git diff --stat', { cwd: this.root }).toString();
        } catch {
            return '';
        }
    }
}