# nodeでdyld: Library not loaded: /usr/local/opt/icu4c/lib/libicui18n.59.dylibとなったときの対処法

# 記事
# https://qiita.com/umeneri/items/5dac302fff23d9bb954c
# https://www.gaji.jp/blog/2022/08/03/10687/
# https://qiita.com/SuguruOoki/items/3f4fb307861fcedda7a5

# 症状:
# dyld: Library not loaded: /usr/local/opt/icu4c/lib/libicui18n.70.dylib ⬢   08:35:00
#  Referenced from: /usr/local/bin/node

# 解決策:

# ①brew switchが使える場合

# 原因の特定
# brew info icu4c
# → icu4c: stable 71.1 (bottled) [keg-only]

# icu4c をインストールし直す
# brew update && brew reinstall icu4c

# Homebrew の Formulaディレクトリに移動する
# cd $(brew --prefix)/Homebrew/Library/Taps/homebrew/homebrew-core/Formula

# icu4c のコミットログを確認し、目的のバージョンを探す
# git log --follow icu4c.rb

# 目的のバージョンをインストール
# - ダウングレードしたいバージョンにチェックアウト
# git checkout <Commit ID>
# - パッケージをインストール
# brew reinstall ./icu4c.rb
# - インストール後は目的のバージョンにスイッチ
# brew switch icu4c <目的のバージョン>

# ダウングレードを確認
# brew info icu4c

# Formula で master へ checkout する
# git checkout master


# ....................

# ②brew switchが使えない場合

# brewで旧バージョンをインストールする
# https://qiita.com/kaihei777/items/0fcf0c1bcb17e68e6283

# Homebrewで過去のバージョンを使いたい【tap版】
# https://christina04.hatenablog.com/entry/install-old-version-with-homebrew

# 原因の特定
# brew info icu4c
# → icu4c: stable 71.1 (bottled) [keg-only]

# Homebrew の Formulaディレクトリに移動する
# cd $(brew --prefix)/Homebrew/Library/Taps/homebrew/homebrew-core/Formula

# icu4c のコミットログを確認し、目的のバージョンを探す
# git log --follow icu4c.rb

# tap用リポジトリの用意
# ※tapの命名規則としてhomebrew-を省略できる
# brew tap-new icu4c/taps #「icu4c」の部分はなんでもok

#  brewの古いformulaをtapに展開
# brew extract icu4c icu4c/taps --version <目的のバージョン>

#  tapからインストール
# brew install icu4c/taps/icu4c@<目的のバージョン>

# ダウングレードを確認
# brew info icu4c

# アンインストール
# brew uninstall icu4c@<目的のバージョン>

