import { IAuditIssue } from '../Types/AuditResult.js';

export class ScoringEngine {
    static calculate(currentScore: number, issues: IAuditIssue[]): number {
        let newScore = currentScore;
        issues.forEach(issue => {
            newScore -= (issue.penalty || 0);
        });
        return Math.max(0, newScore);
    }

    static getGrade(score: number): string {
        if (score >= 90) return 'A';
        if (score >= 80) return 'B';
        if (score >= 70) return 'C';
        if (score >= 60) return 'D';
        return 'F';
    }
}