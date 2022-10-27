#todo [vim + tmux + zsh + lua Tips]


# help - Vim日本語ドキュメント
# https://vim-jp.org/vimdoc-ja/

# Vim help files
# https://vimhelp.org/

# VIM Adventures
# https://vim-adventures.com/

# キーマップに使えるキー名の一覧
# https://maku77.github.io/vim/keymap/keycodes.html

# [Vim問題] Leaderキーってなに？
# https://vim.blue/leader-key/
# https://original-game.com/mini_howto/how-to-use-the-leader-key-in-vim/
# https://maku77.github.io/vim/keymap/mapleader.html


# **** Lua + Neovimのセットアップ ****

# Set up Neovim on a new M2 MacBook Air for coding React, TypeScript, Tailwind CSS, etc.
# https://www.youtube.com/watch?v=ajmK0ZNcM4Q&t=4860s

# vim沼: NeovimのReact、TypeScript、Tailwind CSS用セットアップ
# https://zenn.dev/takuya/articles/4472285edbc132

# dotfiles-public
# https://github.com/craftzdog/dotfiles-public

# Neovim-from-scratch
# https://github.com/LunarVim/Neovim-from-scratch

# Neovim - LSP Setup Tutorial (Built in LSP 100% Lua)
# https://www.youtube.com/watch?v=6F3ONwrCxMg

# nv-ide
# https://github.com/crivotz/nv-ide

# Neovim プラグインを（ほぼ）全て Lua に移行した
# https://zenn.dev/acro5piano/articles/c764669236eb0f

# ワシの使っているNeovimプラグインは200個近くあるぞ
# https://zenn.dev/yutakatay/articles/neovim-plugins-2022

# NeovimとLua
# https://zenn.dev/hituzi_no_sippo/articles/871c06cdbc45b53181e3#%E3%82%B3%E3%83%A1%E3%83%B3%E3%83%88

# NeovimのためのLua入門 Lua基礎編
# https://zenn.dev/slin/articles/2020-10-19-neovim-lua1

# Neovim 100のおすすめプラグイン 一覧  (2022)
# https://jp.magicode.io/denx/articles/8d205da069664d78abc6a56d96e6bc7c

#【Neovim】toggleterm.nvimとlazygitを組み合わせてgit操作を快適にする
# https://zenn.dev/koga1020/articles/524e4c8c80db24

# Getting started using Lua in Neovim
# https://github.com/willelz/nvim-lua-guide-ja/blob/master/README.ja.md

# NeoVimの設定をinit.luaでやってみた
# https://mr-oliva.medium.com/neovim%E3%81%AE%E8%A8%AD%E5%AE%9A%E3%82%92lua%E3%81%A7%E3%82%84%E3%81%A3%E3%81%A6%E3%81%BF%E3%81%9F-8d3c219d5b42

# Neovimのプラグインでよく使うキーマップ一覧
# https://qiita.com/uhooi/items/95435fdec0f090f7b3ce

# Neovim+LSPをなるべく簡単な設定で構築する
# https://zenn.dev/botamotch/articles/21073d78bc68bf

# Neovim builtin LSP設定入門
# https://zenn.dev/nazo6/articles/c2f16b07798bab#%E7%89%B9%E5%AE%9A%E3%81%AE%E8%A8%80%E8%AA%9E%E7%B3%BB

# Neovimを一瞬でVSCode並みに便利にする
# https://k0kubun.hatenablog.com/entry/neovim-lsp

# nvim-comment
# https://github.com/terrortylor/nvim-comment
# https://www.wenyanet.com/opensource/ja/61290292b261864b9e144efd.html

# Neovimでのgit用プラグインneogit
# https://homaju.hatenablog.com/

# Luaで書かれたNeovimプラグイン
# https://scrapbox.io/uki00a/Lua%E3%81%A7%E6%9B%B8%E3%81%8B%E3%82%8C%E3%81%9FNeovim%E3%83%97%E3%83%A9%E3%82%B0%E3%82%A4%E3%83%B3


# ...............

#~ 必要なインストール

# Neovim
# brew install neovim

# Lua
# brew install lua

#  Packer
# git clone --depth 1 https://github.com/wbthomason/packer.nvim \
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# TypeScript Language Server
# npm i -g typescript-language-server

# Treesitter
# brew install tree-sitter

