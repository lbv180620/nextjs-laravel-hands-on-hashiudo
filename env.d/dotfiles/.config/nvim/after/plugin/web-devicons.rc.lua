-- https://github.com/kyazdani42/nvim-web-devicons

local status, icons = pcall(require, "nvim-web-devicons")
if (not status) then return end

icons.setup {
  -- your personnal icons can go here (to override)
  -- DevIcon will be appended to `name`
  override = {
  },
  -- globally enable default icons (default to false)
  -- will get overriden by `get_icons` option
  default = true
}


-- 効果:
-- ファイルに拡張子に応じたアイコンが表示される

