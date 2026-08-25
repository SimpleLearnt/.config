-- Core keymaps. Plugin-specific maps live in that plugin's own spec file, so
-- if a mapping is not here, grep lua/plugins/ for it.
--
-- Deliberately NOT redefined here, because Neovim 0.11+ ships them and they
-- are good:
--   grn  rename          gra  code action       grr  references
--   gri  implementation  grt  type definition   gO   document symbols
--   K    hover           <C-s> (insert) signature help
--   ]d [d  diagnostics   ]q [q  quickfix        <C-w>d  show line diagnostic
--
-- Leader is <Space>, set in init.lua before this file loads.

local map = vim.keymap.set

-- ── General ─────────────────────────────────────────────────────────────────
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map({ "n", "i", "x", "s" }, "<C-s>", "<cmd>w<CR><Esc>", { desc = "Save file" })
map("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit all" })

-- Count-aware j/k: plain j/k move by display line (nice with wrap), but a
-- count still moves by real line, so 5j stays predictable and jumplist-safe.
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Keep the cursor centered when jumping around, so you never lose your place.
map("n", "n", "nzzzv", { desc = "Next search result" })
map("n", "N", "Nzzzv", { desc = "Prev search result" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })

-- ── Windows ─────────────────────────────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

map("n", "<leader>-", "<C-w>s", { desc = "Split window below" })
map("n", "<leader>|", "<C-w>v", { desc = "Split window right" })
map("n", "<leader>wd", "<C-w>c", { desc = "Delete window" })

-- ── Buffers ─────────────────────────────────────────────────────────────────
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>e #<CR>", { desc = "Switch to other buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- ── Moving text ─────────────────────────────────────────────────────────────
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<esc><cmd>m .-2<CR>==gi", { desc = "Move line up" })
map("x", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("x", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Stay in visual mode after indenting, so you can repeat it.
map("x", "<", "<gv", { desc = "Indent left" })
map("x", ">", ">gv", { desc = "Indent right" })

-- NOTE: `x p -> "_dP` (paste over a selection without clobbering the register)
-- used to live here. yanky.nvim now owns p/P in both normal and visual mode,
-- and solves the same problem better: the text you paste over enters the yank
-- ring, so [y brings it back rather than it being thrown away.

-- ── Diagnostics ─────────────────────────────────────────────────────────────
-- ]d / [d are builtin. This is the quality-of-life extra: a togglable
-- diagnostic virtual-text display, since inline errors are great until they
-- are in the way.
map("n", "<leader>ud", function()
  local enabled = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = not enabled })
  vim.notify("Diagnostic virtual text " .. (enabled and "disabled" or "enabled"))
end, { desc = "Toggle diagnostic virtual text" })

-- ── Terminal ────────────────────────────────────────────────────────────────
map("t", "<C-/>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
