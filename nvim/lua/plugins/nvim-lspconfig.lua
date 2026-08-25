-- nvim-lspconfig :: LSP configuration DATA (Neovim 0.12 native API)
--
-- On 0.11+ this plugin is no longer a framework. It ships default cmd /
-- filetypes / root_markers for ~350 servers in its lsp/ directory, and Neovim
-- reads them. The old `require('lspconfig').server.setup{}` no longer exists.
--
-- The pattern is now:
--     vim.lsp.config('name', { ... })   -- extend the shipped defaults
--     vim.lsp.enable('name')            -- activate it for its filetypes
--
-- Lifecycle commands are builtin too: :lsp enable / :lsp disable / :lsp restart
-- (replacing :LspStart / :LspStop / :LspRestart). Health is :checkhealth vim.lsp

-- Servers enabled at the bottom of this file. One block each, above.
local servers = { "lua_ls", "basedpyright", "ruff", "clangd", "vtsls", "jsonls", "marksman" }

--- Resolve the Python interpreter for a project.
--- uv puts the virtualenv at <root>/.venv by convention, which makes discovery
--- deterministic -- this is why venv-selector.nvim is not in this config.
---@param root string|nil
---@return string
local function python_path(root)
  if root then
    local venv = root .. "/.venv/bin/python"
    if vim.uv.fs_stat(venv) then
      return venv
    end
  end
  return vim.fn.exepath("python3")
end

return {
  "neovim/nvim-lspconfig",
  dependencies = { "mason-org/mason-lspconfig.nvim" },
  event = { "BufReadPre", "BufNewFile" },

  config = function()
    -- ── Diagnostics ─────────────────────────────────────────────────────
    vim.diagnostic.config({
      severity_sort = true,
      update_in_insert = false,
      underline = true,
      virtual_text = {
        spacing = 2,
        prefix = "\u{25cf}", -- ● written as an escape; see lualine.lua
        source = "if_many",
      },
      float = { border = "rounded", source = "if_many" },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "E",
          [vim.diagnostic.severity.WARN] = "W",
          [vim.diagnostic.severity.INFO] = "I",
          [vim.diagnostic.severity.HINT] = "H",
        },
      },
    })

    -- ── Per-buffer setup on attach ──────────────────────────────────────
    -- Neovim 0.11 already binds grn/gra/grr/gri/grt/gO/K. Only additions go
    -- here -- see core/keymaps.lua for the full list of builtins.
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("nvim_lab_lsp_attach", { clear = true }),
      callback = function(event)
        local buf = event.buf
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        vim.keymap.set("n", "<leader>ci", "<cmd>checkhealth vim.lsp<cr>", {
          buffer = buf,
          desc = "LSP info",
        })

        -- Inlay hints are off by default: useful when reading unfamiliar code,
        -- noisy when writing familiar code.
        if client and client:supports_method("textDocument/inlayHint") then
          vim.keymap.set("n", "<leader>uI", function()
            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
          end, { buffer = buf, desc = "Toggle inlay hints" })
        end

        -- Highlight other references to the symbol under the cursor, cleared
        -- as soon as it moves. updatetime (200ms) sets the delay.
        if client and client:supports_method("textDocument/documentHighlight") then
          local hl_group = vim.api.nvim_create_augroup("nvim_lab_lsp_hl", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = hl_group,
            buffer = buf,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = hl_group,
            buffer = buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    -- ── Lua ─────────────────────────────────────────────────────────────
    -- Library paths and the `vim` global are handled by lazydev.nvim, so none
    -- of the usual workspace.library boilerplate is needed here.
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          workspace = { checkThirdParty = false },
          codeLens = { enable = true },
          completion = { callSnippet = "Replace" },
          doc = { privateName = { "^_" } },
          hint = { enable = true, arrayIndex = "Disable" },
        },
      },
    })

    -- ── Python ──────────────────────────────────────────────────────────
    -- basedpyright does types and completion; ruff does lint and format. Both
    -- are pointed at the uv virtualenv. Hover is disabled on ruff so the two
    -- servers do not both answer K with different content.
    vim.lsp.config("basedpyright", {
      settings = {
        basedpyright = {
          analysis = {
            typeCheckingMode = "standard",
            diagnosticMode = "openFilesOnly",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
          },
        },
      },
      before_init = function(_, config)
        config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
          python = { pythonPath = python_path(config.root_dir) },
        })
      end,
    })

    vim.lsp.config("ruff", {
      on_attach = function(client)
        client.server_capabilities.hoverProvider = false
      end,
    })

    -- ── C / C++ / CUDA ──────────────────────────────────────────────────
    -- CUDA CAVEAT: clangd parses .cu correctly only when it knows the CUDA
    -- toolkit location and the include paths. For real projects generate a
    -- compile_commands.json (cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON). For
    -- one-off files, add a .clangd file with:
    --     CompileFlags:
    --       Add: [--cuda-path=/opt/cuda, -I/opt/cuda/include, --cuda-gpu-arch=sm_86]
    -- sm_86 is the RTX 3060's architecture.
    vim.lsp.config("clangd", {
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
      },
      filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
      init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
      },
    })

    -- ── Web ─────────────────────────────────────────────────────────────
    vim.lsp.config("vtsls", {
      settings = {
        typescript = {
          updateImportsOnFileMove = { enabled = "always" },
          inlayHints = {
            parameterNames = { enabled = "literals" },
            variableTypes = { enabled = false },
          },
        },
        javascript = {
          updateImportsOnFileMove = { enabled = "always" },
        },
      },
    })

    -- jsonls validates against schemas it is given. Without SchemaStore.nvim
    -- (deliberately not installed) it still does syntax and structure, just no
    -- package.json / tsconfig field completion.
    vim.lsp.config("jsonls", {
      settings = {
        json = { validate = { enable = true } },
      },
    })

    vim.lsp.config("marksman", {})

    -- ── Activate ────────────────────────────────────────────────────────
    vim.lsp.enable(servers)
  end,
}
