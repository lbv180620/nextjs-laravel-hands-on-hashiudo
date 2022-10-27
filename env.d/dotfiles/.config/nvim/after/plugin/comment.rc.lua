-- https://github.com/tpope/vim-commentary

local status, comment = pcall(require, "nvim_comment")
if (not status) then return end

comment.setup({})
