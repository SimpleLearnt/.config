-- nvim-ts-autotag :: auto-close and auto-rename HTML/JSX tags
--
-- Type `<div>` and the closing `</div>` appears. Rename either half and the
-- other follows. Uses the treesitter tree, so it understands nesting rather
-- than pattern-matching angle brackets.

return {
  "windwp/nvim-ts-autotag",
  dependencies = { "nvim-treesitter/nvim-treesitter" },

  -- Only loaded for filetypes that actually have tags -- there is no reason to
  -- pay for this in a Python or CUDA buffer.
  ft = {
    "html",
    "xml",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "svelte",
    "vue",
    "markdown",
  },

  opts = {
    opts = {
      enable_close = true, -- auto close on trailing >
      enable_rename = true, -- rename the pair when you edit one side
      enable_close_on_slash = false, -- do not close on </, which fights typing
    },
  },
}
