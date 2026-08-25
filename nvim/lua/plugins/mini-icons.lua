-- mini.icons :: filetype and folder icon provider
--
-- One icon source for the whole config. Other plugins query this instead of
-- each pulling in its own icon set.

return {
  "echasnovski/mini.icons",
  lazy = false, -- lualine asks for icons during startup
  priority = 900, -- after tokyonight (1000), before everything else

  opts = {
    style = "glyph", -- set to "ascii" if the terminal font lacks glyphs
  },

  config = function(_, opts)
    require("mini.icons").setup(opts)

    -- Most plugins in the ecosystem still `require("nvim-web-devicons")`.
    -- This registers mini.icons under that module name so they resolve to it
    -- without nvim-web-devicons actually being installed.
    MiniIcons.mock_nvim_web_devicons()
  end,
}
