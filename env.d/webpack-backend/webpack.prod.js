const TerserPlugin = require('terser-webpack-plugin');
const CssMinimizerPlugin = require('css-minimizer-webpack-plugin');

const path = require('path');
const { merge } = require('webpack-merge');
const common = require('./webpack.common');

const outputFile = '[name]=[chunkhash]';
const assetFile = '[contenthash]';

const srcDir = 'resources';
const htmlDistDir = 'resources';
const getEntriesPlugin = require('./webpack/utils/getEntriesPlugin');
const entries = getEntriesPlugin(srcDir);
const htmlGlobMinifyPlugin = require('./webpack/utils/htmlGlobMinifyPlugin');

module.exports = (env, argv) => {

    const isProd = argv.mode === "production";
    if (isProd) {
        process.env.NODE_ENV = "production";
    }

    return merge(common({ outputFile, assetFile, htmlDistDir }), {
        // mode: 'production',

        plugins: [
            ...htmlGlobMinifyPlugin(entries, ...[path.join(__dirname, `${srcDir}/templates`), path.join(__dirname, `${htmlDistDir}/views/pages`), 'blade.php', 'blade.php'])
        ],

        optimization: {
            minimizer: [
                new TerserPlugin(),
                new CssMinimizerPlugin()
            ]
        }
    });
};
