set shell=/usr/local/bin/fish
" set shell=/bin/zsh
set shiftwidth=4 # インデントの幅
set tabstop=4 # タブに変換されるサイズ
set expandtab # タブの入力の際にスペース
set textwidth=0 # ワードラッピングなし
set autoindent # 自動インデント :set pasteで解除可能
set hlsearch # Searchのハイライト
set clipboard=unnamed # クリップボードへの登録
syntax on # SyntaxをEnable


" vim-plug: https://github.com/junegunn/vim-plug
call plug#begin()
" 以下、プラグインを記述
" vim-horizon: https://github.com/ntk148v/vim-horizon
Plug 'ntk148v/vim-horizon'

" nerdtree: https://github.com/preservim/nerdtree
Plug 'preservim/nerdtree'

" fzf: https://github.com/junegunn/fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" vim-fugitive: https://github.com/tpope/vim-fugitive
" mkdir -p ~/.config/nvim/pack/tpope/start
" cd ~/.config/nvim/pack/tpope/start
" git clone https://tpope.io/vim/fugitive.git
" vim -u NONE -c "helptags fugitive/doc" -c q

" vim-gitgutter: https://github.com/airblade/vim-gitgutter
" mkdir -p ~/.config/nvim/pack/airblade/start
" cd ~/.config/nvim/pack/airblade/start
" git clone https://github.com/airblade/vim-gitgutter.git
" nvim -u NONE -c "helptags vim-gitgutter/doc" -c q

" vim-commentary: https://github.com/tpope/vim-commentary
" mkdir -p ~/.config/nvim/pack/tpope/start
" cd ~/.config/nvim/pack/tpope/start
" git clone https://tpope.io/vim/commentary.git
" vim -u NONE -c "helptags commentary/doc" -c q

" vim-polyglot: https://github.com/sheerun/vim-polyglot
" Plug 'sheerun/vim-polyglot'

" coc.nvm: https://github.com/neoclide/coc.nvim
" brew install curl
" brew install nvm
" nvm install node
" brew install python
" pip3 install pylint jedi
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" vim-go: https://github.com/fatih/vim-go
" git clone https://github.com/fatih/vim-go.git ~/.local/share/nvim/site/pack/plugins/start/vim-go
call plug#end()


" if you don't set this option, this color might not correct
" set termguicolors

" colorscheme horizon

" lightline
" let g:lightline = {}
" let g:lightline.colorscheme = 'horizon'

" nnoremap <C-n> :NERDTree<CR>

" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

let g:gitgutter_highlight_lines = 1

" init.luaとコンフリクトを起こすので、同時に起用はできない
