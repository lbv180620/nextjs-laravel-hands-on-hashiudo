
const { merge } = require('webpack-merge');
const common = require('./webpack.common');
const BrowserSyncPlugin = require('browser-sync-webpack-plugin');
const path = require('path');

const outputFile = '[name].bundle';
const assetFile = '[name]';

const srcDir = 'resources';
const htmlDistDir = 'public';
const distPath = 'public';
const publicPath = 'http://localhost:8081';

const getEntriesPlugin = require('./webpack/utils/getEntriesPlugin');
const entries = getEntriesPlugin(srcDir);
const htmlGlobPlugin = require('./webpack/utils/htmlGlobPlugin');

module.exports = () => merge(common({ outputFile, assetFile, htmlDistDir, distPath, publicPath }), {
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
            proxy: publicPath,
            open: false
        }),

        /**
         * 静的ファイルの出力先を変更できる
         */
        // backend用 (Laravelプロジェクト内にビルドしたファイルを出力する場合)
        // ...htmlGlobPlugin(entries, ...[path.join(__dirname, `${srcDir}/templates`), path.join(__dirname, `${htmlDistDir}/views/pages`), 'blade.php', 'blade.php'])
        // frontend用 (CROSを利用する場合)
        ...htmlGlobPlugin(entries, ...[path.join(__dirname, `${srcDir}/templates`), path.join(__dirname, `${htmlDistDir}`)])
    ]
});