# prettierd
# brew install fsouza/prettierd/prettierd

# eslint_d
# npm i -g eslint_d

# vim-fugitive: https://github.com/tpope/vim-fugitive
# mkdir -p ~/.config/nvim/pack/tpope/start
# cd ~/.config/nvim/pack/tpope/start
# git clone https://tpope.io/vim/fugitive.git
# nvim -u NONE -c "helptags fugitive/doc" -c q

# vim-visual-multi: https://github.com/mg979/vim-visual-multi
# mkdir -p ~/.config/nvim/pack/tpope/start
# cd ~/.config/nvim/pack/tpope/start
# git clone https://tpope.io/vim/fugitive.git
# nvim -u NONE -c "helptags fugitive/doc" -c q

#vim-multiple-cursors: https://github.com/terryma/vim-multiple-cursors


# ...............

# ^ 差異のあるファイル

# lua/plugins.lua
# plugin/lspconfig.rc.lua


# ................

# npm -i -D prettier

# prettier.config.js

# const options = {
#   arrowParens: 'avoid',
#   singleQuote: true,
#   bracketSpacing: true,
#   endOfLine: 'lf',
#   semi: false,
#   tabWidth: 2
#   trailingComma: 'none'
# };

# module.exports = options;


# ----------------

#? Vim – ファイル切り替え操作

# 記事
# https://inarizuuuushi.hatenablog.com/entry/2021/05/16/191050
# https://zenn.dev/hosu/articles/2d8961ceef5a3d
# https://www.softel.co.jp/blogs/tech/archives/4843
# https://howpon.com/21914
# https://vim.jp.net/stepuptonovice_others_argumentlist_jumping.html
# https://ylgbk.hatenablog.com/entry/2013/12/21/144455
# https://zenn.dev/sa2knight/articles/e0a1b2ee30e9ec22dea9
# https://www.skyarch.net/blog/?p=2030
# https://reasonable-code.com/vim-open-files/
# https://kaworu.jpn.org/vim/vim%E3%81%A7%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%92%E9%96%8B%E3%81%8F%E6%96%B9%E6%B3%95
# https://qiita.com/akata/items/52653ffbc02f46709e3a
# https://daisuzu.hatenablog.com/entry/2016/12/04/003014


# ----------------

#? Vim - やり直しコマンド

# https://motamemo.com/vim/vim-tips/undo-redo/

# u
# ノーマルモードで元に戻す（UNDO）

# CTRL + r
# やり直しは（REDO）


# **** luaでVim Plugを使用する方法 ****


# Vimメモ : Neovimで開発環境を段階的に構築する（3）あいまい検索とGit連携
# https://wonderwall.hatenablog.com/entry/2019/07/30/233000

# Vimの生産性を高める12の方法
# https://postd.cc/how-to-boost-your-vim-productivity/


# -----------------------

#* 設定手順

# ⑴ Vim Plugのインストール
# https://github.com/junegunn/vim-plug

# sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
#       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'


# ......................

# ⑵ Neovim: using vim-plug in lua

# https://dev.to/vonheikemen/neovim-using-vim-plug-in-lua-3oom

#" ~/.config/nvim/lua/usermod/vimplug.lua
# local Plug = require 'usermod.vimplug'

# Plug.begin('~/.config/nvim/plugged')

# Plug 'moll/vim-bbye'
# Plug('junegunn/goyo.vim', {ft = 'markdown'})
# Plug('VonHeikemen/rubber-themes.vim', {
#   run = function()
#     vim.opt.termguicolors = true
#     vim.cmd('colorscheme rubber')
#   end
# })
# Plug('b3nj5m1n/kommentary', {
#   config = function()
#     local cfg = require('kommentary.config')

#     cfg.configure_language('default', {
#       prefer_single_line_comments = true,
#     })
#   end
# })

# Plug.ends()


# ......................

# ⑶ lua/vim-plugins.lua

# local Plug = require 'usermod.vimplug'

# Plug.begin('~/.config/nvim/plugged')

# Plug 'moll/vim-bbye'
# Plug('junegunn/goyo.vim', {ft = 'markdown'})
# Plug('VonHeikemen/rubber-themes.vim', {
#   run = function()
#     vim.opt.termguicolors = true
#     vim.cmd('colorscheme rubber')
#   end
# })
# Plug('b3nj5m1n/kommentary', {
#   config = function()
#     local cfg = require('kommentary.config')

