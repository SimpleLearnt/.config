-- blink.cmp :: completion engine
--
-- PINNED TO v1. Upstream's own README says V2 is "under active development
-- with many breaking changes" and recommends staying on v1 -- V2 also requires
-- a separate blink.lib package. Revisit when V2 stabilises.
--
-- Rust fuzzy matcher (typo resistant), LSP / path / snippet / buffer sources,
-- signature help, and its own menu -- it does not use Neovim's completeopt.

return {
  "saghen/blink.cmp",
  version = "1.*", -- see header; do NOT track main
  dependencies = { "rafamadriz/friendly-snippets" },
  event = { "InsertEnter", "CmdlineEnter" },

  opts = {
    -- 'default' preset: <C-space> open, <C-n>/<C-p> or arrows to move,
    -- <C-y> accept, <C-e> hide, <C-k> signature.
    -- These are insert-mode only, so they do not touch harpoon's normal-mode
    -- <C-n> / <C-e>.
    keymap = { preset = "default" },

    appearance = {
      -- "mono" matches Nerd Font Mono glyph widths, which is what the terminal
      -- font is. Wrong value here makes icon columns misalign by a pixel or two.
      nerd_font_variant = "mono",
    },

    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = { border = "rounded", winblend = 0 },
      },
      menu = {
        border = "rounded",
        winblend = 0,
        draw = { treesitter = { "lsp" } }, -- syntax-highlight completion items
      },
      -- Inline preview of the selected item. Off: with auto_show docs already
      -- on, both at once is visual noise.
      ghost_text = { enabled = false },
    },

    sources = {
      -- lazydev first, so `require("...")` module names outrank generic LSP
      -- suggestions when editing this config.
      default = { "lazydev", "lsp", "path", "snippets", "buffer" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100, -- top priority
        },
      },
    },

    signature = {
      enabled = true,
      window = { border = "rounded" },
    },

    fuzzy = {
      -- Downloads a prebuilt Rust binary; warns and falls back to the Lua
      -- matcher rather than failing outright if that is unavailable.
      implementation = "prefer_rust_with_warning",
    },
  },

  -- Lets other spec files append sources without replacing the list.
  opts_extend = { "sources.default" },
}
