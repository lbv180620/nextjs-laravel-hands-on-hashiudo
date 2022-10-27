const path = require('path');
const glob = require('glob');

/**
 * entryオプションを動的に指定する
 *
 * @param {*} srcDir
 * @returns '{entryName: resource, ...}'
 */
module.exports = function getEntriesPlugin(srcDir = './src') {
    const entries = glob.sync("**/*.+(js|jsx|ts|tsx)", {
        cwd: srcDir,
        ignore: [
            "**/_*.+(js|jsx|ts|tsx)",
            "__test__/**/*",
            "tests/**/*",
            "**/*.spec.+(js|jsx|ts|tsx)",
            "**/setupTests.+(js|jsx|ts|tsx)",
            "js/app.js",
            "js/bootstrap.js",
        ]
    }).map(file => [path.basename(file, path.extname(file)), path.resolve(srcDir, file)]);

    return Object.fromEntries(entries);
}
