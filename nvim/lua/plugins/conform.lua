-- conform :: formatting
--
-- Maps filetype -> formatter and runs them on save. Formatters come from
-- Mason (see mason.lua's tools list), so they are isolated to nvim-lab.
--
-- Replaces the trailing-whitespace autocmd that used to live in
-- core/autocmds.lua: the "_" fallback below trims whitespace for every
-- filetype that has no real formatter, so the two would otherwise duplicate
-- work and fight over cursor position.

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",

  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = { "n", "x" },
      desc = "Format buffer / selection",
    },
    {
      "<leader>uf",
      function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify("Format on save " .. (vim.g.disable_autoformat and "disabled" or "enabled"))
      end,
      desc = "Toggle format on save",
    },
  },

  opts = {
    formatters_by_ft = {
      lua = { "stylua" },

      -- ruff_fix applies safe lint fixes (unused imports, import order), then
      -- ruff_format does the formatting. Order matters.
      python = { "ruff_fix", "ruff_format" },

      c = { "clang_format" },
      cpp = { "clang_format" },
      cuda = { "clang_format" },

      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },

      sh = { "shfmt" },
      bash = { "shfmt" },

      -- Everything else: just strip trailing whitespace.
      ["_"] = { "trim_whitespace" },
    },

    format_on_save = function(bufnr)
      -- Two escape hatches: <leader>uf flips the global, and
      -- `:lua vim.b.disable_autoformat = true` disables one buffer.
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 1000, lsp_format = "fallback" }
    end,

    formatters = {
      shfmt = { prepend_args = { "-i", "2", "-ci" } },
    },
  },

  init = function()
    -- Make gq use conform, so the normal-mode format operator agrees with
    -- format-on-save instead of using Neovim's internal formatter.
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
