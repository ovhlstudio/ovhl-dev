import fs from 'fs-extra';
import fastGlob from 'fast-glob';

// Centralized FS Wrapper for easier mocking/replacement
export const FileSystem = {
    exists: fs.existsSync,
    readFile: fs.readFile,
    writeFile: fs.writeFile,
    ensureDir: fs.ensureDirSync,
    glob: fastGlob
};