#     cfg.configure_language('default', {
#       prefer_single_line_comments = true,
#     })
#   end
# })

# Plug.ends()


# ......................

# ⑷ init.lua

# require('vim-plugins')


# ......................

# ⑸ :PlugInstall


# -----------------------

#* おすすめプラグイン

# vim-fugitive

# https://github.com/tpope/vim-fugitive

# vim-fugitiveでvimの開発体験を上げるtips
# https://code-log.hatenablog.com/entry/2018/12/08/101732

# VimmerなGit使いはfugitive.vimを今すぐ入れたほうがいい
# https://yuku-tech.hatenablog.com/entry/20110427/1303868482


# mkdir -p ~/.config/nvim/pack/tpope/start
# cd ~/.config/nvim/pack/tpope/start
# git clone https://tpope.io/vim/fugitive.git
# nvim -u NONE -c "helptags fugitive/doc" -c q


# ......................

# vim-multiple-cursors

# https://github.com/terryma/vim-multiple-cursors


# マルチカーソルは Vim をもっと便利にできるのか？
# https://vim.blue/vim-multicursor/


# Plug 'terryma/vim-multiple-cursors'


# ......................

# vim-horizon

# https://github.com/ntk148v/vim-horizon

# Plug 'ntk148v/vim-horizon'


# ......................

# nerdtree

# https://github.com/preservim/nerdtree

# Plug 'preservim/nerdtree'


# ......................

# fzf

# https://github.com/junegunn/fzf

# Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }


# ......................

# vim-gitgutter

# https://github.com/airblade/vim-gitgutter

# mkdir -p ~/.config/nvim/pack/airblade/start
# cd ~/.config/nvim/pack/airblade/start
# git clone https://github.com/airblade/vim-gitgutter.git
# nvim -u NONE -c "helptags vim-gitgutter/doc" -c q


# ......................

# vim-commentary

# https://github.com/tpope/vim-commentary

# mkdir -p ~/.config/nvim/pack/tpope/start
# cd ~/.config/nvim/pack/tpope/start
# git clone https://tpope.io/vim/commentary.git
# nvim -u NONE -c "helptags commentary/doc" -c q


# ......................

# vim-polyglot

# https://github.com/sheerun/vim-polyglot

# Plug 'sheerun/vim-polyglot'


# ......................

# coc.nvm

# https://github.com/neoclide/coc.nvim

# Using coc extensions
# https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions

# Quick Start
# https://github.com/neoclide/coc.nvim#quick-start

# ex) python
# brew install curl
# brew install nvm (不要: anyenvのnodenvを使用)
# nvm install node (不要)
# brew install python (不要)

# pip3 install pylint jedi

# Plug 'neoclide/coc.nvim', {'branch': 'release'}

# :PlugInstall

# :CocInstall coc-python


# ......................

# vim-go

# https://github.com/fatih/vim-go

# git clone https://github.com/fatih/vim-go.git ~/.local/share/nvim/site/pack/plugins/start/vim-go


# ==== LSP ====

# LunarVimのすゝめ
# https://zenn.dev/oha_tak/articles/e2f88e09e4aad6

# nvim-lsp-installerからmason.nvimへ移行する
# https://zenn.dev/kawarimidoll/articles/367b78f7740e84


# NativeLSPの対応言語
# https://github.com/williamboman/nvim-lsp-installer#available-lsps


# ------------------------

#& LSP設定手順

# https://github.com/crivotz/nv-ide/blob/master/lua/lsp/init.lua

# Treesitter

# Treesitterの対応言語
# https://github.com/nvim-treesitter/nvim-treesitter#supported-languages

# 以下に追記

  # ensure_installed = {
  #   "tsx",
  #   "toml",
  #   "fish",
  #   "php",
  #   "json",
  #   "yaml",
  #   "swift",
  #   "css",
  #   "html",
  #   "lua"
  # },


# .....................

# Mason

# Available LSP servers
# https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers

# :MasonInstall <Available LSP server name>

#   ensure_installed = { "sumneko_lua", "tailwindcss" },

# nvim_lsp.<言語名>.setup {}


#^ 手動でインストールが必要な言語サーバもある


# .....................

