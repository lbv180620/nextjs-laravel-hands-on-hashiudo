const TerserPlugin = require('terser-webpack-plugin');
const CssMinimizerPlugin = require('css-minimizer-webpack-plugin');

const path = require('path');
const { merge } = require('webpack-merge');
const common = require('./webpack.common');

const outputFile = '[name]=[chunkhash]';
const assetFile = '[contenthash]';

const srcDir = 'resources';

// backend用設定 (Laravelプロジェクト内にビルドしたファイルを出力する場合)
// const htmlDistDir = '../backend/resources';
// const htmlDistDir = '../backend/public';
// const distPath = '../backend/public';
// const publicPath = 'http://localhost:8080';

// frontend用設定 (CROSを利用する場合)
const htmlDistDir = 'public';
const distPath = 'public';
const publicPath = 'http://localhost:8081';

const getEntriesPlugin = require('./webpack/utils/getEntriesPlugin');
const entries = getEntriesPlugin(srcDir);
const htmlGlobMinifyPlugin = require('./webpack/utils/htmlGlobMinifyPlugin');

module.exports = (env, argv) => {

    const isProd = argv.mode === "production";
    if (isProd) {
        process.env.NODE_ENV = "production";
    }

    return merge(common({ outputFile, assetFile, htmlDistDir, distPath, publicPath }), {
        // mode: 'production',

      plugins: [
            /**
             * 静的ファイルの出力先を変更できる
             */
            // backend用 (Laravelプロジェクト内にビルドしたファイルを出力する場合)
            // ...htmlGlobMinifyPlugin(entries, ...[path.join(__dirname, `${srcDir}/templates`), path.join(__dirname, `${htmlDistDir}/views/pages`), 'blade.php', 'blade.php'])
            // frontend用 (CROSを利用する場合)
            ...htmlGlobMinifyPlugin(entries, ...[path.join(__dirname, `${srcDir}/templates`), path.join(__dirname, `${htmlDistDir}`), 'php', 'php'])
        ],

        optimization: {
            minimizer: [
                new TerserPlugin(),
                new CssMinimizerPlugin()
            ]
        }
    });
};
