
const { merge } = require('webpack-merge');
const common = require('./webpack.common');
const BrowserSyncPlugin = require('browser-sync-webpack-plugin');
const path = require('path');

const outputFile = '[name].bundle';
const assetFile = '[name]';

const srcDir = 'resources';
const htmlDistDir = 'resources';
const getEntriesPlugin = require('./webpack/utils/getEntriesPlugin');
const entries = getEntriesPlugin(srcDir);
const htmlGlobPlugin = require('./webpack/utils/htmlGlobPlugin');

module.exports = () => merge(common({ outputFile, assetFile, htmlDistDir }), {
    mode: 'development',
    devtool: 'source-map',
    watch: true,
    watchOptions: {
        ignored: ['node_modules/**']
    },
    plugins: [
        new BrowserSyncPlugin({
            host: 'localhost',
            port: 2000,
            proxy: 'http://localhost:8080',
            open: false
        }),

        ...htmlGlobPlugin(entries, ...[path.join(__dirname, `${srcDir}/templates`), path.join(__dirname, `${htmlDistDir}/views/pages`), 'blade.php', 'blade.php'])
    ]
});
