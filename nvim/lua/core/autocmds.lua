-- Autocommands. Every group is cleared on reload so re-sourcing this file
-- does not stack duplicate handlers.

local function augroup(name)
  return vim.api.nvim_create_augroup("nvim_lab_" .. name, { clear = true })
end

-- Briefly highlight whatever was just yanked -- the cheapest possible
-- confirmation that you grabbed the right text.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.hl.on_yank({ higroup = "Visual", timeout = 150 })
  end,
})

-- Reopen a file on the line you left it on, unless the mark is stale or this
-- is a filetype where that would be wrong (git commit messages always start
-- at the top).
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit", "gitrebase", "commit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].nvim_lab_last_loc then
      return
    end
    vim.b[buf].nvim_lab_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close throwaway/scratch windows with a bare `q` instead of hunting for the
-- right :close variant.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "help",
    "qf",
    "man",
    "checkhealth",
    "lspinfo",
    "startuptime",
    "notify",
    "query",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true, desc = "Close window" })
  end,
})

-- Create missing parent directories when writing to a path that does not
-- exist yet, so `:e src/new/deep/file.lua` just works.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return -- leave scp://, term://, oil:// etc. alone
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Keep splits proportional when the terminal window is resized.
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Soft wrap and spell check for prose. Code stays hard-wrapped.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("prose"),
  pattern = { "markdown", "gitcommit", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- REMOVED: a BufWritePre autocmd that trimmed trailing whitespace.
-- conform.nvim now owns this for every filetype via its `["_"]` fallback
-- formatter, which trims whitespace wherever no real formatter is configured.
-- Keeping both meant two passes over the buffer on every save, each saving and
-- restoring the view, and they disagreed about cursor position on some edits.

-- CUDA source is C++ as far as the editor is concerned. Neovim detects .cu
-- and .cuh as filetype "cuda"; treesitter and clangd are wired for it in
-- their own plugin files.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("cuda_ft"),
  pattern = { "*.cu", "*.cuh" },
  callback = function(event)
    vim.bo[event.buf].filetype = "cuda"
  end,
})
