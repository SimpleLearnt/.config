-- nvim-dap-python :: Python debugging
--
-- Uses upstream's native uv support: setup("uv") launches debugpy via
-- `uv run`, which resolves it against the project's own environment. That
-- means no separate debugpy install, and the debugger sees your project's
-- dependencies -- the same reason venv-selector is not in this config.
--
-- If a project is not uv-managed, upstream still falls back to detecting a
-- local .venv.
--
-- The test-runner functions need the Python treesitter parser, which
-- nvim-treesitter.lua installs.

return {
  "mfussenegger/nvim-dap-python",
  dependencies = { "mfussenegger/nvim-dap" },
  ft = "python",

  keys = {
    {
      "<leader>dP",
      function()
        require("dap-python").test_method()
      end,
      ft = "python",
      desc = "Debug test method",
    },
    {
      "<leader>dS",
      function()
        require("dap-python").debug_selection()
      end,
      mode = "x",
      ft = "python",
      desc = "Debug selection",
    },
  },

  config = function()
    require("dap-python").setup("uv")
  end,
}
