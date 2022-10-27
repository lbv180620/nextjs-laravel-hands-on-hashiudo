const mix = require('laravel-mix');
const glob = require('glob') // webpack.mix.js内でscssをワイルドカードで読み込みために必要
const path = require('path'); // path.resovleを使用するため

require('laravel-mix-stylelint'); // webpack.mix.jsでstylelintを使用するため

// scssがあるディレクトリを指定
const scss = path.resolve(__dirname, 'resources/sass/*.scss')

glob.sync(scss).map(function (file) {
  mix.sass(file, 'public/css').options({
    processCssUrls: false, // scss内のパスを記載した通りに出力する
    postCss: [ // postCSSのプラグイン読み込み＆設定
      require('css-mqpacker')(),
      require('css-declaration-sorter')({
        order: 'smacss'
      })
    ],
    autoprefixer: { // autoprefixerの設定変更
      options: {
          browsers : [
              'last 2 versions',
          ],
          cascade: false
      }
    }
  })
})

mix
  .disableNotifications() // デスクトップ通知をoff
  .webpackConfig({
      module: { // scss内で@import "layout/*"を使える用にする
          rules: [{
              test: /\.scss/,
              loader: 'import-glob-loader'
          }]
      },
      resolve: { // モジュールがあるディレクトリを指定
          modules: [
              path.resolve('./resources/'),
              'node_modules'
          ]
      }
  }) // stylelintするようにする
  .stylelint({configFile: './.stylelintrc', files: ['**/*.scss']})

// npm run prodのときはversionを指定する
if (mix.inProduction()) {
    mix.version();
}


// 追加したパッケージ
// css-loader
// autoprefixer
// css-declaration-sorter
// css-mqpacker
// glob
// import-glob-loader
// path
// stylelint
// stylelint-webpack-plugin
// stylelint-config-twbs-bootstrap
// ※stylelint-config-twbs-bootstrapは、Bootstrapのルールをパクってるので、.stylelintrcで指定しないならなくていいです。
