-- https://github.com/norcalli/nvim-colorizer.lua

local status, colorizer = pcall(require, "colorizer")
if (not status) then return end

colorizer.setup({
  '*';
})


-- 効果:
-- CSSの16進数のカラー表記に色が出る
