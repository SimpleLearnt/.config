-- nvim-treesitter :: parsers + syntax-aware highlighting, folding, indentation
--
-- This is the `main` branch, which is a FULL REWRITE of the old `master`.
-- Everything you remember is gone: no `ensure_installed`, no
-- `highlight = { enable = true }`, no `nvim-treesitter.configs`. The plugin now
-- only installs parsers and ships queries -- ENABLING features is your job, via
-- Neovim's own treesitter API. That is what the autocmd at the bottom does.
--
-- Requires (all present on this machine): tree-sitter CLI >= 0.26.1 installed
-- from pacman (NOT npm), a C compiler, tar, curl.

local parsers = {
  -- config + core
  "lua",
  "luadoc",
  "vim",
  "vimdoc",
  "query", -- treesitter's own query language, for editing .scm files
  -- languages we set up LSP for
  "python",
  "c",
  "cpp",
  "cuda",
  "javascript",
  "typescript",
  "tsx",
  "json",
  -- NO "jsonc": the main branch has no such parser (only json and json5), and
  -- asking for it makes install() error on every launch. The filetype is
  -- mapped onto the json parser in config() instead.
  "html",
  "css",
  -- shell + data
  "bash",
  "yaml",
  "toml",
  -- prose + vcs
  "markdown",
  "markdown_inline", -- required for fenced code blocks to highlight
  "latex", -- markview renders inline/display math with this
  "comment", -- markview highlights TODO/NOTE inside comments
  "diff",
  "gitcommit",
  "git_rebase",
  "regex",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",

  -- Upstream is explicit: this plugin does not support lazy-loading.
  lazy = false,

  -- Parser ABI is tied to the plugin version, so parsers MUST be rebuilt
  -- whenever the plugin updates or highlighting breaks with cryptic errors.
  build = ":TSUpdate",

  config = function()
    require("nvim-treesitter").setup({
      -- Prepended to runtimepath so these parsers win over any shipped with
      -- Neovim. stdpath("data") keeps them in ~/.local/share/nvim-lab/site.
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- Filetypes whose parser is named differently. Without this,
    -- get_lang("jsonc") returns "jsonc", no such parser exists, and .jsonc
    -- files silently fall back to regex highlighting.
    vim.treesitter.language.register("json", "jsonc")

    -- Asynchronous, and a no-op for parsers already present -- so this is
    -- cheap on every subsequent startup, not just the first.
    require("nvim-treesitter").install(parsers)

    -- ── Feature activation ──────────────────────────────────────────────
    -- One FileType autocmd rather than an ftplugin file per language: it
    -- resolves the parser for whatever filetype was just set and enables the
    -- three features only if that parser actually exists. Filetypes without a
    -- parser silently keep Neovim's regex syntax highlighting.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("nvim_lab_treesitter", { clear = true }),
      callback = function(event)
        local ft = vim.bo[event.buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then
          return
        end

        -- Fails when the parser is not installed yet (e.g. first launch,
        -- while install() is still running). Not an error worth surfacing.
        if not pcall(vim.treesitter.start, event.buf, lang) then
          return
        end

        -- Folding. Window-local-to-buffer scope, so it does not leak into
        -- other buffers shown in the same window. core/options.lua already
        -- sets foldlevel = 99, so files open fully unfolded.
        vim.wo[0][0].foldmethod = "expr"
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"

        -- Indentation. Upstream marks this EXPERIMENTAL -- if indenting
        -- misbehaves in a language, delete this line and Neovim falls back to
        -- the builtin indent rules. Note the exact quoting: the outer string
        -- is double-quoted because the expression contains single quotes.
        vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
