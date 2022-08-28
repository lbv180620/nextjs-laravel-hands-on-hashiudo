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
module.exports = function htmlGlobMinifyPlugin(entries, templatePath, outputPath, srcExt = 'html', distExt = 'html') {
  return Object.keys(entries).map((entryName) => {
    const newEntryName = entryName.replace('@', '');
    return new HtmlWebpackPlugin({
      template: `${templatePath}/${entryName}.${srcExt}`,
      filename: `${outputPath}/${newEntryName}.${distExt}`,
      inject: 'body',
      chunks: [entryName],
      // HTMLにminifyがかかる状態に
      // https://github.com/jantimon/html-webpack-plugin
      minify: {
        collapseWhitespace: true, //空白を取り除く
        keepClosingSlash: true,
        removeComments: true, //コメントを取り除く
        removeRedundantAttributes: true, //不要な属性を取り除く
        removeScriptTypeAttributes: true,
        removeStyleLinkTypeAttributes: true,
        useShortDoctype: true,
      },
    });
  });
};
