#todo 18. Rust環境構築

# https://www.rust-lang.org/ja/tools/install

# https://zenn.dev/chikoski/articles/2115efed69aed014616f

# https://moapp.hateblo.jp/entry/2017/01/04/225929

# https://zenn.dev/kawahara/scraps/5a22db01d86ec9

# ----------------------

# rustupの導入

# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# -> 1

# source $HOME/.cargo/env

# echo "source $HOME/.cargo/env" >> ~/.bashrc

# rustc --version

# cargo --version

# rustdoc --version

# rustup --version

# ----------------------

# rust-lldbでデバッグ

# sudo apt install lldb -y

# lldb --version

# rust-lldb

# ----------------------

# 最新バージョンへアップデートするには
# 次のように update コマンドを rustup で実行します。

# % rustup update

# rustup 自体のアップデート
# rustup 自体のアップデートは以下のようにします。

# % rustup self update
# なお、rustup のバージョンは-Vオプションで確認できます。

# % rustup -V

# ----------------------

# バージョンの切り替え

# $ cd プロジェクトのフォルダ
# $ echo "1.42.0" > rust-toolchain
# $ rustc -V
# rustc 1.42.0 (b8cedc004 2020-03-09)

# or

# rustup install バージョン
# rustup default
