-- nvim-dap :: debug adapter protocol client
--
-- The debugger core: breakpoints, stepping, stack frames, variable scopes.
-- The UI lives in nvim-dap-ui.lua, inline values in nvim-dap-virtual-text.lua,
-- and Python's adapter wiring in nvim-dap-python.lua.
--
-- Adapters are installed by mason.lua (codelldb, js-debug-adapter) and by uv
-- for Python. This file only teaches dap how to launch them.

return {
  "mfussenegger/nvim-dap",

  keys = {
    -- Function keys match the VS Code / JetBrains convention, so muscle memory
    -- from other debuggers carries over.
    { "<F5>", function() require("dap").continue() end, desc = "Debug: continue" },
    { "<F10>", function() require("dap").step_over() end, desc = "Debug: step over" },
    { "<F11>", function() require("dap").step_into() end, desc = "Debug: step into" },
    { "<F12>", function() require("dap").step_out() end, desc = "Debug: step out" },

    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
    {
      "<leader>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "Conditional breakpoint",
    },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to cursor" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
    { "<leader>do", function() require("dap").step_over() end, desc = "Step over" },
    { "<leader>dO", function() require("dap").step_out() end, desc = "Step out" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run last config" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate session" },
    {
      "<leader>dw",
      function()
        require("dap.ui.widgets").hover()
      end,
      mode = { "n", "x" },
      desc = "Inspect value under cursor",
    },
  },

  config = function()
    local dap = require("dap")
    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"

    -- ── Breakpoint signs ────────────────────────────────────────────────
    -- Plain letters rather than glyphs: these sit in the sign column beside
    -- gitsigns, and a Nerd Font icon there is easy to confuse with a hunk mark.
    vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DiagnosticError" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "C", texthl = "DiagnosticWarn" })
    vim.fn.sign_define("DapLogPoint", { text = "L", texthl = "DiagnosticInfo" })
    vim.fn.sign_define("DapStopped", { text = ">", texthl = "DiagnosticOk", linehl = "Visual" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "R", texthl = "DiagnosticHint" })

    -- ── C / C++ / CUDA ──────────────────────────────────────────────────
    -- codelldb runs as a TCP server; dap fills in ${port} at launch.
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = mason_bin .. "codelldb",
        args = { "--port", "${port}" },
      },
    }

    local cpp_config = {
      {
        name = "Launch executable",
        type = "codelldb",
        request = "launch",
        program = function()
          -- Asked once per session; run_last (<leader>dl) reuses the answer.
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        terminal = "integrated",
      },
    }

    dap.configurations.c = cpp_config
    dap.configurations.cpp = cpp_config
    -- CUDA CAVEAT: this debugs the HOST side of a CUDA program only. Device
    -- (kernel) debugging needs cuda-gdb (/opt/cuda/bin/cuda-gdb), which has no
    -- usable DAP support -- run it in a terminal for kernel work.
    dap.configurations.cuda = cpp_config

    -- ── JavaScript / TypeScript ─────────────────────────────────────────
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = mason_bin .. "js-debug-adapter",
        args = { "${port}" },
      },
    }

    for _, ft in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
      dap.configurations[ft] = {
        {
          name = "Launch current file",
          type = "pwa-node",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
        {
          name = "Attach to process",
          type = "pwa-node",
          request = "attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }
    end
  end,
}
