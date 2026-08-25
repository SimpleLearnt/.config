-- harpoon2 :: pinned file list for the handful of files you actually live in
--
-- Different job from fff and yazi. fff searches, yazi browses; harpoon is a
-- manual shortlist you curate per project, reachable in one keystroke and
-- persisted across sessions.
--
-- Bindings below are UPSTREAM DEFAULTS, as requested. Two of them collide with
-- core/keymaps.lua, and harpoon wins because this config() runs at VeryLazy,
-- long after core/keymaps.lua:
--
--   <C-h>  was "go to left window"  -> now "harpoon slot 1"  (fully lost)
--   <C-s>  was "save file"          -> now "harpoon slot 4"  (NORMAL mode only
--          -- core/keymaps.lua maps <C-s> in n/i/x/s, and harpoon overrides
--          only n, so <C-s> still saves from insert and visual mode)
--
-- Upstream is upfront that these are personal and Dvorak-oriented ("My
-- shortcuts are for me. Me alone."). If either collision bites, the fix is to
-- change that one entry in the `keys` table below.

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy", -- so the persisted list is restored without a keypress

  config = function()
    local harpoon = require("harpoon")

    -- REQUIRED by upstream -- it installs the autocmds that persist the list.
    harpoon:setup()

    local function slot(n)
      return function()
        harpoon:list():select(n)
      end
    end

    local map = vim.keymap.set

    map("n", "<leader>a", function()
      harpoon:list():add()
    end, { desc = "Harpoon add file" })

    map("n", "<C-e>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon quick menu" })

    map("n", "<C-h>", slot(1), { desc = "Harpoon slot 1" })
    map("n", "<C-t>", slot(2), { desc = "Harpoon slot 2" })
    map("n", "<C-n>", slot(3), { desc = "Harpoon slot 3" })
    map("n", "<C-s>", slot(4), { desc = "Harpoon slot 4" })

    map("n", "<C-S-P>", function()
      harpoon:list():prev()
    end, { desc = "Harpoon prev" })

    map("n", "<C-S-N>", function()
      harpoon:list():next()
    end, { desc = "Harpoon next" })
  end,
}
