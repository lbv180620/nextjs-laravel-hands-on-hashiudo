#todo 5. Node.js環境構築

# anyenv install nodenv

# exec $SHELL -l

# ----------------

# ＃yarnのインストール
# https://remoter.hatenablog.com/entry/2020/07/30/nodenv%E3%81%A7%E5%88%A9%E7%94%A8%E3%81%97%E3%81%A6%E3%81%84%E3%82%8Bnode%E3%81%AE%E3%83%90%E3%83%BC%E3%82%B8%E3%83%A7%E3%83%B3%E3%81%A7yarn%E3%82%92%E4%BD%BF%E3%81%88%E3%82%8B%E3%82%88%E3%81%86

# sudo mkdir -p "$(nodenv root)/plugins"

# git clone https://github.com/pine/nodenv-yarn-install.git "$(nodenv root)/plugins/nodenv-yarn-install"

# echo 'export PATH="$HOME/.yarn/bin:$PATH"' >> ~/.zshrc

# ----------------

# touch $(nodenv root)/default-packages

# nodenv install 16.5.0

# nodenv global 16.5.0

# nodenv versions

# exec $SHELL -l

# node -v

# yarn -v

# npm -v

# ---------------

#^ 無視
# 旧版：
# yarn global add gulp

# 新版：
# yarn global add gulp@next

# gulp -v

# ----------------

# Node.jsでfetchを使えるようにする

# https://morizyun.github.io/javascript/node-js-npm-library-node-fetch.html

# https://chaika.hatenablog.com/entry/2019/01/23/083000

# yarn add node-fetch

# npm install --save node-fetch


# import fetch from 'node-fetch';
# ※importを使う場合は拡張子を.mjsにする

# const fetch = require('node-fetch');

# ----------------

# エラー

# nodenv: no such command `install'

# mkdir -p "$(nodenv root)"/plugins
# git clone https://github.com/nodenv/node-build.git "$(nodenv root)"/plugins/node-build
