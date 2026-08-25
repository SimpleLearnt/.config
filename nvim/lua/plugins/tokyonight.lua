-- tokyonight :: colorscheme
--
-- The one place colors are decided. Other plugins should read highlight groups
-- from here rather than hardcoding their own palette.

return {
  "folke/tokyonight.nvim",
  lazy = false, -- the colorscheme is needed immediately, not on an event
  priority = 1000, -- ...and before every other plugin, so nothing flashes
  opts = {
    style = "storm", -- storm | night | moon | day
    light_style = "day",
    transparent = false,
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      functions = {},
      variables = {},
      sidebars = "dark",
      floats = "dark",
    },
    -- Dim inactive splits so the focused window is obvious at a glance.
    dim_inactive = true,
    lualine_bold = false,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight")
  end,
}
