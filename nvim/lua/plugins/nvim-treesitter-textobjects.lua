-- nvim-treesitter-textobjects :: syntax-aware selections, motions, and swaps
--
-- Also the `main` branch rewrite. There is no `keymaps` config table any more
-- -- you call the module functions yourself, which is why this file is mostly
-- keymaps rather than options.
--
-- Deliberately avoided, because Neovim already owns them:
--   ]d [d  diagnostics      ]q [q  quickfix      [z ]z  folds
--   ]c [c  diff changes
--
-- OVERLAP WITH mini.ai -- RESOLVED (Phase 5): both coexist, no changes needed.
-- The select maps below are two-character sequences (af, ic, aa, ...) while
-- mini.ai maps single-character `a` and `i` then reads the next key. Vim
-- resolves the longest match, so these win for code objects and mini.ai
-- handles delimiters plus its next/last variants. See mini-ai.lua.

return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = { "BufReadPost", "BufNewFile" },

  init = function()
    -- Neovim ships ftplugin mappings for some languages that collide with
    -- these (e.g. python's ]m). Disable them wholesale rather than debug
    -- per-language surprises.
    vim.g.no_plugin_maps = true
  end,

  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        -- Jump forward to the object if the cursor is not inside one, the way
        -- targets.vim does. Makes `daf` work without positioning first.
        lookahead = true,
        selection_modes = {
          ["@parameter.outer"] = "v", -- charwise
          ["@function.outer"] = "V", -- linewise
          ["@class.outer"] = "V",
        },
        include_surrounding_whitespace = false,
      },
      move = {
        set_jumps = true, -- motions land in the jumplist, so <C-o> comes back
      },
    })

    local select = require("nvim-treesitter-textobjects.select")
    local move = require("nvim-treesitter-textobjects.move")
    local swap = require("nvim-treesitter-textobjects.swap")

    -- ── Select ──────────────────────────────────────────────────────────
    local objects = {
      f = { "@function.outer", "@function.inner", "function" },
      c = { "@class.outer", "@class.inner", "class" },
      a = { "@parameter.outer", "@parameter.inner", "argument" },
      l = { "@loop.outer", "@loop.inner", "loop" },
      i = { "@conditional.outer", "@conditional.inner", "conditional" },
    }

    for key, spec in pairs(objects) do
      local outer, inner, label = spec[1], spec[2], spec[3]
      vim.keymap.set({ "x", "o" }, "a" .. key, function()
        select.select_textobject(outer, "textobjects")
      end, { desc = "a " .. label })
      vim.keymap.set({ "x", "o" }, "i" .. key, function()
        select.select_textobject(inner, "textobjects")
      end, { desc = "inner " .. label })
    end

    -- ── Move ────────────────────────────────────────────────────────────
    local motions = {
      f = { "@function.outer", "function" },
      t = { "@class.outer", "class (type)" },
      a = { "@parameter.inner", "argument" },
      l = { "@loop.outer", "loop" },
      i = { "@conditional.outer", "conditional" },
    }

    for key, spec in pairs(motions) do
      local query, label = spec[1], spec[2]
      vim.keymap.set({ "n", "x", "o" }, "]" .. key, function()
        move.goto_next_start(query, "textobjects")
      end, { desc = "Next " .. label .. " start" })
      vim.keymap.set({ "n", "x", "o" }, "[" .. key, function()
        move.goto_previous_start(query, "textobjects")
      end, { desc = "Prev " .. label .. " start" })
      vim.keymap.set({ "n", "x", "o" }, "]" .. key:upper(), function()
        move.goto_next_end(query, "textobjects")
      end, { desc = "Next " .. label .. " end" })
      vim.keymap.set({ "n", "x", "o" }, "[" .. key:upper(), function()
        move.goto_previous_end(query, "textobjects")
      end, { desc = "Prev " .. label .. " end" })
    end

    -- ── Swap ────────────────────────────────────────────────────────────
    -- Reordering function arguments without a visual selection dance.
    vim.keymap.set("n", "<leader>ca", function()
      swap.swap_next("@parameter.inner")
    end, { desc = "Swap argument next" })
    vim.keymap.set("n", "<leader>cA", function()
      swap.swap_previous("@parameter.inner")
    end, { desc = "Swap argument prev" })

    -- DECIDED (Phase 5): repeatable moves via ; and , stay unwired. flash.nvim
    -- has char mode enabled, which already gives f/F/t/T labelled multi-line
    -- jumps and its own ; / , repeat. Layering treesitter's repeat on top would
    -- mean two plugins fighting over the same two keys for different meanings.
  end,
}
