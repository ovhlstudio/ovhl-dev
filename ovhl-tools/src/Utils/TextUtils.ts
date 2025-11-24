export const TextUtils = {
    formatBytes(bytes: number, decimals = 2) {
        if (!+bytes) return '0 Bytes';
        const k = 1024;
        const dm = decimals < 0 ? 0 : decimals;
        const sizes = ['Bytes', 'KB', 'MB', 'GB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return `${parseFloat((bytes / Math.pow(k, i)).toFixed(dm))} ${sizes[i]}`;
    },

    addLineNumbers(text: string): string {
        const lines = text.split('\n');
        // Format: 0001 | code
        return lines.map((line, i) => {
            const num = (i + 1).toString().padStart(4, ' ');
            return `${num} | ${line}`;
        }).join('\n');
    },

    smartTruncate(text: string, maxLines: number, filename: string): string {
        const lines = text.split('\n');
        const total = lines.length;

        if (total <= maxLines) {
            return this.addLineNumbers(text);
        }

        const headCount = Math.floor(maxLines * 0.6);
        const tailCount = Math.floor(maxLines * 0.4);
        const hidden = total - headCount - tailCount;

        const head = lines.slice(0, headCount);
        const tail = lines.slice(total - tailCount);

        const headStr = this.addLineNumbers(head.join('\n'));
        
        // Custom logic for tail line numbers
        const tailStr = tail.map((line, i) => {
             const num = (total - tailCount + i + 1).toString().padStart(4, ' ');
             return `${num} | ${line}`;
        }).join('\n');

        return `${headStr}
      ... [TRUNCATED: ${hidden} lines hidden by OVHL Tool for AI efficiency] ...
${tailStr}`;
    }
};