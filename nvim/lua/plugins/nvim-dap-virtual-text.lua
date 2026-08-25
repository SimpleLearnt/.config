-- nvim-dap-virtual-text :: show variable values inline while stepping
--
-- Annotates each line with the current value of the variables on it, so you
-- read state in the source rather than switching to the scopes pane. Uses
-- treesitter to find the variables, so it understands scope rather than
-- pattern-matching identifiers.

return {
  "theHamsta/nvim-dap-virtual-text",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-treesitter/nvim-treesitter",
  },

  opts = {
    enabled = true,
    highlight_changed_variables = true, -- changed values stand out per step
    show_stop_reason = true,
    -- Off: commented-out virtual text on every line above the code makes
    -- dense functions unreadable.
    virt_text_pos = "eol",
    all_frames = false, -- current frame only, not every frame on the stack
  },
}
