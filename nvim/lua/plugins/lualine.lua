-- lualine :: statusline
--
-- core/options.lua already sets laststatus = 3 (one global statusline) and
-- showmode = false (the builtin -- INSERT -- would duplicate section_a).

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "echasnovski/mini.icons" },
  event = "VeryLazy",

  opts = function()
    return {
      options = {
        theme = "tokyonight",
        globalstatus = true,
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        -- No statusline inside the file explorer float.
        disabled_filetypes = { statusline = { "yazi" } },
      },

      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },

        lualine_c = {
          {
            "diagnostics",
            symbols = { error = "E", warn = "W", info = "I", hint = "H" },
          },
          -- Icon for the current file's type, then the path itself.
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          {
            "filename",
            path = 1, -- relative path, not just the basename
            -- Nerd Font glyphs are written as \u{...} escapes, NOT as literal
            -- characters. They live in the Unicode Private Use Area, and those
            -- bytes do not reliably survive being written into a file -- an
            -- earlier literal here silently became a bare space. The escape is
            -- plain ASCII in the source and decodes at runtime.
            symbols = {
              modified = " \u{25cf}", -- ● black circle (not a Nerd Font glyph)
              readonly = " \u{f023}", -- nf-fa-lock
              unnamed = "[No Name]",
            },
          },
        },

        lualine_x = {
          -- Git working-tree changes for the current file.
          {
            "diff",
            symbols = { added = "+", modified = "~", removed = "-" },
          },
        },

        lualine_y = {
          { "filetype", icons_enabled = false },
          { "progress", padding = { left = 1, right = 0 } },
        },

        lualine_z = {
          { "location", padding = { left = 0, right = 1 } },
        },
      },

      extensions = { "lazy", "quickfix", "man" },
    }
  end,
}
