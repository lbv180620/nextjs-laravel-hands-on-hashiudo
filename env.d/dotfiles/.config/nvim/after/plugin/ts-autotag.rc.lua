-- https://github.com/windwp/nvim-ts-autotag

local status, autotag = pcall(require, "nvim-ts-autotag")
if (not status) then return end

autotag.setup({})

-- 効果:
-- 自動でタグが閉じる
