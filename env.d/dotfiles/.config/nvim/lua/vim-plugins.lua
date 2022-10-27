local Plug = require 'usermod.vimplug'

Plug.begin('~/.config/nvim/plugged')

Plug 'terryma/vim-multiple-cursors' -- Multiple cursors

Plug ('neoclide/coc.nvim', {branch = 'release'}) -- Complement

-- Plug 'ntk148v/vim-horizon'

-- Plug 'preservim/nerdtree'

-- Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

-- Plug 'sheerun/vim-polyglot'

-- Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug.ends()
