-- mason :: package manager for LSP servers, formatters, and linters
--
-- Installs into ~/.local/share/nvim-lab/mason/ (derived from stdpath), so none
-- of these binaries are shared with the LazyVim config.
--
-- Mason itself only manages LSP servers via mason-lspconfig. Formatters and
-- linters have no such bridge, so the ensure_installed loop below handles them
-- explicitly rather than adding mason-tool-installer as another dependency.

local tools = {
  "stylua", -- lua formatter
  "clang-format", -- c / cpp / cuda formatter
  "prettier", -- ts / js / json / css / html / markdown formatter
  "shfmt", -- shell formatter
  "shellcheck", -- shell linter (the one real nvim-lint consumer)

  -- Debug adapters (see nvim-dap.lua). Python's adapter is NOT here: it comes
  -- from `uv run debugpy` so it resolves against the project environment.
  "codelldb", -- c / cpp / cuda (host side)
  "js-debug-adapter", -- javascript / typescript
}

return {
  "mason-org/mason.nvim",
  cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog" },
  build = ":MasonUpdate",
  keys = {
    { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason package manager" },
  },

  opts = {
    ui = {
      border = "rounded",
      width = 0.8,
      height = 0.8,
    },
  },

  config = function(_, opts)
    require("mason").setup(opts)

    -- Install anything missing, once the registry has refreshed. Runs async on
    -- a background tick so it never blocks startup, and is a no-op when all
    -- tools are already present.
    local registry = require("mason-registry")
    registry.refresh(function()
      for _, name in ipairs(tools) do
        local ok, pkg = pcall(registry.get_package, name)
        if ok and not pkg:is_installed() then
          vim.notify("[mason] installing " .. name, vim.log.levels.INFO)
          pkg:install()
        end
      end
    end)
  end,
}
