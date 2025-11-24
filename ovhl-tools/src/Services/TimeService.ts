export class TimeService {
    static format(template: string, date: Date = new Date()): string {
        const map: Record<string, string> = {
            'YYYY': date.getFullYear().toString(),
            'MM': (date.getMonth() + 1).toString().padStart(2, '0'),
            'DD': date.getDate().toString().padStart(2, '0'),
            'HH': date.getHours().toString().padStart(2, '0'),
            'mm': date.getMinutes().toString().padStart(2, '0'),
            'ss': date.getSeconds().toString().padStart(2, '0')
        };

        let result = template;
        // Replace tokens (Case sensitive)
        // Kita pakai Replace All manual untuk setiap key
        for (const key in map) {
            // Regex global replace
            result = result.split(key).join(map[key]);
        }
        return result;
    }
}