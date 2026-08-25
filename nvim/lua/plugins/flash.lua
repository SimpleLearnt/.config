-- flash :: jump anywhere visible by typing two characters and a label
--
-- Replaces repeated w / } / n hunting. Also enhances f/t/F/T so they work
-- across lines with labels for the matches beyond the first.
--
-- flash owns bare `s` and `S`. That is why mini.surround is on the `gs` prefix
-- in this config rather than its own default `s` -- see mini-surround.lua.

return {
  "folke/flash.nvim",
  event = "VeryLazy",

  opts = {
    modes = {
      -- Label matches while typing a / and ? search too.
      search = { enabled = true },
      -- f/t/F/T get labels and multi-line reach.
      char = {
        enabled = true,
        jump_labels = true,
      },
    },
  },

  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash jump",
    },
    {
      "S",
      mode = { "n", "x", "o" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash treesitter node",
    },
    {
      -- Operator-pending only: `yr` then a label yanks a remote region without
      -- moving the cursor there.
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote flash",
    },
    {
      "R",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Treesitter search",
    },
    {
      -- Command-line mode only, so it does not collide with harpoon's
      -- normal-mode <C-s>.
      "<c-s>",
      mode = { "c" },
      function()
        require("flash").toggle()
      end,
      desc = "Toggle flash search",
    },
  },
}
