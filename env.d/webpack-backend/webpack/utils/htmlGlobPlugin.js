const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');

/**
 * html-webpack-pluginで複数のhtmlファイルを動的に出力する
 *
 * @param {*} entries
 * @param {*} templatePath
 * @param {*} outputPath
 * @returns [new HtmlWebpackPlugin(), new HtmlWebpackPlugin(), ...]
 *
 * 注意) エントリーポイント名とテンプレートファイル名が一致していないといけない。
 */
module.exports = function htmlGlobPlugin(entries, templatePath, outputPath, srcExt = 'html', distExt = 'html') {
    return Object.keys(entries).map(entryName =>
        new HtmlWebpackPlugin({
            template: `${templatePath}/${entryName}.${srcExt}`,
            filename: `${outputPath}/${entryName}.${distExt}`,
            inject: 'body',
            chunks: [entryName]
        })
    );
};
