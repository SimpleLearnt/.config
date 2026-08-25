-- Core editor settings. No plugin may be referenced from this file.
--
-- Grouped by what they affect. Anything non-obvious carries a comment saying
-- why it is set, not what it does -- `:h <option>` already says what it does.

local opt = vim.opt

-- ── Appearance ──────────────────────────────────────────────────────────────
opt.number = true
opt.relativenumber = true -- jump by count: 5j, 12k
opt.signcolumn = "yes" -- always on, so text does not shift when a sign appears
opt.cursorline = true
opt.termguicolors = true
opt.showmode = false -- lualine shows the mode; the default one is redundant
opt.laststatus = 3 -- one global statusline instead of one per split
opt.cmdheight = 1
opt.pumheight = 10 -- cap completion popup height
-- Blend against a compositor-transparent terminal leaves smeared popups.
opt.pumblend = 0
opt.winblend = 0
opt.winborder = "rounded" -- 0.11+: default border for all floating windows
-- tmux/wezterm send multi-byte CSI; the default 50ms ttimeout feels like lag
-- and can drop a redraw. Keep timeoutlen (which-key) separate.
opt.ttimeoutlen = 10
opt.scrolloff = 8 -- keep context above/below the cursor
opt.sidescrolloff = 8
opt.wrap = false
opt.linebreak = true -- if wrap is toggled on, break at words not mid-word
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
-- Each fillchars field must be exactly ONE character or Neovim throws E1511.
-- These are plain Unicode triangles rather than Nerd Font glyphs, so they
-- render correctly regardless of which font the terminal is using.
opt.fillchars = { eob = " ", fold = " ", foldopen = "▾", foldclose = "▸" }
opt.colorcolumn = "100"

-- ── Editing ─────────────────────────────────────────────────────────────────
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftround = true -- round indent to a multiple of shiftwidth
opt.smartindent = true
opt.virtualedit = "block" -- let visual-block select past end of line
opt.inccommand = "nosplit" -- live preview of :s as you type it
opt.confirm = true -- prompt to save instead of failing on :q with changes

-- ── Search ──────────────────────────────────────────────────────────────────
opt.ignorecase = true
opt.smartcase = true -- ...unless the pattern contains a capital
opt.hlsearch = true
opt.incsearch = true
-- fff is the primary search interface and needs no external binary. This only
-- affects the builtin :grep / :vimgrep -> quickfix workflow, so it is guarded:
-- if ripgrep is absent, Neovim keeps its default grepprg rather than erroring.
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep"
  opt.grepformat = "%f:%l:%c:%m"
end

-- ── Splits ──────────────────────────────────────────────────────────────────
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen" -- do not scroll existing text when a split opens

-- ── Files & undo ────────────────────────────────────────────────────────────
-- Undo history survives across sessions. Lives under stdpath("state"), which
-- resolves to ~/.local/state/nvim-lab -- isolated from the main config.
opt.undofile = true
opt.undolevels = 10000
opt.swapfile = false -- undofile + git covers this; swap files mostly annoy
opt.backup = false
opt.writebackup = false
opt.autowrite = true
opt.updatetime = 200 -- drives CursorHold; also how fast gitsigns/diagnostics react

-- ── Behavior ────────────────────────────────────────────────────────────────
opt.mouse = "a"
opt.clipboard = "unnamedplus" -- share the system clipboard
opt.timeoutlen = 300 -- how long which-key waits before popping up
opt.completeopt = { "menu", "menuone", "noselect" }
opt.wildmode = "longest:full,full"
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- ── Folding ─────────────────────────────────────────────────────────────────
-- Treesitter-backed folding is wired up in plugins/nvim-treesitter.lua. These
-- are the defaults it builds on. foldlevel 99 = everything starts unfolded.
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- ── Providers ───────────────────────────────────────────────────────────────
-- Disabled outright. Each one Neovim probes for costs startup time, and this
-- config has no Perl/Ruby/Node remote plugins.
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- Python3 provider stays ENABLED: molten-nvim is a remote plugin and cannot
-- work without it. Pointing at a dedicated venv rather than /usr/bin/python3
-- keeps pynvim and jupyter_client out of the system interpreter, and means a
-- system Python upgrade cannot silently break the editor.
--
-- Create it with:
--     uv venv ~/.venvs/nvim
--     uv pip install --python ~/.venvs/nvim/bin/python pynvim jupyter_client
--
-- If the venv is missing, fall back to the system interpreter so that a fresh
-- machine still starts (molten simply will not work until the venv exists).
local nvim_py = vim.env.HOME .. "/.venvs/nvim/bin/python"
if vim.uv.fs_stat(nvim_py) then
  vim.g.python3_host_prog = nvim_py
end