# LSPConfig

# nvim_lsp.<言語サーバ名>.setup {}


# .....................

# LSPSaga

  # server_filetype_map = {
  #   typescript = 'typescript'
  # }

# .....................

# Prettier

  # filetypes = {
  #   "css",
  #   "javascript",
  #   "javascriptreact",
  #   "typescript",
  #   "typescriptreact",
  #   "json",
  #   "scss",
  #   "less"
  # }


# **** PHP ****

# Phpactor
# https://qiita.com/cyrt/items/ff5edd392b3f41dd6e10


# ==== Coc ====

# coc.nvimを使ってvimをもっと強くする
# https://qiita.com/coil_msp123/items/29de76b035dd28af77a9

#? インストール方法
# :CocInstall <パッケージ名>

#? アンインストール方法
# cd ~/.config/coc/extensions
# npm un <パッケージ名>


# --------------------

# coc.nvm

# https://github.com/neoclide/coc.nvim

# Using coc extensions
# https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions

# Quick Start
# https://github.com/neoclide/coc.nvim#quick-start

# ex) python
# brew install curl
# brew install nvm (不要: anyenvのnodenvを使用)
# nvm install node (不要)
# brew install python (不要)

# pip3 install pylint jedi

# Plug 'neoclide/coc.nvim', {'branch': 'release'}

# :PlugInstall

# :CocInstall coc-python



# .....................

#! [coc.nvim] error: Uncaught exception: Error: write EPIPE
#! [coc.nvim] Jedi error: Traceback (most recent call last):
# https://github.com/neoclide/coc.nvim/issues/1833
# → This repository has been archived by the owner. It is now read-only.
# coc-pythonはアーカイブに入ったため、使えなくなった。代わりにcoc-jediを使う


# .....................

#? coc-settings.json

# [第11回] Neovimのすゝめ – LSPをセットアップ（coc編）
# https://wonwon-eater.com/nvim-susume-lsp-coc/

# Coc.nvimを触ってみようアドベントカレンダー 4日目 – coc-jedi
# https://dev.classmethod.jp/articles/cocnvim-adventcalendar-day04/

# :CocConfigコマンドを実行すると、Neovim設定ディレクトリのcoc-settings.jsonが開かれます。
# 存在しない場合は自動的に作られます。

#^ coc-jsonが必要
# :CocInstall coc-json
# :CocConfig

#" ~/.config/nvim/co-settings.json
# {
#   "jedi": {
#     "enable": true,
#     "startupMessage": false,
#     "executable.command": "~/.anyenv/envs/pyenv/shims/jedi-language-server
# }


# --------------------

# coc-json

# https://github.com/neoclide/coc-json

# :CocInstall coc-json


# --------------------

# coc-spell-checker

# Coc.nvimを触ってみようアドベントカレンダー 5日目 – coc-spell-checker
# https://dev.classmethod.jp/articles/cocnvim-adventcalendar-day05/

# :CocInstall coc-spell-checker


# --------------------

#* [Python]

# coc-jedi
# https://github.com/pappasam/coc-jedi

# coc-pythonがArchive入りしていることに気がついたのでcoc-jediに変えてみた
# https://dev.classmethod.jp/articles/change-to-coc-jedi-from-coc-python/
# coc-python が archive されたので、coc-jedi と coc-diagnostic に乗り換えた
# https://shase428.hatenablog.jp/entry/2022/05/27/104853
# Coc.nvimを触ってみようアドベントカレンダー 4日目 – coc-jedi
# https://dev.classmethod.jp/articles/cocnvim-adventcalendar-day04/
# coc.nvimの使い方
# https://gink03.github.io/coc-nvim/


# pip install jedi-language-server
# :CocInstall coc-jedi


# ....................

# coc-pyright


# --------------------

#* [go]

# Vim で Go を書く環境を整えた
# https://zenn.dev/ktakayama/articles/cde5092f05751d

# coc-go
# https://github.com/josa42/coc-go
# :CocInstall coc-go
# [不要] :CocCommand go.install.gopls
# → ~/.config/coc/extensions/coc-go-data/bin/gopls


# --------------------

#* [PHP]

# coc-intelephense
# https://github.com/yaegassy/coc-intelephense
# :CocInstall @yaegassy/coc-intelephense


# coc-phpstan
