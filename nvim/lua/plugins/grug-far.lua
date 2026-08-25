-- grug-far :: project-wide find and replace
--
-- Opens a normal buffer listing every match. You edit the search, the
-- replacement, and the file filters in place, see the results update live, and
-- only then commit the change. Nothing is modified until you say so, and
-- everything is undoable.
--
-- Backed by ripgrep (15.2.0 installed). This is the one job fff cannot do --
-- it searches but never replaces.
--
-- Buffer-local keymaps inside the grug-far window use <localleader>, which
-- init.lua sets to backslash.

return {
  "MagicDuck/grug-far.nvim",
  cmd = { "GrugFar", "GrugFarWithin" },

  opts = {
    headerMaxWidth = 80,
    -- Open as a vertical split rather than a full window, so the file you are
    -- changing stays visible next to the results.
    windowCreationCommand = "vsplit",
  },

  keys = {
    {
      "<leader>fr",
      function()
        require("grug-far").open({ transient = true })
      end,
      desc = "Find and replace (project)",
    },
    {
      "<leader>fR",
      function()
        require("grug-far").open({
          transient = true,
          prefills = { search = vim.fn.expand("<cword>") },
        })
      end,
      desc = "Find and replace word under cursor",
    },
    {
      -- Visual mode: `:GrugFarWithin` limits the replacement to the selected
      -- range instead of the whole project.
      "<leader>fr",
      "<cmd>GrugFarWithin<cr>",
      mode = "x",
      desc = "Find and replace in selection",
    },
  },
}
