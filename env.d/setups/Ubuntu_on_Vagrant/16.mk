#todo 16. Dart Sassの導入

# https://buildersbox.corp-sansan.com/entry/2021/03/10/110000

# https://qiita.com/0x50/items/9d586c7923be345f83c1

# https://zenn.dev/junki555/articles/b4d9e5775e5e4c6fb2a8

# --------------------

# yarnでの導入：

# https://qiita.com/TK-C/items/422a9badee49ca798cc0


# .
# + src/scss/style.scss
# + dist/css/style.css
# + dist/html/index.html
# + package.json
# + yarn.lock
# + node_modules/

# 1. Sassを使いたい所でディレクトリを作成

# mkdir src/scss
# mkdir dist/css

# mkdir scss
# mkdir css
# mkdir html

# srcディレクトリがSass。publicディレクトリにcssを出力するようにします。

# 2. Sassをインストール
# yarn init -y
# yarn add -D sass fibers


# 3. package.json

# package.json
# {
#   "scripts": {
#     "sass": "sass src/scss:dist/css"
#   }
# }

# 4. srcディレクトリにSassファイルを作成する。



# touch src/scss/style.scss

# yarn sass
# を実行することでcssファイルが出力されます。
# public/css/style.css
# public/css/style.css.map


# touch src/scss/Code1/style.scss
# dist/css/Code1/style.css
# ../css/Code1/style.css



# 5. Sassを変更したらリアルタイムでcssファイルを更新する

# 上記だけでもSassをcssに変換できますが、変換するにはyarn sassコマンドを都度実行する必要があります。
# sassを変更したらリアルタイムでcssファイルを更新するように設定を追加します。

# yarn add  watch browser-sync --dev
# をインストール後にpackage.jsonに下記を記述します。

# package.json
# {
#   "scripts": {
#     "sass": "sass src/scss:dist/css",
#     "sass-watch": "sass --watch src/scss:dist/css" // 追加
#   }
# }
# これで設定は完了です。


# yarn sass --watch
# 上記コマンドを実行することで、scssの変更を検知できるようになります。
# リアルタイムで変更がcssに反映されます。


# 6. 最後に

# 本記事では、yarnでSassの環境構築をする方法についてまとめました。
# さらに、VS CodeのプラグインLive Serverを使えば、ブラウザにもリアルタイムで反映できるようになるのでオススメです。


# --------------------

# https://zenn.dev/junki555/articles/b4d9e5775e5e4c6fb2a8

# --------------------

# npmでの導入：

# npm i webpack webpack-cli sass sass-loader style-loader fibers --save-dev


