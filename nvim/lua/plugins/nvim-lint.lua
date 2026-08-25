-- nvim-lint :: linters that are not language servers
--
-- Deliberately thin. Most linting in this config arrives through LSP already:
-- ruff is a language server for Python, vtsls reports TypeScript diagnostics,
-- clangd runs clang-tidy (see its --clang-tidy flag), and marksman covers
-- markdown. Shell is the real gap, since there is no shell language server
-- here -- shellcheck fills it.
--
-- Results land in the normal diagnostic list, so they show up in trouble and
-- the statusline alongside LSP diagnostics with no extra wiring.

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile", "BufWritePost" },

  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      sh = { "shellcheck" },
      bash = { "shellcheck" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("nvim_lab_lint", { clear = true }),
      callback = function()
        -- Skip buffers you cannot write anyway (help, quickfix, terminals).
        if vim.bo.buftype ~= "" then
          return
        end
        -- try_lint is a no-op for filetypes with no configured linter, and
        -- silently skips linters whose binary is missing.
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>cl", function()
      lint.try_lint()
    end, { desc = "Lint buffer" })
  end,
}
