-- nvim-dap-ui :: the debugger interface
--
-- Scopes, watches, call stack, breakpoint list, and a REPL, arranged around the
-- source. Opens itself when a session starts and closes when it ends, so there
-- is nothing to manage manually in the common case.
--
-- nvim-nio is declared as a dependency rather than getting its own file: it is
-- an async library that is only fetched, never configured.

return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
  },

  keys = {
    { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle debug UI" },
    {
      "<leader>de",
      function()
        require("dapui").eval()
      end,
      mode = { "n", "x" },
      desc = "Evaluate expression",
    },
  },

  opts = {
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.4 }, -- local + global variables
          { id = "breakpoints", size = 0.2 },
          { id = "stacks", size = 0.2 },
          { id = "watches", size = 0.2 },
        },
        position = "left",
        size = 45,
      },
      {
        elements = {
          { id = "repl", size = 0.5 },
          { id = "console", size = 0.5 },
        },
        position = "bottom",
        size = 12,
      },
    },
    floating = { border = "rounded" },
    -- Plain text rather than codicons: upstream's defaults assume the VS Code
    -- codicon font, which is not what this terminal uses.
    icons = { expanded = "v", collapsed = ">", current_frame = "*" },
    controls = { enabled = false }, -- keymaps drive this, not a click bar
  },

  config = function(_, opts)
    local dap = require("dap")
    local dapui = require("dapui")
    dapui.setup(opts)

    -- Open on session start, close when it finishes. `before` runs the
    -- handler ahead of dap's own, which is what these listener keys mean.
    dap.listeners.before.attach.dapui_config = dapui.open
    dap.listeners.before.launch.dapui_config = dapui.open
    dap.listeners.before.event_terminated.dapui_config = dapui.close
    dap.listeners.before.event_exited.dapui_config = dapui.close
  end,
}
